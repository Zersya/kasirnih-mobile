import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/models/credential.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';

part 'employee_credential_form_state.dart';
part 'employee_credential_form_repository.dart';

class EmployeeCredentialFormCubit extends Cubit<EmployeeCredentialFormState> {
  final EmployeeCredentialFormRepository _repo =
      EmployeeCredentialFormRepository();
  EmployeeCredentialFormCubit() : super(EmployeeCredentialFormInitial()) {
    loadCredential();
  }

  void loadCredential() async {
    final listCredential = await _repo.loadCredential();

    emit(EmployeeCredentialFormInitial(
        version: state.incrementV(), listCredential: listCredential));
  }

  void selectCredentials(bool value, int index) {
    final List<Credential> listCredential = state.props[1];
    listCredential.elementAt(index).isSelected = value;

    emit(EmployeeCredentialFormInitial(
        version: state.incrementV(), listCredential: listCredential));
  }

  void createUser(String name, String username, String password) async {
    emit(EmployeeCredentialFormLoading(state.props[0], state.props[1]));
    final List<Credential> selectedCreds = state.props[1];

    await _repo.register(
        name.toLowerCase(),
        username.toLowerCase(),
        password,
        selectedCreds
            .where((element) => element.isSelected)
            .toList()
            .map((e) => e.code)
            .toList());

    emit(EmployeeCredentialFormSuccess(state.props[0], state.props[1]));
  }
}
