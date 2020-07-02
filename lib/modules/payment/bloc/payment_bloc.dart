import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ks_bike_mobile/models/transaction.dart' as trx;

part 'payment_event.dart';
part 'payment_state.dart';
part 'payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repo = PaymentRepository();

  @override
  PaymentState get initialState => PaymentInitial();

  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {
    yield PaymentLoading(state.props[0], state.props[1], state.props[2]);
    if (event is PaymentLoad) {
      final result = await _repo.loadTrx();
      int version = state.props[0];
      version++;
      yield PaymentInitial(version: version, streamCodeTrx: result);
    } else if (event is PaymentChooseMethod) {
      yield PaymentInitial(
          version: state.props[0],
          streamCodeTrx: state.props[1],
          paymentMethod: event.paymentMethod);
    } else if (event is PaymentSubmit) {
      final result = await _repo.addTransaction(event);
      if (result) {
        yield PaymentSuccess(state.props[0], state.props[1], state.props[2]);
      } else {
        yield PaymentFailed(state.props[0], state.props[1], state.props[2]);
      }
    }
  }
}

class TotalChangeBloc extends Bloc<TotalChangeEvent, int> {
  @override
  int get initialState => 0;

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
