import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kasirnih_mobile/models/payment_method.dart';
import 'package:kasirnih_mobile/models/store.dart';
import 'package:kasirnih_mobile/utils/key.dart';
import 'package:kasirnih_mobile/utils/toast.dart';

part 'store_form_event.dart';
part 'store_form_state.dart';
part 'store_form_repository.dart';

class StoreFormBloc extends Bloc<StoreFormEvent, StoreFormState> {
  final StoreFormRepository _repo = StoreFormRepository();

  StoreFormBloc(StoreFormState initialState) : super(initialState);

  @override
  Stream<StoreFormState> mapEventToState(
    StoreFormEvent event,
  ) async* {
    if (event is StoreFormLoad) {
      yield StoreFormStateLoading(state.props[0], state.props[1]);

      Store store = await _repo.loadStore();

      final int version = state.props[0];
      yield StoreFormStateInitial(version: version + 1, store: store);
    } else if (event is StoreFormRegister) {
      yield StoreFormStateLoading(state.props[0], state.props[1]);

      await _repo.registerStore(event);

      final int version = state.props[0];
      yield StoreFormStateSuccess(version + 1, state.props[1]);
    } else if (event is StoreFormUpdate) {
      yield StoreFormStateLoading(state.props[0], state.props[1]);

      await _repo.updateStore(event);

      final int version = state.props[0];
      yield StoreFormStateSuccess(version + 1, state.props[1]);
    }
  }
}
