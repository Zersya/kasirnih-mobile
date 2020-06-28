part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  final propss;
  const DashboardState({this.propss});

  @override
  List<Object> get props => propss;
}

class DashboardInitial extends DashboardState {
  final int version;
  final bool isHasStore;
  final Stream<List<Item>> items;
  final Stream<List<Category>> categories;

  DashboardInitial(
      {this.version = 0, this.isHasStore = false, this.items, this.categories})
      : super(propss: [version, isHasStore, items, categories]);
}

class DashboardInitialHasStore extends DashboardState {
  final int version;
  final bool isHasStore;
  final Stream<List<Item>> items;
  final Stream<List<Category>> categories;

  DashboardInitialHasStore(
      {this.version = 0, this.isHasStore = false, this.items, this.categories})
      : super(propss: [version, isHasStore, items, categories]);
}

class DashboardLoading extends DashboardState {
  final int version;
  final bool isHasStore;
  final Stream<List<Item>> items;
  final Stream<List<Category>> categories;

  DashboardLoading(this.version, this.isHasStore, this.items, this.categories)
      : super(propss: [version, isHasStore, items, categories]);
}
