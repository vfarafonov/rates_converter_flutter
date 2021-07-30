import 'package:converter/currency/models/currency.dart';
import 'package:equatable/equatable.dart';

/// Represents info on one of the sides of rates convertion
class ConversionAmount extends Equatable {
  final Currency currency;

  /// Amount in Major units (For example, for USD major unit is Dollar, while Cent is a minor unit)
  final double majorUnitAmount;

  ConversionAmount({required this.currency, required this.majorUnitAmount});

  ConversionAmount copyWith({Currency? currency, double? majorUnitAmount}) {
    return ConversionAmount(
      currency: currency ?? this.currency,
      majorUnitAmount: majorUnitAmount ?? this.majorUnitAmount,
    );
  }

  @override
  List<Object?> get props => [currency, majorUnitAmount];
}
