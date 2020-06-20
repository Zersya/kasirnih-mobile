part of 'store_form_bloc.dart';

abstract class StoreFormState extends Equatable {
  final propss;
  const StoreFormState({this.propss});

  @override
  List<Object> get props => propss;
}

class StoreFormStateInitial extends StoreFormState {
  final Store store;
  final int version;

  StoreFormStateInitial({this.version = 0, this.store}):super(propss:[version, store]);

}

class StoreFormStateSuccess extends StoreFormState {
  final Store store;
  final int version;

  StoreFormStateSuccess(this.version, this.store):super(propss:[version, store]);
}

class StoreFormStateLoading extends StoreFormState {
  final Store store;
  final int version;

  StoreFormStateLoading(this.version, this.store):super(propss:[version, store]);

}
