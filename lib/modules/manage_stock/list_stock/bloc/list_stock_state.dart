part of 'list_stock_bloc.dart';

abstract class ListStockState extends Equatable {
  final propss;
  const ListStockState({this.propss});

  @override
  List<Object> get props => propss;
}

class ListStockInitial extends ListStockState {
  final int version;
  final Stream<List<Item>> items;

  ListStockInitial({this.version = 0, this.items})
      : super(propss: [version, items]);
}

class ListStockLoading extends ListStockState {
  final int version;
  final Stream<List<Item>> items;

  ListStockLoading(this.version, this.items)
      : super(propss: [version, items]);
}