import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/store.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'store_registration_event.dart';
part 'store_registration_state.dart';
part 'store_registration_repository.dart';

class StoreRegistrationBloc
    extends Bloc<StoreRegistrationEvent, StoreRegistrationState> {
  final StoreRegistrationRepository _repo = StoreRegistrationRepository();

  @override
  StoreRegistrationState get initialState => StoreRegistrationInitial();

  @override
  Stream<StoreRegistrationState> mapEventToState(
    StoreRegistrationEvent event,
  ) async* {
    if (event is StoreRegistrationRegister) {
      yield StoreRegistrationLoading();

      await _repo.registerStore(event);

      yield StoreRegistrationSuccess();
    }
  }
}
