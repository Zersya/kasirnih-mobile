import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kasirnih_mobile/models/category.dart';
import 'package:kasirnih_mobile/models/item.dart';
import 'package:kasirnih_mobile/utils/key.dart';

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
  final storage = FlutterSecureStorage();

  ItemBloc(ItemState initialState) : super(initialState);
  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    final int version = state.props[0];
    int toggleSelected = event.toggleSelected;

    if (toggleSelected != null) {
      await storage.write(
          key: kTypeDashboard, value: '${event.toggleSelected}');
    } else {
      final String data = await storage.read(key: kTypeDashboard);
      if (data != null) {
        toggleSelected = int.parse(data);
      }
    }

    yield ItemState(
      version: version + 1,
      items: event.items ?? state.props[1],
      selectedItems: event.selectedItems ?? state.props[2],
      toggleSelected: toggleSelected ?? state.props[3],
    );
  }
}

class ItemState extends Equatable {
  final int version;
  final List<Item> items;
  final List<Item> selectedItems;
  final int toggleSelected;

  ItemState(
      {this.version = 0,
      this.items = const [],
      this.selectedItems = const [],
      this.toggleSelected = 0});
  @override
  List<Object> get props => [version, items, selectedItems, toggleSelected];
}

class ItemEvent extends Equatable {
  final List<Item> items;
  final List<Item> selectedItems;
  final int toggleSelected;

  ItemEvent({this.items, this.selectedItems, this.toggleSelected});
  @override
  List<Object> get props => [items, selectedItems, toggleSelected];
}
