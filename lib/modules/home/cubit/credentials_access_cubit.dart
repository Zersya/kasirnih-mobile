import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/utils/key.dart';

part 'credentials_access_state.dart';

class CredentialsAccessCubit extends Cubit<CredentialsAccessState> {
  CredentialsAccessCubit() : super(CredentialsAccessInitial());

  void getCredentials() async {
    emit(
      CredentialsAccessLoading(
        state.props[0],
        state.props[1],
        state.props[2],
        state.props[3],
        state.props[4],
        state.props[5],
        state.props[6],
      ),
    );

    final bool vIsHasStore = await isHasStore();
    final storage = FlutterSecureStorage();
    Map<String, String> allValues = await storage.readAll();
    emit(
      await CredentialsAccessLoaded(
        allValues[kDebtInvoice] != null,
        allValues[kAddNewItem] != null,
        allValues[kItemStock] != null,
        allValues[kPos] != null,
        allValues[kTrxReport] != null,
        allValues[kOwner] != null,
        vIsHasStore,
      ),
    );
  }

  final Firestore _firestore = Firestore.instance;

  Future<bool> isHasStore() async {
    final storage = FlutterSecureStorage();
    final userKey = await storage.read(key: kUserDocIdKey);
    final storeKey = await storage.read(key: kDefaultStore);

    if (storeKey != null) return true;

    final docs = await _firestore
        .collection('stores')
        .where('store_owner_id', isEqualTo: userKey)
        .getDocuments();

    final isHasStore = docs.documents.isNotEmpty;
    if (isHasStore) {
      await storage.write(
          key: kDefaultStore, value: docs.documents.first.documentID);
    }
    return isHasStore;
  }
}
