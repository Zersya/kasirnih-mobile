import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'items_widget_event.dart';
part 'items_widget_state.dart';
part 'items_widget_repository.dart';

class ItemsWidgetBloc extends Bloc<ItemsWidgetEvent, ItemsWidgetState> {
  final ItemsWidgetRepository _repo = ItemsWidgetRepository();
  @override
  ItemsWidgetState get initialState => ItemsWidgetInitial();

  @override
  Stream<ItemsWidgetState> mapEventToState(
    ItemsWidgetEvent event,
  ) async* {
    if (event is ItemsWidgetLoad) {
      final result = await _repo.loadItems(event, state);
      final int version = state.props[0];
      yield ItemsWidgetInitial(version: version + 1, items: result);
    } else if (event is ItemsWidgetSearch) {
      final result = await _repo.searchItem(event, state);
      final int version = state.props[0];
      yield ItemsWidgetInitial(version: version + 1, items: result);
    }
  }
}

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  @override
  ItemState get initialState => ItemState(0, []);

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    final int version = state.props[0];
    yield ItemState(version + 1, event.items);
  }
}

class ItemState extends Equatable {
  final int version;
  final List<Item> items;

  ItemState(this.version, this.items);
  @override
  List<Object> get props => [version, items];
}

class ItemEvent extends Equatable {
  final List<Item> items;

  ItemEvent(this.items);
  @override
  List<Object> get props => [items];
}
