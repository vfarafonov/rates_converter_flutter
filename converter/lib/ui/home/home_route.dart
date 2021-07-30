import 'package:converter/currency/bloc/currency_converter_bloc.dart';
import 'package:converter/currency/ui/currency_rate_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeRoute extends StatelessWidget {
  static const ROUTE_NAME = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency converter'),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: BlocBuilder<CurrencyConverterBloc, CurrencyConverterState>(
          builder: (context, state) {
            if (state is CurrencyConverterStateInitial) {
              return CircularProgressIndicator();
            } else if (state is CurrencyConverterStateError) {
              // TODO(vfarafonov, 7/30/21): Add reset button.
              final message = state.message;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Error: $message"),
                  TextButton(
                    child: Text("Retry"),
                    onPressed: () {
                      BlocProvider.of<CurrencyConverterBloc>(context).add(CurrencyConverterEventInit());
                    },
                  )
                ],
              );
            } else if (state is CurrencyConverterStateRateAvailable) {
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CurrencyRateView(
                      baseAmount: state.baseAmount,
                      targetAmount: state.targetAmount,
                    ),
                  ),
                ),
              );
            } else {
              throw Exception("State not supported: $state");
            }
          },
        ),
      ),
    );
  }
}
