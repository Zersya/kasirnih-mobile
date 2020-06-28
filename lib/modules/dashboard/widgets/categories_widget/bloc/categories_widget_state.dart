part of 'categories_widget_bloc.dart';

abstract class CategoriesWidgetState extends Equatable {
  const CategoriesWidgetState();
}

class CategoriesWidgetInitial extends CategoriesWidgetState {
  final int version;
  final Stream<List<Category>> categories;

  CategoriesWidgetInitial({this.version = 0, this.categories});
  @override
  List<Object> get props => [version, categories];
}
