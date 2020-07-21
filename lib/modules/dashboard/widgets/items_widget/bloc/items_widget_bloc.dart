import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/utils/key.dart';

part 'items_widget_event.dart';
part 'items_widget_state.dart';
part 'items_widget_repository.dart';

class ItemsWidgetBloc extends Bloc<ItemsWidgetEvent, ItemsWidgetState> {
  final ItemsWidgetRepository _repo = ItemsWidgetRepository();

  ItemsWidgetBloc(ItemsWidgetState initialState) : super(initialState);

  @override
  Stream<ItemsWidgetState> mapEventToState(
    ItemsWidgetEvent event,
  ) async* {
    if (event is ItemsWidgetLoad) {
      final result = await _repo.loadItems(event, state);
      final int version = state.props[0];
      yield ItemsWidgetInitial(
        version: version + 1,
        items: result,
      );
    } else if (event is ItemsWidgetSearch) {
      final result = await _repo.searchItem(event, state);
      final int version = state.props[0];
      yield ItemsWidgetInitial(
        version: version + 1,
        items: result,
      );
    }
  }
}

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc(ItemState initialState) : super(initialState);

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    final int version = state.props[0];
    yield ItemState(
        version: version + 1,
        items: event.items ?? state.props[1],
        selectedItems: event.selectedItems ?? state.props[2],
        selectedList: event.selectedList ?? state.props[3]);
  }
}

class ItemState extends Equatable {
  final int version;
  final List<Item> items;
  final List<Item> selectedItems;
  final int selectedList;

  ItemState(
      {this.version = 0,
      this.items = const [],
      this.selectedItems = const [],
      this.selectedList = 0});
  @override
  List<Object> get props => [version, items, selectedItems, selectedList];
}

class ItemEvent extends Equatable {
  final List<Item> items;
  final List<Item> selectedItems;
  final int selectedList;

  ItemEvent({this.items, this.selectedItems, this.selectedList});
  @override
  List<Object> get props => [items, selectedItems, selectedList];
}
