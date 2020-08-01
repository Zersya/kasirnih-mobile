import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void checkAuth() async {
    final curUser = await _auth.currentUser();

    final String username = curUser != null ? curUser.email.split('@')[0] : '';
    emit(AuthInitial(isLoggedIn: curUser != null, username: username));
  }
}
