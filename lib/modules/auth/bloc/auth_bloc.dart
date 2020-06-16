import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ks_bike_mobile/main.dart';
import 'package:ks_bike_mobile/utils/toast.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authService = AuthRepository();
  @override
  AuthState get initialState => AuthInitial();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthEventRegister) {
      yield* _register(event);
    } else if (event is AuthEventLogin) {
      yield* _login(event);
    } else if (event is AuthEventTriggerPasswordLogin) {
      yield AuthInitial(
          isPwdLoginVisible: !state.props[0],
          isPwdRegisterVisible: state.props[1]);
    } else if (event is AuthEventTriggerPasswordRegister) {
      yield AuthInitial(
          isPwdLoginVisible: state.props[0],
          isPwdRegisterVisible: !state.props[1]);
    }
  }

  Stream<AuthState> _register(AuthEventRegister event) async* {
    yield AuthLoading(state.props[0], state.props[1]);
    final registered = await _authService.register(event);
    if (registered != null) {
      yield AuthSuccess(state.props[0], state.props[1]);
    }
    yield AuthInitial();
  }

  Stream<AuthState> _login(AuthEventLogin event) async* {
    yield AuthLoading(state.props[0], state.props[1]);
    final login = await _authService.login(event);
    if (login != null) {
      yield AuthSuccess(state.props[0], state.props[1]);
    }
    yield AuthInitial();
  }
}
