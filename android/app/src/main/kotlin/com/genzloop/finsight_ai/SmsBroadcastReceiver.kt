package com.genzloop.finsight_ai

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.database.sqlite.SQLiteDatabase
import android.os.Build
import android.provider.Telephony
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.pennywiseai.parser.core.ParsedTransaction
import com.pennywiseai.parser.core.TransactionType
import com.pennywiseai.parser.core.bank.BankParserFactory
import java.io.File
import java.util.UUID

/**
 * BroadcastReceiver that intercepts incoming SMS messages in real-time,
 * parses them for financial transactions using the Kotlin BankParserFactory,
 * saves them directly to the Drift SQLite database, and posts a notification.
 */
class SmsBroadcastReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "SmsBroadcastReceiver"
        private const val CHANNEL_ID = "transaction_alerts"
        private const val CHANNEL_NAME = "Transaction Alerts"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (messages.isNullOrEmpty()) return

        // Combine multi-part SMS messages by sender
        val smsMap = HashMap<String, StringBuilder>()
        var timestamp = System.currentTimeMillis()
        
        for (message in messages) {
            val sender = message.originatingAddress ?: continue
            val body = message.messageBody ?: continue
            timestamp = message.timestampMillis
            val builder = smsMap.getOrPut(sender) { StringBuilder() }
            builder.append(body)
        }

        for ((sender, bodyBuilder) in smsMap) {
            val upperSender = sender.uppercase()
            if (upperSender.endsWith("-P") || upperSender.endsWith("-G")) {
                Log.d(TAG, "Discarded promotional/government broadcast from $sender")
                continue
            }

            val body = bodyBuilder.toString()
            Log.d(TAG, "Intercepted SMS from $sender: $body")
            
            val parsed = try {
                BankParserFactory.parse(body, sender, timestamp)
            } catch (e: Exception) {
                Log.e(TAG, "Error parsing incoming SMS", e)
                null
            }

            if (parsed != null) {
                Log.d(TAG, "Successfully parsed transaction: ${parsed.amount} ${parsed.currency} from ${parsed.bankName}")
                val smsId = UUID.randomUUID().toString()
                
                // Write directly to the Drift SQLite database file
                saveToDatabase(context, smsId, sender, body, timestamp, parsed)
                
                // Post transaction notification
                showNotification(context, parsed)
            }
        }
    }

    private fun saveToDatabase(
        context: Context,
        smsId: String,
        sender: String,
        body: String,
        dateMs: Long,
        parsed: ParsedTransaction
    ) {
        val dbFile = File(context.filesDir.parentFile, "app_flutter/finsight.db")
        if (!dbFile.exists()) {
            Log.e(TAG, "Database file does not exist at: ${dbFile.absolutePath}")
            return
        }

        var db: SQLiteDatabase? = null
        try {
            db = SQLiteDatabase.openDatabase(dbFile.absolutePath, null, SQLiteDatabase.OPEN_READWRITE)
            db.beginTransaction()

            // 1. Insert into sms_metadata_table
            val smsValues = ContentValues().apply {
                put("id", smsId)
                put("sender", sender)
                put("body", body)
                put("timestamp", dateMs / 1000L) // Drift stores unix timestamp in seconds
                put("is_processed", 1)
                put("confidence", 0.95)
            }
            db.insertWithOnConflict("sms_metadata_table", null, smsValues, SQLiteDatabase.CONFLICT_REPLACE)

            // 2. Determine transaction properties
            val txId = parsed.transactionHash?.takeIf { it.isNotBlank() }
                ?: parsed.generateTransactionId()
            val isIncome = if (parsed.type == TransactionType.INCOME) 1 else 0
            val merchant = parsed.merchant?.takeIf { it.isNotBlank() }
                ?: parsed.bankName.takeIf { it.isNotBlank() }
                ?: sender
            val category = classifyCategory(merchant, body)
            val source = parsed.bankName.takeIf { it.isNotBlank() } ?: sender
            val accountSource = if (parsed.accountLast4.isNullOrBlank()) source else "$source ****${parsed.accountLast4}"

            // 3. Insert into transactions_table
            val txValues = ContentValues().apply {
                put("id", txId)
                put("sms_id", smsId)
                put("amount", parsed.amount.toDouble())
                put("merchant", normalizeMerchantName(merchant))
                put("category", category)
                put("timestamp", dateMs / 1000L) // Drift stores unix timestamp in seconds
                put("is_income", isIncome)
                put("account_source", accountSource)
                put("currency", parsed.currency)
                put("reference", parsed.reference)
            }
            db.insertWithOnConflict("transactions_table", null, txValues, SQLiteDatabase.CONFLICT_REPLACE)

            db.setTransactionSuccessful()
            Log.d(TAG, "Successfully auto-synced transaction to SQLite database: $txId")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to auto-sync transaction to SQLite database", e)
        } finally {
            db?.endTransaction()
            db?.close()
        }
    }

    private fun showNotification(context: Context, parsed: ParsedTransaction) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                if (ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                    Log.d(TAG, "Notification permission not granted, skipping notification")
                    return
                }
            }

            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT
                )
                notificationManager.createNotificationChannel(channel)
            }

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val direction = if (parsed.type == TransactionType.INCOME) "Credited" else "Debited"
            val title = "New Transaction - ${normalizeMerchantName(parsed.merchant ?: parsed.bankName)}"
            val body = "$direction: ${parsed.currency} ${parsed.amount} | Source: ${parsed.bankName}"

            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle(title)
                .setContentText(body)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .build()

            notificationManager.notify(parsed.generateTransactionId().hashCode(), notification)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to display transaction notification", e)
        }
    }

    private fun classifyCategory(merchant: String?, body: String): String {
        val m = merchant?.lowercase() ?: ""
        val b = body.lowercase()

        if (m.isNotEmpty()) {
            if (listOf("swiggy", "zomato", "restaurant", "cafe", "food", "pizza", "burger", "mcdonald", "kfc", "domino", "starbucks", "dunkin", "haldiram", "barbeque", "biryani").any { m.contains(it) }) return "Food"
            if (listOf("bigbasket", "blinkit", "zepto", "instamart", "dunzo", "jiomart", "dmart", "grofers", "grocery", "supermarket", "reliance fresh", "more megastore", "nature basket", "amazon", "flipkart", "myntra", "ajio", "meesho", "nykaa", "tata cliq", "shoppers stop", "lifestyle", "westside", "h&m", "zara", "decathlon", "pharmacy", "pharma", "medical", "hospital", "doctor", "apollo", "medplus", "netmeds", "practo", "1mg", "tata 1mg", "healthians").any { m.contains(it) }) return "Shopping"
            if (listOf("uber", "ola", "rapido", "irctc", "metro", "petrol", "diesel", "fuel", "parking", "toll", "fastag", "makemytrip", "goibibo", "cleartrip", "ixigo", "booking.com", "oyo", "hotel", "flight", "airline", "indigo", "spicejet", "air india", "vistara").any { m.contains(it) }) return "Transport"
            if (listOf("netflix", "spotify", "hotstar", "prime video", "youtube", "jiocinema", "google play", "apple", "zee5", "sonyliv", "dream11", "movie", "pvr", "inox", "bookmyshow").any { m.contains(it) }) return "Entertainment"
            if (listOf("airtel", "jio", "vi ", "vodafone", "bsnl", "recharge", "prepaid", "postpaid").any { m.contains(it) }) return "Recharge"
            if (listOf("electricity", "power", "kplc", "bescom", "msedcl", "gas bill", "water bill", "broadband", "internet", "wifi", "school", "college", "university", "course", "udemy", "coursera", "unacademy", "byju", "tuition").any { m.contains(it) }) return "Bills"
            if (listOf("groww", "zerodha", "upstox", "mutual fund", "sip", "lic", "insurance", "investment", "emi", "loan", "bajaj finserv", "slice", "simpl", "lazypay", "cred").any { m.contains(it) }) return "Investment"
        }

        if (b.contains("salary") || b.contains("stipend") || b.contains("wage")) return "Salary"
        if (b.contains("rent") || b.contains("lease")) return "Bills"
        if (b.contains("emi") || b.contains("loan") || b.contains("instalment")) return "Investment"
        if (b.contains("transfer") || b.contains("neft") || b.contains("imps") || b.contains("rtgs")) return "Investment"
        if (b.contains("atm") || b.contains("cash")) return "Shopping"
        if (b.contains("refund") || b.contains("reversal")) return "Salary"

        return "Other"
    }

    private fun normalizeMerchantName(name: String): String {
        val trimmed = name.trim()
        return if (trimmed == trimmed.uppercase()) {
            trimmed.lowercase().split(" ").joinToString(" ") { word ->
                if (word.isEmpty()) word else word.replaceFirstChar { it.uppercase() }
            }
        } else {
            trimmed
        }
    }
}
