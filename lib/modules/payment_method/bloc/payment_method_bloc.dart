import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/payment_method.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'payment_method_event.dart';
part 'payment_method_state.dart';
part 'payment_method_repository.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final PaymentMethodRepository _repo = PaymentMethodRepository();

  PaymentMethodBloc() : super(PaymentMethodStateInitial());

  @override
  Stream<PaymentMethodState> mapEventToState(
    PaymentMethodEvent event,
  ) async* {
    yield PaymentMethodStateLoading(state.props[0], state.props[1]);
    if (event is PaymentMethodLoad) {
      List<PaymentMethod> result = await _repo.loadListPaymentMethod();

      final int version = state.props[0];
      yield PaymentMethodStateInitial(version: version + 1, listName: result);
    } else if (event is PaymentMethodAdd) {
      await _repo.addPaymentMethod(event);

      final int version = state.props[0];
      yield PaymentMethodStateSuccess(version + 1, state.props[1]);
    }
  }
}
