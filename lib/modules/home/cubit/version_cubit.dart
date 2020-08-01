import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ks_bike_mobile/utils/key.dart';

part 'version_state.dart';

class VersionCubit extends Cubit<VersionState> {
  VersionCubit() : super(VersionInitial());
  final _firestore = Firestore.instance;
  final _storage = FlutterSecureStorage();

  void versionCheck() async {
    final limitListNum = await _firestore
        .collection('app_information')
        .document('limit_list_number')
        .get();

    final number = limitListNum.data['number'];
    await _storage.write(key: kLimitData, value: number.toString());

    final snapshot = await _firestore
        .collection('app_information')
        .document('version_code')
        .snapshots()
        .map((event) => event.data['current']);

    emit(VersionInitial(streamVersion: snapshot));
  }
}
