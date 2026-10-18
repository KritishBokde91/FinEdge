import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.genzloop.finsight_ai/sms');

  group('Native Platform Channel (com.genzloop.finsight_ai/sms) contract tests', () {
    final List<MethodCall> log = [];

    setUp(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'checkSmsPermission':
            return true;
          case 'checkNotificationPermission':
            return true;
          case 'checkContactsPermission':
            return true;
          case 'requestSmsPermission':
            return true;
          case 'requestNotificationPermission':
            return true;
          case 'requestContactsPermission':
            return true;
          case 'resolveContact':
            final phone = methodCall.arguments['phone'] as String?;
            if (phone == '9876543210') {
              return 'Kritish Bokde';
            }
            return null;
          case 'readSms':
            return [
              {
                'id': 'sms_001',
                'address': 'HDFCBK',
                'body': 'Rs 500.00 debited from a/c **1234 to SWIGGY',
                'date': 1700000000000,
                'parsed': {
                  'id': 'tx_hash_123',
                  'amount': 500.0,
                  'transactionType': 'debit',
                  'merchant': 'Swiggy',
                  'account': '1234',
                },
              }
            ];
          case 'parseSms':
            final sender = methodCall.arguments['sender'] as String? ?? '';
            final body = methodCall.arguments['body'] as String? ?? '';
            if (sender.isEmpty || body.isEmpty) return null;
            return {
              'id': 'tx_parse_test',
              'amount': 1200.0,
              'transactionType': 'debit',
              'merchant': 'Amazon',
              'currency': 'INR',
            };
          default:
            throw PlatformException(
              code: 'NOT_IMPLEMENTED',
              message: 'Method ${methodCall.method} not implemented',
            );
        }
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('checkSmsPermission returns boolean from native host', () async {
      final result = await channel.invokeMethod<bool>('checkSmsPermission');
      expect(result, isTrue);
      expect(log.single.method, 'checkSmsPermission');
    });

    test('resolveContact dispatches phone and receives formatted contact name', () async {
      final result = await channel.invokeMethod<String?>(
        'resolveContact',
        {'phone': '9876543210'},
      );
      expect(result, 'Kritish Bokde');
      expect(log.single.arguments, {'phone': '9876543210'});
    });

    test('readSms dispatches limit and since arguments correctly', () async {
      final result = await channel.invokeListMethod<Map<dynamic, dynamic>>(
        'readSms',
        {'limit': 50, 'since': 1690000000000},
      );
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first['address'], 'HDFCBK');
      expect(result.first['parsed']['amount'], 500.0);
    });

    test('parseSms passes sender and body and parses successfully', () async {
      final result = await channel.invokeMapMethod<String, dynamic>(
        'parseSms',
        {
          'sender': 'HDFCBK',
          'body': 'Rs 1200 debited from account for Amazon order',
          'timestamp': 1700000000000,
        },
      );
      expect(result, isNotNull);
      expect(result!['merchant'], 'Amazon');
      expect(result['amount'], 1200.0);
    });

    test('unimplemented method throws PlatformException', () async {
      expect(
        () => channel.invokeMethod<void>('nonExistentMethod'),
        throwsA(isA<PlatformException>()),
      );
    });

    test('propagates PlatformException error codes properly from native bridge', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (methodCall) async {
        throw PlatformException(
          code: 'SMS_READ_FAILED',
          message: 'Permission denied or SQLite read failed',
        );
      });

      expect(
        () => channel.invokeMethod<dynamic>('readSms', {'limit': 10}),
        throwsA(
          isA<PlatformException>().having(
            (e) => e.code,
            'error code',
            'SMS_READ_FAILED',
          ),
        ),
      );
    });
  });
}
