import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/payment_method.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ks_bike_mobile/models/transaction.dart' as trx;

part 'payment_event.dart';
part 'payment_state.dart';
part 'payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repo = PaymentRepository();

  PaymentBloc(PaymentState initialState) : super(initialState);

  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {
    yield PaymentLoading(
        state.props[0], state.props[1], state.props[2], state.props[3]);
    if (event is PaymentLoad) {
      final resultLatestCode = await _repo.loadTrx();
      final resultPaymentMethods = await _repo.loadListPaymentMethod();

      int version = state.props[0];
      version++;
      yield PaymentInitial(
          version: version,
          streamCodeTrx: resultLatestCode,
          listPaymentMethods: resultPaymentMethods);
    } else if (event is PaymentChooseMethod) {
      yield PaymentInitial(
          version: state.props[0],
          streamCodeTrx: state.props[1],
          paymentMethod: event.paymentMethod,
          listPaymentMethods: state.props[3]);
    } else if (event is PaymentSubmit) {
      final result = await _repo.addTransaction(event);
      if (result) {
        yield PaymentSuccess(
            state.props[0], state.props[1], state.props[2], state.props[3]);
      } else {
        yield PaymentFailed(
            state.props[0], state.props[1], state.props[2], state.props[3]);
      }
    }
  }
}

class TotalChangeBloc extends Bloc<TotalChangeEvent, int> {
  TotalChangeBloc(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(
    TotalChangeEvent event,
  ) async* {
    yield event.paid - event.total;
  }
}

class TotalChangeEvent {
  final int total;
  final int paid;

  TotalChangeEvent(this.paid, this.total);
}
