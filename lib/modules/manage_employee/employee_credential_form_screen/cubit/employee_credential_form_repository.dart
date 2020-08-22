part of 'employee_credential_form_cubit.dart';

class EmployeeCredentialFormRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<List<Credential>> loadCredential() async {
    final doc = await _firestore.collection('credentials').get();

    List<Credential> list =
        doc.docs.map((e) => Credential.fromMap(e.data())).toList();
    return list;
  }

  Future<UserCredential> register(String name, String username, String password,
      List<String> credentials) async {
    final email = '$username@$kDomain';

    try {
      final snapshotUsername = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .snapshots()
          .first;

      final snapshotEmail = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .snapshots()
          .first;

      final isUsername = snapshotUsername.docs.isNotEmpty;
      final isEmail = snapshotEmail.docs.isNotEmpty;

      if (isUsername && isEmail) {
        toastError(
            tr('auth_screen.msg_usr_error_registered', args: ['Username']));
        return null;
      }
      return await _registerUser2Firestore(
          name, username, password, email, credentials);
    } on SocketException {
      toastError(tr('error.no_connection'));
      return null;
    }
  }

  Future<UserCredential> _registerUser2Firestore(String name, String username,
      String password, String email, List<String> credentials) async {
    try {
      final storeKey = await storage.read(key: kDefaultStore);

      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _firestore.collection('users').add({
        'name': name,
        'username': username,
        'email': email,
        'credentials': credentials,
        'store': storeKey
      });

      toastSuccess(tr('auth_screen.msg_usr_success_registered',
          args: [username.capitalize()]));

      return result;
    } on PlatformException catch (err) {
      toastError(err.message);
      return null;
    }
  }
}
