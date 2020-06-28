import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repo = DashboardRepository();

  @override
  DashboardState get initialState => DashboardInitial();

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    yield DashboardLoading(
        state.props[0], state.props[1], state.props[2], state.props[3]);
    if (event is DashboardHasStore) {
      final result = await _repo.isHasStore();

      yield DashboardInitialHasStore(
        isHasStore: result,
        categories: state.props[3],
        items: state.props[2],
      );
    } else if (event is DashboardLoadStore) {
      final categories = await _repo.loadCategories(event, state);
      final items = await _repo.loadItems(event, state);

      final int version = state.props[0];
      yield DashboardInitial(
          version: version + 1,
          isHasStore: state.props[1],
          categories: categories,
          items: items);
    }
  }
}

class CategoryBloc extends Bloc<Category, CategoryState> {
  final Category category;

  CategoryBloc(this.category);

  @override
  CategoryState get initialState => CategoryState(0, category);

  @override
  Stream<CategoryState> mapEventToState(Category event) async* {
    final int version = state.props[0];
    yield CategoryState(version + 1, category);
  }
}

class CategoryState extends Equatable {
  final int version;
  final Category category;

  CategoryState(this.version, this.category);
  @override
  List<Object> get props => [version, category];
}
