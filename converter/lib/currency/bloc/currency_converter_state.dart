part of 'currency_converter_bloc.dart';

abstract class CurrencyConverterState extends Equatable {
  const CurrencyConverterState();

  @override
  List<Object?> get props => [];
}

/// BLoC is being initialize and loads data
class CurrencyConverterStateInitial extends CurrencyConverterState {}

/// Failed to fetch base rates
class CurrencyConverterStateError extends CurrencyConverterState {
  final String message;

  CurrencyConverterStateError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Rates are available and can be presented
class CurrencyConverterStateRateAvailable extends CurrencyConverterState {
  final ConversionAmount baseAmount;
  final ConversionAmount targetAmount;

  CurrencyConverterStateRateAvailable(this.baseAmount, this.targetAmount);

  @override
  List<Object?> get props => [baseAmount, targetAmount];
}
