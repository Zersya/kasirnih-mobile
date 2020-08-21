import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kasirnih_mobile/models/store.dart';
import 'package:kasirnih_mobile/utils/key.dart';

part 'load_store_state.dart';

class LoadStoreCubit extends Cubit<LoadStoreState> {
  LoadStoreCubit() : super(LoadStoreInitial());

  void loadStore() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final storage = FlutterSecureStorage();
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore.collection('stores').doc(storeKey).snapshots();

    Stream<Store> result =
        doc.map((event) => Store.fromMap(event.data())).asBroadcastStream();
    emit(LoadStoreInitial(streamStore: result));
  }
}
