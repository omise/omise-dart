import 'package:omise_dart/src/enums/charge_status.dart';
import 'package:omise_dart/src/enums/payment_method_name.dart';
import 'package:omise_dart/src/extensions/date_time_no_milliseconds.dart';
import 'package:omise_dart/src/models/responses/charge.dart';
import 'package:test/test.dart';
import 'package:omise_dart/src/enums/currency.dart';
import 'mock_data.dart/charges_mock.dart';

void main() {
  group('Charge model tests', () {
    test('Charge fromJson() should parse correctly', () {
      final charge = Charge.fromJson(ChargesMock.getCharge);

      expect(charge.object, 'charge');
      expect(charge.id, 'chrg_63f4bvoea7xdc1je2ry');
      expect(charge.amount, 20000);
      expect(charge.net, 19219);
      expect(charge.fee, 730);
      expect(charge.feeVat, 51);
      expect(charge.currency, Currency.thb);
      expect(charge.status, ChargeStatus.pending);
      expect(charge.paid, isFalse);
      expect(charge.refundable, isFalse);
      expect(charge.expiresAt?.toIso8601StringWithoutMilliseconds(),
          '2025-04-17T12:46:51Z');
      expect(charge.authorizeUri,
          'https://pay.omise.co/payments/pay2_63f4bvogrbd77greqd8/authorize?acs=false');

      // Source
      expect(charge.source, isNotNull);
      expect(charge.source!.id, 'src_63f4bvo6mlqr3c4gs2g');
      expect(charge.source!.flow, 'offline');
      expect(charge.source!.type, PaymentMethodName.promptpay);
      expect(charge.source!.chargeStatus, ChargeStatus.pending);

      // Barcode
      final barcode = charge.source!.scannableCode;
      expect(barcode, isNotNull);
      expect(barcode!.type, 'qr');

      // Document
      final image = barcode.image;
      expect(image, isNotNull);
      expect(image!.id, 'docu_63f4bvwudrafxihuyxo');
      expect(image.downloadUri,
          'https://api.omise.co/charges/chrg_63f4bvoea7xdc1je2ry/documents/docu_63f4bvwudrafxihuyxo/downloads/23F760B90243FD8F');
    });

    test('Charge toJson() should serialize correctly', () {
      final charge = Charge.fromJson(ChargesMock.getCharge);
      final json = charge.toJson();

      expect(json['id'], charge.id);
      expect(json['refunds'], charge.refunds);
      expect(json['dispute'], charge.dispute);
      expect(json['status'], charge.status.name);
    });
    group('CardModel', () {
      test('fromJson and toJson should be consistent', () {
        final cardJson = {
          'object': 'card',
          'id': 'card_123',
          'livemode': true,
          'location': '/cards/card_123',
          'bank': 'SCB',
          'brand': 'Visa',
          'city': 'Bangkok',
          'country': 'TH',
          'created_at': '2025-04-17T12:41:51Z',
          'deleted': false,
          'expiration_month': 12,
          'expiration_year': 2030,
          'financing': 'credit',
          'fingerprint': 'fp_test',
          'first_digits': '424242',
          'last_digits': '4242',
          'name': 'John Doe',
          'phone_number': '0800000000',
          'postal_code': '10110',
          'security_code_check': true,
          'state': 'Bangkok',
          'street1': '123 Main St',
          'street2': 'Floor 1',
          'tokenization_method': 'apple_pay',
        };

        final card = CardModel.fromJson(cardJson);
        expect(card.toJson(), equals(cardJson));
      });
    });
    group('Dispute', () {
      test('fromJson and toJson should be consistent', () {
        final disputeJson = {
          'id': 'dspt_123',
          'object': 'dispute',
          'amount': 10000,
          'currency': 'thb',
          'status': 'pending',
          'charge': 'chrg_123',
          'created': '2025-04-17T12:46:51Z',
          'closed_at': null,
          'message': 'Customer claimed fraud.',
          'metadata': {'reason': 'fraud'},
          'documents': [
            {'id': 'doc_123', 'type': 'evidence'}
          ]
        };

        final dispute = Dispute.fromJson(disputeJson);
        expect(dispute.toJson(), equals(disputeJson));
      });
    });
    group('LinkedAccount', () {
      test('fromJson and toJson should be consistent', () {
        final linkedAccountJson = {
          'object': 'linked_account',
          'id': 'link_123',
          'livemode': false,
          'location': '/linked_accounts/link_123',
          'registration_uri': 'https://omise.co/register',
          'return_uri': 'https://yourapp.com/callback',
          'type': 'alipay',
          'status': 'verified',
          'last_digits': '1234',
          'metadata': {'platform': 'test'},
          'failure_code': null,
          'failure_message': null,
          'registered_at': '2025-04-17T12:46:51Z',
          'expires_at': null,
          'created_at': '2025-04-17T12:46:51Z',
        };

        final linkedAccount = LinkedAccount.fromJson(linkedAccountJson);
        expect(linkedAccount.toJson(), equals(linkedAccountJson));
      });
    });
    group('Refund', () {
      test('fromJson and toJson should be consistent', () {
        final refundJson = {
          'object': 'refund',
          'id': 'rfnd_123',
          'location': '/refunds/rfnd_123',
          'livemode': false,
          'voided': false,
          'currency': 'thb',
          'amount': 5000,
          'metadata': {'note': 'partial refund'},
          'charge': 'chrg_123',
          'capture': null,
          'terminal': 'web',
          'transaction': 'txn_123',
          'status': 'successful',
          'funding_amount': 4900,
          'funding_currency': 'thb',
          'created_at': '2025-04-17T12:46:51Z',
          'acquirer_reference_number': 'ref_abc123',
          'merchant_name': 'Acme Corp',
          'merchant_uid': 'merchant_001',
          'approval_code': 'apprv_123',
        };

        final refund = Refund.fromJson(refundJson);
        expect(refund.toJson(), equals(refundJson));
      });
    });
    group('UnmanagedPayment', () {
      test('fromJson and toJson should be consistent', () {
        final unmanagedPaymentJson = {
          "authorization_code": "auth",
          "backend_name": "name",
          "iin": "iname",
          "merchant_reference": "mref"
        };

        final payment = UnmanagedPayment.fromJson(unmanagedPaymentJson);
        expect(payment.toJson(), equals(unmanagedPaymentJson));
      });
    });
  });
}
