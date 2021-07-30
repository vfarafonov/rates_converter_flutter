import 'package:converter/currency/models/currency.dart';

class CurrencyConfig {
  /// Defines known currencies
  static const List<Currency> supportedCurrencies = [
    const Currency(
        currencyCode: "USD",
        fullName: "United States Dollar",
        symbol: "\$"),
    const Currency(
        currencyCode: "EUR",
        fullName: "Euro",
        symbol: "€"),
    const Currency(
        currencyCode: "CHF",
        fullName: "Swiss Franc",
        symbol: "Fr"),
    const Currency(
        currencyCode: "KYD",
        fullName: "Cayman Islands Dollar",
        symbol: "\$"),
    const Currency(
        currencyCode: "GIP",
        fullName: "Gibraltar Pound",
        symbol: "£"),
    const Currency(
        currencyCode: "GBP",
        fullName: "British Pound Sterling",
        symbol: "£"),
    const Currency(
        currencyCode: "JOD",
        fullName: "Jordanian Dinar",
        symbol: "د.ا"),
    const Currency(
        currencyCode: "OMR",
        fullName: "Omani Rial",
        symbol: "ر.ع."),
    const Currency(
        currencyCode: "BHD",
        fullName: "Bahraini Dinar",
        symbol: "BD"),
    const Currency(
        currencyCode: "KWD",
        fullName: "Kuwaiti Dinar",
        symbol: "KD"),
  ];
}
