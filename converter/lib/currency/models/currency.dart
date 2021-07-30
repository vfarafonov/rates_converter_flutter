import 'package:equatable/equatable.dart';

/// General info about currency
class Currency extends Equatable {
  final String currencyCode;
  final String fullName;
  final String symbol;

  const Currency({required this.currencyCode, required this.fullName, required this.symbol});

  @override
  List<Object?> get props => [currencyCode, fullName, symbol];
}
