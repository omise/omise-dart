import 'package:test/test.dart';
import 'package:omise_dart/src/exceptions/omise_api_exception.dart';
import 'package:omise_dart/src/enums/currency.dart';

void main() {
  group('Currency enum tests', () {
    test(
        'fromString() should return the correct enum value for known currencies',
        () {
      expect(CurrencyExtension.fromString('THB'), equals(Currency.thb));
      expect(CurrencyExtension.fromString('JPY'), equals(Currency.jpy));
      expect(CurrencyExtension.fromString('USD'), equals(Currency.usd));
      expect(CurrencyExtension.fromString('EUR'), equals(Currency.eur));
      expect(CurrencyExtension.fromString('GBP'), equals(Currency.gbp));
      expect(CurrencyExtension.fromString('SGD'), equals(Currency.sgd));
      expect(CurrencyExtension.fromString('AUD'), equals(Currency.aud));
      expect(CurrencyExtension.fromString('CHF'), equals(Currency.chf));
      expect(CurrencyExtension.fromString('CNY'), equals(Currency.cny));
      expect(CurrencyExtension.fromString('DKK'), equals(Currency.dkk));
      expect(CurrencyExtension.fromString('HKD'), equals(Currency.hkd));
    });

    test('fromString() should throw OmiseApiException for unknown currency',
        () {
      expect(
          () => CurrencyExtension.fromString('XYZ'),
          throwsA(isA<OmiseApiException>()
              .having((e) => e.message, 'message', 'Unknown currency: XYZ')));
    });

    test('fromString() should be case-insensitive', () {
      expect(CurrencyExtension.fromString('thb'), equals(Currency.thb));
      expect(CurrencyExtension.fromString('jpy'), equals(Currency.jpy));
      expect(CurrencyExtension.fromString('usd'), equals(Currency.usd));
    });
  });
}
