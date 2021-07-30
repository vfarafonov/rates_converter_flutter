import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:converter/currency/bloc/currency_config.dart';
import 'package:converter/currency/bloc/data/currency_rates_repository.dart';
import 'package:converter/currency/models/conversion_amount.dart';
import 'package:converter/currency/models/currency.dart';
import 'package:equatable/equatable.dart';

part 'currency_converter_event.dart';

part 'currency_converter_state.dart';

/// BLoC which scope of responsibility is currency rates computation
class CurrencyConverterBloc extends Bloc<CurrencyConverterEvent, CurrencyConverterState> {
  final CurrencyRatesRepository _repository;

  CurrencyConverterBloc({required CurrencyRatesRepository repository})
      : _repository = repository,
        super(CurrencyConverterStateInitial()) {
    add(const CurrencyConverterEventInit());
  }

  @override
  Stream<CurrencyConverterState> mapEventToState(
    CurrencyConverterEvent event,
  ) async* {
    if (event is CurrencyConverterEventInit) {
      yield* _mapInitEventToState(event);
    } else if (event is CurrencyConverterEventChangeBaseAmount) {
      yield* _mapChangeBaseAmountEventToState(event);
    } else if (event is CurrencyConverterEventChangeBaseCurrency) {
      yield* _mapChangeBaseCurrencyEventToState(event);
    } else if (event is CurrencyConverterEventChangeTargetCurrency) {
      yield* _mapChangeTargetCurrencyEventToState(event);
    } else if (event is CurrencyConverterEventSwapCurrency) {
      yield* _mapSwapCurrencyEventToState(event);
    } else {
      throw Exception("Event is not supported: $event");
    }
  }

  Stream<CurrencyConverterState> _mapInitEventToState(CurrencyConverterEventInit event) async* {
    final defaultBaseCurrency = CurrencyConfig.supportedCurrencies[0];
    final defaultBaseAmount = ConversionAmount(currency: defaultBaseCurrency, majorUnitAmount: 1);
    final defaultTargetCurrency = CurrencyConfig.supportedCurrencies[1];

    yield* _computeAmountAndEmitState(defaultBaseAmount, defaultTargetCurrency);
  }

  Stream<CurrencyConverterState> _mapChangeBaseAmountEventToState(CurrencyConverterEventChangeBaseAmount event) async* {
    if (state is! CurrencyConverterStateRateAvailable) {
      return;
    }
    var stateRatesAvailable = state as CurrencyConverterStateRateAvailable;
    final baseAmount = stateRatesAvailable.baseAmount.copyWith(majorUnitAmount: event.baseAmountMajorUnits);
    final targetAmount = stateRatesAvailable.targetAmount;

    yield* _computeAmountAndEmitState(baseAmount, targetAmount.currency);
  }

  Stream<CurrencyConverterState> _mapChangeBaseCurrencyEventToState(
      CurrencyConverterEventChangeBaseCurrency event) async* {
    if (state is! CurrencyConverterStateRateAvailable) {
      return;
    }
    var stateRatesAvailable = state as CurrencyConverterStateRateAvailable;

    final baseAmount = stateRatesAvailable.baseAmount.copyWith(currency: event.baseCurrency);
    final targetAmount = stateRatesAvailable.targetAmount;

    yield* _computeAmountAndEmitState(baseAmount, targetAmount.currency);
  }

  Stream<CurrencyConverterState> _mapChangeTargetCurrencyEventToState(
      CurrencyConverterEventChangeTargetCurrency event) async* {
    if (state is! CurrencyConverterStateRateAvailable) {
      return;
    }
    var stateRatesAvailable = state as CurrencyConverterStateRateAvailable;

    final baseAmount = stateRatesAvailable.baseAmount;
    final targetAmount = stateRatesAvailable.targetAmount.copyWith(currency: event.targetCurrency);

    yield* _computeAmountAndEmitState(baseAmount, targetAmount.currency);
  }

  Stream<CurrencyConverterState> _mapSwapCurrencyEventToState(CurrencyConverterEventSwapCurrency event) async* {
    if (state is! CurrencyConverterStateRateAvailable) {
      return;
    }
    var stateRatesAvailable = state as CurrencyConverterStateRateAvailable;

    final baseAmount = stateRatesAvailable.baseAmount;
    final targetAmount = stateRatesAvailable.targetAmount;

    yield* _computeAmountAndEmitState(targetAmount, baseAmount.currency);
  }

  Stream<CurrencyConverterState> _computeAmountAndEmitState(
      ConversionAmount defaultBaseAmount, Currency defaultTargetCurrency) async* {
    try {
      final targetAmount = await _computeTargetConversionAmount(defaultBaseAmount, defaultTargetCurrency);
      yield CurrencyConverterStateRateAvailable(defaultBaseAmount, targetAmount);
    } catch (exc) {
      yield CurrencyConverterStateError("$exc");
    }
  }

  Future<ConversionAmount> _computeTargetConversionAmount(ConversionAmount baseAmount, Currency targetCurrency) async {
    final rates = await _repository.getCurrencyRates();
    final baseCurrencyRate = rates[baseAmount.currency.currencyCode]!;
    final targetCurrencyRate = rates[targetCurrency.currencyCode]!;
    double targetCurrencyAmount = baseAmount.majorUnitAmount * targetCurrencyRate / baseCurrencyRate;
    return ConversionAmount(
      currency: targetCurrency,
      majorUnitAmount: targetCurrencyAmount,
    );
  }
}
