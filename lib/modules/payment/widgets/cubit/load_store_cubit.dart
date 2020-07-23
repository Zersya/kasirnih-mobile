import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/models/store.dart';
import 'package:ks_bike_mobile/utils/key.dart';

part 'load_store_state.dart';

class LoadStoreCubit extends Cubit<LoadStoreState> {
  LoadStoreCubit() : super(LoadStoreInitial());

  void loadStore() async {
    final Firestore _firestore = Firestore.instance;
    final storage = FlutterSecureStorage();
    final storeKey = await storage.read(key: kDefaultStore);

    final doc =
        await _firestore.collection('stores').document(storeKey).snapshots();

    Stream<Store> result =
        doc.map((event) => Store.fromMap(event.data)).asBroadcastStream();
    emit(LoadStoreInitial(streamStore: result));
  }
}