part of 'categories_widget_bloc.dart';

abstract class CategoriesWidgetEvent extends Equatable {
  const CategoriesWidgetEvent();
}

class CategoriesWidgetLoad extends CategoriesWidgetEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}