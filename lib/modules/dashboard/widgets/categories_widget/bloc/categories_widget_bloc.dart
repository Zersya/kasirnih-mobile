import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'categories_widget_event.dart';
part 'categories_widget_state.dart';
part 'categories_widget_repository.dart';

class CategoriesWidgetBloc
    extends Bloc<CategoriesWidgetEvent, CategoriesWidgetState> {
      final CategoriesWidgetRepository _repo = CategoriesWidgetRepository();
  @override
  CategoriesWidgetState get initialState => CategoriesWidgetInitial();

  @override
  Stream<CategoriesWidgetState> mapEventToState(
    CategoriesWidgetEvent event,
  ) async* {
    if(event is CategoriesWidgetLoad){
      final result = await _repo.loadCategories(event, state);
      final int version = state.props[0];
      yield CategoriesWidgetInitial(version: version + 1, categories: result);
    }
  }
}



class CategoryBloc extends Bloc<Category, CategoryState> {
  final List<Category> categories;

  CategoryBloc(this.categories);

  @override
  CategoryState get initialState => CategoryState(0, categories);

  @override
  Stream<CategoryState> mapEventToState(Category event) async* {
    final int version = state.props[0];
    yield CategoryState(version + 1, categories);
  }
}

class CategoryState extends Equatable {
  final int version;
  final List<Category> categories;

  CategoryState(this.version, this.categories);
  @override
  List<Object> get props => [version, categories];
}
