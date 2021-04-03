import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'FE0B9383-6ED6-4AE3-BE30-8DC924052B33';

class CoinData {
  Map<String, String> currencyRates = {};

  Future<Map<String, String>> getCoinData(String currency) async {
    for (String crypto in cryptoList) {
      String url = '$coinAPIURL/$crypto/$currency';
      var uri = Uri.parse(url);

      try {
        var response = await http.get(
          uri,
          headers: {
            'X-CoinAPI-Key': '$apiKey',
          },
        );

        if (response.statusCode == HttpStatus.ok) {
          double value = jsonDecode(response.body)['rate'];
          currencyRates[crypto] = value.toStringAsFixed(0);
        }
      } catch (e) {
        print(e);
        throw 'Problem when getting this currency $currency';
      }
    }

    return currencyRates;
  }
}
