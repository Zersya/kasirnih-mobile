part of 'store_registration_bloc.dart';

abstract class StoreRegistrationState extends Equatable {
  final propss;
  const StoreRegistrationState({this.propss});

  @override
  List<Object> get props => propss;
}

class StoreRegistrationInitial extends StoreRegistrationState {}

class StoreRegistrationSuccess extends StoreRegistrationState {}

class StoreRegistrationLoading extends StoreRegistrationState {}
