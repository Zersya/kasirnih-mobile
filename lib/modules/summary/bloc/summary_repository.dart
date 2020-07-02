part of 'summary_bloc.dart';

class SummaryRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<String>> loadTrx() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final snap = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .document(storeKey)
        .snapshots()
        .map<String>((event) => event.data['latest_transaction_code']);

    return snap;
  }
}
