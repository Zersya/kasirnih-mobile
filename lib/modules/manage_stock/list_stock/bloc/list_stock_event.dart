part of 'list_stock_bloc.dart';

abstract class ListStockEvent extends Equatable {
  final propss;
  const ListStockEvent({this.propss});

  @override
  List<Object> get props => propss;
}

class ListStockLoad extends ListStockEvent {
  final int indexScreen;

  ListStockLoad(this.indexScreen);
}

class ListStockSearch extends ListStockEvent{
  final String name;

  ListStockSearch(this.name);
}