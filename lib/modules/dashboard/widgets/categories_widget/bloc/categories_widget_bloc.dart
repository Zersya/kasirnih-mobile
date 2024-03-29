import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kasirnih_mobile/models/category.dart';
import 'package:kasirnih_mobile/utils/key.dart';

part 'categories_widget_event.dart';
part 'categories_widget_state.dart';
part 'categories_widget_repository.dart';

class CategoriesWidgetBloc
    extends Bloc<CategoriesWidgetEvent, CategoriesWidgetState> {
  final CategoriesWidgetRepository _repo = CategoriesWidgetRepository();

  CategoriesWidgetBloc(CategoriesWidgetState initialState)
      : super(initialState);

  @override
  Stream<CategoriesWidgetState> mapEventToState(
    CategoriesWidgetEvent event,
  ) async* {
    if (event is CategoriesWidgetLoad) {
      final result = await _repo.loadCategories(event, state);
      final int version = state.props[0];
      yield CategoriesWidgetInitial(version: version + 1, categories: result);
    }
  }
}

class CategoryBloc extends Bloc<Category, CategoryState> {
  CategoryBloc(CategoryState initialState) : super(initialState);

  @override
  Stream<CategoryState> mapEventToState(Category event) async* {
    final int version = state.props[0];
    yield CategoryState(version: version + 1, categories: state.categories);
  }
}

class CategoryState extends Equatable {
  final int version;
  final List<Category> categories;

  CategoryState({this.version = 0, this.categories = const []});
  @override
  List<Object> get props => [version];
}
