part of 'summary_bloc.dart';

class SummaryRepository {
  final Firestore _firestore = Firestore.instance;
  final storage = FlutterSecureStorage();

  Future<Stream<String>> loadTrx() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final snap = await _firestore
        .collection('stores')
        .document(storeKey)
        .snapshots()
        .map<String>((event) => event.data['latest_transaction_code']);

    return snap;
  }
}
