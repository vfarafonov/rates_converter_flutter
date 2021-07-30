import 'package:converter/currency/bloc/data/currency_rates_data_source.dart';

/// Provides and caches rates
class CurrencyRatesRepository {
  final CurrencyRatesDataSource _remoteDataSource;

  Map<String, double>? _currencyRates;

  CurrencyRatesRepository({required CurrencyRatesDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  /// Returns currency rates map where Key is a currency code and a value is its rate compared to some base currency
  Future<Map<String, double>> getCurrencyRates() async {
    if (_currencyRates != null) return _currencyRates!;

    _currencyRates = await _remoteDataSource.getCurrencyRates();

    return _currencyRates!;
  }
}
