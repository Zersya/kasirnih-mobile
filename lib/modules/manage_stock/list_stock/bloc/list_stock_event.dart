part of 'list_stock_bloc.dart';

abstract class ListStockEvent extends Equatable {
  final propss;
  const ListStockEvent({this.propss});

  @override
  List<Object> get props => propss;
}

class ListStockLoad extends ListStockEvent {}
