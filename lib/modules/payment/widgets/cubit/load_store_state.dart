part of 'load_store_cubit.dart';

abstract class LoadStoreState extends Equatable {
  const LoadStoreState();
}

class LoadStoreInitial extends LoadStoreState {
  final Stream<Store> streamStore;

  LoadStoreInitial({this.streamStore});
  @override
  List<Object> get props => [streamStore];
}
