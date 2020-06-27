part of 'list_stock_bloc.dart';

abstract class ListStockState extends Equatable {
  final propss;
  const ListStockState({this.propss});

  @override
  List<Object> get props => propss;
}

class ListStockInitial extends ListStockState {
  final int version;
  final Stream<List<Item>> items0;
  final Stream<List<Item>> items1;
  final Stream<List<Item>> items2;
  final Stream<List<Item>> itemsSearched;

  ListStockInitial(
      {this.version = 0,
      this.items0,
      this.items1,
      this.items2,
      this.itemsSearched})
      : super(propss: [version, items0, items1, items2, itemsSearched]);
}

class ListStockLoading extends ListStockState {
  final int version;
  final Stream<List<Item>> items0;
  final Stream<List<Item>> items1;
  final Stream<List<Item>> items2;
  final Stream<List<Item>> itemsSearched;

  ListStockLoading(
      this.version, this.items0, this.items1, this.items2, this.itemsSearched)
      : super(propss: [version, items0, items1, items2, itemsSearched]);
}
