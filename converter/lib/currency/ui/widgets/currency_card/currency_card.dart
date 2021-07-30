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
  final bool amountOnTop;

  const CurrencyCard(
      {Key? key,
      required this.amount,
      this.onAmountChanged,
      required this.onCurrencyChanged,
      required this.amountOnTop})
      : super(key: key);

  @override
  _CurrencyCardState createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard> {
  @override
  Widget build(BuildContext context) {
    final currencyRow = _CurrencyRow(
      currency: widget.amount.currency,
      onCurrencyChanged: widget.onCurrencyChanged,
    );
    final amountRow = _AmountRow(
      conversionAmount: widget.amount,
      onAmountChanged: widget.onAmountChanged,
    );
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.amountOnTop ? amountRow : currencyRow,
            widget.amountOnTop ? currencyRow : amountRow,
          ],
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final ConversionAmount _conversionAmount;
  final Function(double)? _onAmountChanged;

  const _AmountRow({
    Key? key,
    required conversionAmount,
    required onAmountChanged,
  })  : _conversionAmount = conversionAmount,
        _onAmountChanged = onAmountChanged,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _conversionAmount.currency.symbol,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.blue,
              ),
        ),
        SizedBox(width: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 48,
            maxWidth: 128,
          ),
          child: _getAmountWidget(context),
        ),
      ],
    );
  }

  /// Returns TextField if input is allowed and Text otherwise
  Widget _getAmountWidget(BuildContext context) {
    if (_onAmountChanged == null) {
      // There is no watcher therefore just displaying the amount
      return Text(
        _getUserFriendlyAmount(_conversionAmount.majorUnitAmount),
        style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Colors.blue,
            ),
      );
    } else {
      return _AmountInputView(
        onAmountChanged: _onAmountChanged!,
        currentAmount: _conversionAmount.majorUnitAmount,
      );
    }
  }
}

class _CurrencyRow extends StatelessWidget {
  final Currency _currency;
  final Function(Currency) _onCurrencyChanged;

  const _CurrencyRow({
    Key? key,
    required currency,
    required onCurrencyChanged,
  })  : _currency = currency,
        _onCurrencyChanged = onCurrencyChanged,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${_currency.symbol} ${_currency.currencyCode}",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        DropdownButton(
          value: _currency,
          icon: const Icon(Icons.keyboard_arrow_down),
          underline: null,
          onChanged: (Currency? value) {
            if (value != null) {
              _onCurrencyChanged(value);
            }
          },
          items: CurrencyConfig.supportedCurrencies
              .map((Currency currency) => DropdownMenuItem(
                    value: currency,
                    child: Text(
                      currency.fullName,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
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
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Colors.blue,
            ),
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
