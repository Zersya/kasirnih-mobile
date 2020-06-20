part of 'store_registration_bloc.dart';

abstract class StoreRegistrationEvent extends Equatable {
  final propss;
  const StoreRegistrationEvent({this.propss});

  @override
  List<Object> get props => this.propss;
}

class StoreRegistrationRegister extends StoreRegistrationEvent {
  final Store store;

  StoreRegistrationRegister(this.store);
}
