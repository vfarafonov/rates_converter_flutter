import 'package:converter/currency/bloc/bloc.dart';
import 'package:converter/currency/models/conversion_amount.dart';
import 'package:converter/currency/ui/widgets/currency_card/currency_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Primary widgets for rates convertion
class CurrencyRateView extends StatelessWidget {
  final ConversionAmount baseAmount;
  final ConversionAmount targetAmount;

  const CurrencyRateView({Key? key, required this.baseAmount, required this.targetAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CurrencyCard(
          amountOnTop: false,
          amount: baseAmount,
          onAmountChanged: (newAmount) {
            BlocProvider.of<CurrencyConverterBloc>(context).add(CurrencyConverterEventChangeBaseAmount(newAmount));
          },
          onCurrencyChanged: (newCurrency) {
            BlocProvider.of<CurrencyConverterBloc>(context).add(CurrencyConverterEventChangeBaseCurrency(newCurrency));
          },
        ),
        RawMaterialButton(
          fillColor: Colors.white,
          shape: CircleBorder(),
          child: Icon(Icons.swap_horiz_outlined),
          onPressed: () {
            BlocProvider.of<CurrencyConverterBloc>(context).add(CurrencyConverterEventSwapCurrency());
          },
        ),
        CurrencyCard(
          amountOnTop: true,
          amount: targetAmount,
          onCurrencyChanged: (newCurrency) {
            BlocProvider.of<CurrencyConverterBloc>(context)
                .add(CurrencyConverterEventChangeTargetCurrency(newCurrency));
          },
        ),
      ],
    );
  }
}
