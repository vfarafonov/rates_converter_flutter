import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Provides remote info about rates
class CurrencyRatesDataSource {
  static const _URL_BASE = "api.exchangeratesapi.io";
  static const _URL_RATES_PATH = "/v1/latest";

  /// Returns currency rates map where Key is a currency code and a value is its rate compared to some base currency
  Future<Map<String, double>> getCurrencyRates() async {
    final queryParameters = {
      'access_key': '4c11cc4e326e459ed1530057dda764fc',
    };
    var uri = Uri.http(_URL_BASE, _URL_RATES_PATH, queryParameters);

    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      return compute(_parseRatesResponse, response.body);
    } else {
      throw Exception("Failed to fetch rates. Status code: ${response.statusCode}. Body: ${response.body}");
    }
  }

  static Map<String, double> _parseRatesResponse(String responseBody) {
    final rates = jsonDecode(responseBody)["rates"];
    return Map<String, double>.from(rates.map((key, value) => MapEntry(key, value.toDouble())));
  }
}
