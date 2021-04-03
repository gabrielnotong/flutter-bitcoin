import 'dart:io' show Platform;

import 'package:bitcoin/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  CoinData coinData = CoinData();
  Map<String, String> _currencyRates;
  bool isWaiting = true;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) async {
        await coinData.getCoinData(value);
        setState(() {
          selectedCurrency = value;
          _currencyRates = coinData.currencyRates;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        String selectedCurrency = currenciesList[selectedIndex];
        await coinData.getCoinData(selectedCurrency);
        setState(() {
          _currencyRates = coinData.currencyRates;
          selectedCurrency = selectedCurrency;
        });
      },
      children: pickerItems,
    );
  }

  Future<void> getData() async {
    try {
      await coinData.getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        _currencyRates = coinData.currencyRates;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CryptoCard(
                  crypto: 'BTC',
                  rate: isWaiting ? '?' : _currencyRates['BTC'],
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  crypto: 'ETH',
                  rate: isWaiting ? '?' : _currencyRates['ETH'],
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  crypto: 'LTC',
                  rate: isWaiting ? '?' : _currencyRates['LTC'],
                  selectedCurrency: selectedCurrency,
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.rate,
    @required this.crypto,
    @required this.selectedCurrency,
  });

  final String rate;
  final String crypto;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          sprintf(
            "%s = %s %s",
            [
              '1 $crypto',
              rate,
              selectedCurrency,
            ],
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
