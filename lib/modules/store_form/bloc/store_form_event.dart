part of 'store_form_bloc.dart';

abstract class StoreFormEvent extends Equatable {
  final propss;
  const StoreFormEvent({this.propss});

  @override
  List<Object> get props => this.propss;
}

class StoreFormLoad extends StoreFormEvent {}

class StoreFormRegister extends StoreFormEvent {
  final Store store;

  StoreFormRegister(this.store);
}

class StoreFormUpdate extends StoreFormEvent {
  final Store store;

  StoreFormUpdate(this.store);
}
