part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  final propss;
  const AuthEvent({this.propss});

  @override
  List<Object> get props => this.propss;
}

class AuthEventRegister extends AuthEvent {
  final String username;
  final String email;
  final String phone;
  final String password;

  AuthEventRegister(this.username, this.email, this.phone, this.password);
}

class AuthEventLogin extends AuthEvent {
  final String username;
  final String password;

  AuthEventLogin(this.username, this.password);
}

class AuthEventTriggerPasswordLogin extends AuthEvent{}
class AuthEventTriggerPasswordRegister extends AuthEvent{}