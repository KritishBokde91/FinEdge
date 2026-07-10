package com.genzloop.finsight_ai

import android.Manifest
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.pennywiseai.parser.core.TransactionType
import com.pennywiseai.parser.core.bank.BankParserFactory
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.genzloop.finsight_ai/sms"
    private val PERMISSION_REQUEST_CODE = 101
    private val NOTIFICATION_PERMISSION_REQUEST_CODE = 102
    private val CONTACTS_PERMISSION_REQUEST_CODE = 103
    private var pendingSmsPermissionResult: MethodChannel.Result? = null
    private var pendingNotificationPermissionResult: MethodChannel.Result? = null
    private var pendingContactsPermissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkSmsPermission" -> {
                    result.success(hasSmsPermissions())
                }
                "requestSmsPermission" -> {
                    requestSmsPermissions(result)
                }
                "checkNotificationPermission" -> {
                    result.success(hasNotificationPermission())
                }
                "requestNotificationPermission" -> {
                    requestNotificationPermission(result)
                }
                "checkContactsPermission" -> {
                    result.success(hasContactsPermissions())
                }
                "requestContactsPermission" -> {
                    requestContactsPermissions(result)
                }
                "resolveContact" -> {
                    val phone = call.argument<String>("phone").orEmpty()
                    result.success(queryContactName(phone))
                }
                "readSms" -> {
                    val limit = numberArgument(call, "limit")?.toInt() ?: 1000
                    val since = numberArgument(call, "since") ?: 0L
                    val smsList = readInboxSms(limit, since)
                    result.success(smsList)
                }
                "parseSms" -> {
                    val sender = call.argument<String>("sender").orEmpty()
                    val body = call.argument<String>("body").orEmpty()
                    val timestamp = numberArgument(call, "timestamp") ?: System.currentTimeMillis()
                    result.success(parseTransaction(sender, body, timestamp))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            PERMISSION_REQUEST_CODE -> {
                pendingSmsPermissionResult?.success(hasSmsPermissions())
                pendingSmsPermissionResult = null
            }
            NOTIFICATION_PERMISSION_REQUEST_CODE -> {
                pendingNotificationPermissionResult?.success(hasNotificationPermission())
                pendingNotificationPermissionResult = null
            }
            CONTACTS_PERMISSION_REQUEST_CODE -> {
                pendingContactsPermissionResult?.success(hasContactsPermissions())
                pendingContactsPermissionResult = null
            }
        }
    }

    private fun hasSmsPermissions(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSmsPermissions(result: MethodChannel.Result) {
        if (hasSmsPermissions()) {
            result.success(true)
            return
        }

        pendingSmsPermissionResult?.error(
            "permission_request_replaced",
            "A newer SMS permission request replaced this one.",
            null
        )
        pendingSmsPermissionResult = result
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.READ_SMS,
                Manifest.permission.RECEIVE_SMS
            ),
            PERMISSION_REQUEST_CODE
        )
    }

    private fun hasNotificationPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        if (hasNotificationPermission()) {
            result.success(true)
            return
        }

        pendingNotificationPermissionResult?.error(
            "permission_request_replaced",
            "A newer notification permission request replaced this one.",
            null
        )
        pendingNotificationPermissionResult = result
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                NOTIFICATION_PERMISSION_REQUEST_CODE
            )
        } else {
            result.success(true)
            pendingNotificationPermissionResult = null
        }
    }

    private fun readInboxSms(limit: Int, since: Long): List<Map<String, Any?>> {
        val cutoffTime = if (since > 0L) since else System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000
        android.util.Log.d("MainActivity", "readInboxSms called with limit=$limit, since=$since, cutoffTime=$cutoffTime")
        val list = ArrayList<Map<String, Any?>>()
        val uri = Uri.parse("content://sms/inbox")
        val projection = arrayOf("_id", "address", "body", "date")
        val selection = "date >= ?"
        val selectionArgs = arrayOf(cutoffTime.toString())
        val sortOrder = "date DESC"

        try {
            val cursor = contentResolver.query(uri, projection, selection, selectionArgs, sortOrder)
            android.util.Log.d("MainActivity", "Cursor queried. Count = ${cursor?.count ?: 0}")
            cursor?.use {
                val idIdx = cursor.getColumnIndex("_id")
                val addressIdx = cursor.getColumnIndex("address")
                val bodyIdx = cursor.getColumnIndex("body")
                val dateIdx = cursor.getColumnIndex("date")

                var count = 0
                while (cursor.moveToNext() && count < limit) {
                    val sender = if (addressIdx >= 0) cursor.getString(addressIdx).orEmpty() else ""
                    
                    // Discard promotional (-P) and government (-G) messages
                    val upperSender = sender.uppercase()
                    if (upperSender.endsWith("-P") || upperSender.endsWith("-G")) {
                        continue
                    }

                    val body = if (bodyIdx >= 0) cursor.getString(bodyIdx).orEmpty() else ""
                    val date = if (dateIdx >= 0) cursor.getLong(dateIdx) else 0L
                    val map = HashMap<String, Any?>()
                    map["id"] = if (idIdx >= 0) cursor.getString(idIdx).orEmpty() else ""
                    map["address"] = sender
                    map["body"] = body
                    map["date"] = date
                    
                    val parsed = parseTransaction(sender, body, date)
                    if (parsed != null) {
                        android.util.Log.d("MainActivity", "Successfully parsed transaction from $sender: amount=${parsed["amount"]}, type=${parsed["transactionType"]}")
                        map["parsed"] = parsed
                    }
                    list.add(map)
                    count++
                }
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error querying inbox", e)
        }
        android.util.Log.d("MainActivity", "readInboxSms completed. Returning ${list.size} messages.")
        return list
    }

    private fun parseTransaction(
        sender: String,
        body: String,
        timestamp: Long
    ): Map<String, Any?>? {
        if (sender.isBlank() || body.isBlank()) return null

        val parsed = try {
            BankParserFactory.parse(body, sender, timestamp)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        } ?: return null

        val transactionId = parsed.transactionHash
            ?.takeIf { it.isNotBlank() }
            ?: parsed.generateTransactionId()
        val merchant = normalizeMerchantName(
            parsed.merchant?.takeIf { it.isNotBlank() }
                ?: parsed.bankName.takeIf { it.isNotBlank() }
                ?: sender
        )

        return mapOf(
            "id" to transactionId,
            "amount" to parsed.amount.toDouble(),
            "transactionType" to toFinsightDirection(parsed.type),
            "pennywiseType" to parsed.type.name,
            "merchant" to merchant,
            "reference" to parsed.reference,
            "account" to parsed.accountLast4,
            "balance" to parsed.balance?.toDouble(),
            "creditLimit" to parsed.creditLimit?.toDouble(),
            "bank" to parsed.bankName,
            "sender" to parsed.sender,
            "timestamp" to parsed.timestamp,
            "currency" to parsed.currency,
            "accountSource" to accountSource(parsed.bankName, parsed.accountLast4, sender),
            "isFromCard" to parsed.isFromCard,
            "isMobileWallet" to parsed.isMobileWallet,
            "fromAccount" to parsed.fromAccount,
            "toAccount" to parsed.toAccount
        )
    }

    private fun toFinsightDirection(type: TransactionType): String {
        return when (type) {
            TransactionType.INCOME -> "credit"
            else -> "debit"
        }
    }

    private fun accountSource(bankName: String, accountLast4: String?, sender: String): String {
        val source = bankName.takeIf { it.isNotBlank() } ?: sender
        return if (accountLast4.isNullOrBlank()) source else "$source ****$accountLast4"
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

    private fun numberArgument(call: MethodCall, name: String): Long? {
        return when (val value = call.argument<Any>(name)) {
            is Number -> value.toLong()
            is String -> value.toLongOrNull()
            else -> null
        }
    }

    private fun hasContactsPermissions(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_CONTACTS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestContactsPermissions(result: MethodChannel.Result) {
        if (hasContactsPermissions()) {
            result.success(true)
            return
        }

        pendingContactsPermissionResult?.error(
            "permission_request_replaced",
            "A newer contacts permission request replaced this one.",
            null
        )
        pendingContactsPermissionResult = result
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.READ_CONTACTS),
            CONTACTS_PERMISSION_REQUEST_CODE
        )
    }

    private fun queryContactName(phoneLast10: String): String? {
        if (phoneLast10.length != 10 || !phoneLast10.all { it.isDigit() }) return null
        if (!hasContactsPermissions()) return null

        val uri = Uri.withAppendedPath(
            android.provider.ContactsContract.PhoneLookup.CONTENT_FILTER_URI,
            Uri.encode(phoneLast10)
        )
        val projection = arrayOf(android.provider.ContactsContract.PhoneLookup.DISPLAY_NAME)
        return try {
            contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val idx = cursor.getColumnIndex(android.provider.ContactsContract.PhoneLookup.DISPLAY_NAME)
                    if (idx >= 0) cursor.getString(idx) else null
                } else null
            }
        } catch (e: Exception) {
            null
        }
    }
}
