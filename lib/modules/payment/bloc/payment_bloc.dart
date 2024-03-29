import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kasirnih_mobile/models/payment_method.dart';
import 'package:kasirnih_mobile/utils/key.dart';
import 'package:kasirnih_mobile/utils/toast.dart';
import 'package:kasirnih_mobile/models/transaction.dart' as trx;

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
    yield PaymentLoading(state.props[0], state.props[1], state.props[2],
        state.props[3], state.props[4]);
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
      if (result != null) {
        yield PaymentSuccess(state.props[0], state.props[1], state.props[2],
            state.props[3], result);
      } else {
        yield PaymentFailed(state.props[0], state.props[1], state.props[2],
            state.props[3], state.props[4]);
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
