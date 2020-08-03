import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/models/cashes.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';

part 'cashes_form_state.dart';
part 'cashes_form_repository.dart';

class CashesFormCubit extends Cubit<CashesFormState> {
  final CashesFormRepository _repo = CashesFormRepository();

  CashesFormCubit() : super(CashesFormInitial());

  void submitCashes(String name, int total) async {
    emit(CashesFormLoading(state.props[0]));

    final response = await _repo.addCashes(name, state.props[0], total);
    if (response) {
      emit(CashesFormSuccess(state.props[0]));
    } else {
      emit(CashesFormFail(state.props[0]));
    }
  }

  void changeType(int value) {
    emit(CashesFormInitial(type: value));
  }
}
