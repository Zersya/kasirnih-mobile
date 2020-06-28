part of 'items_widget_bloc.dart';

abstract class ItemsWidgetState extends Equatable {
  const ItemsWidgetState();
}

class ItemsWidgetInitial extends ItemsWidgetState {
  final int version;
  final Stream<List<Item>> items;

  ItemsWidgetInitial({this.version = 0, this.items});
  @override
  List<Object> get props => [version, items];
}
