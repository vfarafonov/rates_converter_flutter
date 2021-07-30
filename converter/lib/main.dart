import 'package:converter/currency/bloc/currency_converter_bloc.dart';
import 'package:converter/currency/bloc/data/currency_rates_data_source.dart';
import 'package:converter/ui/home/home_route.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'currency/bloc/data/currency_rates_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    EquatableConfig.stringify = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            var currencyRatesRepository = CurrencyRatesRepository(
              remoteDataSource: CurrencyRatesDataSource(),
            );
            return CurrencyConverterBloc(repository: currencyRatesRepository);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Currency rates',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeRoute(),
      ),
    );
  }
}
