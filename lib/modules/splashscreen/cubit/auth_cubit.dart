import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/utils/key.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void checkAuth() async {
    
    final curUser = await _auth.currentUser();

    final storage = FlutterSecureStorage();
    final String username =
        curUser != null ? await storage.read(key: kUsername) : '';
    emit(AuthInitial(isLoggedIn: curUser != null, username: username));
  }
}
