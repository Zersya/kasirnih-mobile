part of 'items_widget_bloc.dart';

abstract class ItemsWidgetEvent extends Equatable {
  const ItemsWidgetEvent();
}

class ItemsWidgetLoad extends ItemsWidgetEvent {
  final List<Category> categories;

  ItemsWidgetLoad({this.categories = const []});
  @override
  List<Object> get props => throw UnimplementedError();
}

class ItemsWidgetSearch extends ItemsWidgetEvent {
  final String name;

  ItemsWidgetSearch(this.name);
  @override
  List<Object> get props => throw UnimplementedError();
}
