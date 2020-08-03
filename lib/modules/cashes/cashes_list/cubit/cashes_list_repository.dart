part of 'cashes_list_cubit.dart';

class CashesListRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<Stream<List<trx.Transaction>>> loadTransaction() async {
    final storeKey = await storage.read(key: kDefaultStore);
    final numberLimit = int.parse((await storage.read(key: kLimitData)));

    Query items = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('transactions')
        .orderBy('created_at', descending: true)
        .limit(numberLimit);

    return items
        .snapshots()
        .map((event) =>
            event.docs.map((e) => trx.Transaction.fromMap(e.data())).toList())
        .asBroadcastStream();
  }

  Future<Stream<List<Cashes>>> loadCashes() async {
    final storeKey = await storage.read(key: kDefaultStore);
    final numberLimit = int.parse((await storage.read(key: kLimitData)));

    Query items = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('cashes')
        .orderBy('created_at', descending: true)
        .limit(numberLimit);

    return items
        .snapshots()
        .map(
            (event) => event.docs.map((e) => Cashes.fromMap(e.data())).toList())
        .asBroadcastStream();
  }

  Future<Stream<int>> loadTotal() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final docRef =
        await _firestore.collection('stores').doc(storeKey).snapshots();

    return docRef.map((event) => event.data()['total_transaction']);
  }
}
