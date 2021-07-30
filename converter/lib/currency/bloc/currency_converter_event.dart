part of 'currency_converter_bloc.dart';

abstract class CurrencyConverterEvent extends Equatable {
  const CurrencyConverterEvent();

  @override
  List<Object?> get props => [];
}

/// Initialization event
class CurrencyConverterEventInit extends CurrencyConverterEvent {

  const CurrencyConverterEventInit();
}

class CurrencyConverterEventChangeBaseAmount extends CurrencyConverterEvent {
  final double baseAmountMajorUnits;

  CurrencyConverterEventChangeBaseAmount(this.baseAmountMajorUnits);

  @override
  List<Object?> get props => [baseAmountMajorUnits];
}

/// Event triggered when base Currency is changed
class CurrencyConverterEventChangeBaseCurrency extends CurrencyConverterEvent {
  final Currency baseCurrency;

  CurrencyConverterEventChangeBaseCurrency(this.baseCurrency);

  @override
  List<Object?> get props => [baseCurrency];
}

/// Event triggered when target Currency is changed
class CurrencyConverterEventChangeTargetCurrency extends CurrencyConverterEvent {
  final Currency targetCurrency;

  CurrencyConverterEventChangeTargetCurrency(this.targetCurrency);

  @override
  List<Object?> get props => [targetCurrency];
}

/// Event triggered when Currencies swap requested
class CurrencyConverterEventSwapCurrency extends CurrencyConverterEvent {}
