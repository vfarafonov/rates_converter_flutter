import 'package:converter/currency/bloc/currency_config.dart';
import 'package:converter/currency/models/conversion_amount.dart';
import 'package:converter/currency/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays info about currency and allows to switch it
class CurrencyCard extends StatefulWidget {
  final ConversionAmount amount;
  final Function(double)? onAmountChanged;
  final Function(Currency) onCurrencyChanged;

  const CurrencyCard({Key? key, required this.amount, this.onAmountChanged, required this.onCurrencyChanged})
      : super(key: key);

  @override
  _CurrencyCardState createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.amount.currency.symbol} ${widget.amount.currency.currencyCode}"),
                DropdownButton(
                  value: widget.amount.currency,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  underline: null,
                  onChanged: (Currency? value) {
                    if (value != null) {
                      widget.onCurrencyChanged(value);
                    }
                  },
                  items: CurrencyConfig.supportedCurrencies
                      .map((Currency currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency.fullName),
                          ))
                      .toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text(widget.amount.currency.symbol),
                SizedBox(width: 8),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 48,
                    maxWidth: 128,
                  ),
                  child: _getAmountWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Returns TextField if input is allowed and Text otherwise
  Widget _getAmountWidget() {
    if (widget.onAmountChanged == null) {
      // There is no watcher therefore just displaying the amount
      return Text(_getUserFriendlyAmount(widget.amount.majorUnitAmount));
    } else {
      return _AmountInputView(
        onAmountChanged: widget.onAmountChanged!,
        currentAmount: widget.amount.majorUnitAmount,
      );
    }
  }
}

class _AmountInputView extends StatefulWidget {
  const _AmountInputView({
    Key? key,
    required this.currentAmount,
    required this.onAmountChanged,
  }) : super(key: key);

  final double currentAmount;
  final Function(double) onAmountChanged;

  @override
  __AmountInputViewState createState() => __AmountInputViewState();
}

class __AmountInputViewState extends State<_AmountInputView> {
  late TextEditingController _inputController;

  @override
  void initState() {
    _inputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (double.tryParse(_inputController.text) != widget.currentAmount) {
      _inputController.text = _getUserFriendlyAmount(widget.currentAmount);
    }
    return IntrinsicWidth(
      child: TextField(
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        controller: _inputController,
        onChanged: (value) {
          var newAmount = double.tryParse(value);
          if (newAmount != null) {
            widget.onAmountChanged(newAmount);
          }
        },
      ),
    );
  }
}

String _getUserFriendlyAmount(double amount) => amount.toStringAsFixed(2);
