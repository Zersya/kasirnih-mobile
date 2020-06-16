part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final propss;
  const AuthState({this.propss});

  @override
  List<Object> get props => propss;
}

class AuthInitial extends AuthState {
  final bool isPwdLoginVisible;
  final bool isPwdRegisterVisible;
  AuthInitial({this.isPwdLoginVisible = false, this.isPwdRegisterVisible = false})
      : super(propss: [isPwdLoginVisible, isPwdRegisterVisible]);
}

class AuthLoading extends AuthState {
  final bool isPwdLoginVisible;
  final bool isPwdRegisterVisible;

  AuthLoading(this.isPwdLoginVisible, this.isPwdRegisterVisible)
      : super(propss: [isPwdLoginVisible, isPwdRegisterVisible]);
}

class AuthSuccess extends AuthState {
  final bool isPwdLoginVisible;
  final bool isPwdRegisterVisible;

  AuthSuccess(this.isPwdLoginVisible, this.isPwdRegisterVisible)
      : super(propss: [isPwdLoginVisible, isPwdRegisterVisible]);
}
