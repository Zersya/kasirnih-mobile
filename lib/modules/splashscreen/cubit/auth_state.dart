part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  final bool isLoggedIn;
  final String username;
  
  AuthInitial({this.isLoggedIn = false, this.username});
  @override
  List<Object> get props => [isLoggedIn];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}
