import 'package:flutter_test/flutter_test.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/sms_parser.dart';

void main() {
  group('SmsParser Parsing and Regex Engine Tests', () {
    test('Should parse M-Pesa debit transaction correctly', () {
      const msg = 'TXZ99281 Sent to Safaricom Supermarket Ksh 4,500. Balance Ksh 23,200.';
      final result = SmsParser.parseMessage('MPESA', msg);

      expect(result.transactionType, 'debit');
      expect(result.amount, 4500.0);
      expect(result.currency, 'Ksh');
      expect(result.merchant, 'Safaricom');
      expect(result.availableBalance, 23200.0);
      expect(result.referenceNumber, 'TXZ99281');
    });

    test('Should parse M-Pesa utility token payment correctly', () {
      const msg = 'TXA88127 Paid Ksh 6,200 to Kenya Power. Ref: ELEC-TOKEN.';
      final result = SmsParser.parseMessage('MPESA', msg);

      expect(result.transactionType, 'debit');
      expect(result.amount, 6200.0);
      expect(result.merchant, 'Kenya Power');
      expect(result.category, 'Bills');
    });

    test('Should parse Indian Bank debit transaction correctly', () {
      const msg = 'Debited Rs.500 from A/C X1234 on 05-07-26 to Zomato. Ref: 66281928.';
      final result = SmsParser.parseMessage('HDFC-BANK', msg);

      expect(result.transactionType, 'debit');
      expect(result.amount, 500.0);
      expect(result.merchant, 'A/C X1234');
      expect(result.category, 'Other');
      expect(result.account, '1234');
      expect(result.referenceNumber, '66281928');
    });

    test('Should parse Indian Bank credit transaction correctly', () {
      const msg = 'Your A/C X5678 has been credited with Rs.15,000 on 01-07-26 by Salary. Ref: UPI:627192.';
      final result = SmsParser.parseMessage('SBI-BANK', msg);

      expect(result.transactionType, 'credit');
      expect(result.amount, 15000.0);
      expect(result.category, 'Salary');
      expect(result.account, '5678');
    });
  });
}
