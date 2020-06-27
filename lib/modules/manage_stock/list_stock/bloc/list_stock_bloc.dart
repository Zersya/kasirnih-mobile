import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'list_stock_event.dart';
part 'list_stock_state.dart';
part 'list_stock_repository.dart';

class ListStockBloc extends Bloc<ListStockEvent, ListStockState> {
  final ListStockRepository _repo = ListStockRepository();

  @override
  ListStockState get initialState => ListStockInitial();

  @override
  Stream<ListStockState> mapEventToState(
    ListStockEvent event,
  ) async* {
    yield ListStockLoading(state.props[0], state.props[1], state.props[2],
        state.props[3], state.props[4]);
    if (event is ListStockLoad) {
      yield* loadStock(event, state);
    } else if (event is ListStockSearch) {
      yield* searchStock(event, state);
    }
  }

  Stream<ListStockState> loadStock(
      ListStockLoad event, ListStockState state) async* {
    Stream<List<Item>> items = await _repo.loadStock(event, state);
    final items0 = event.indexScreen == 0 ? items : state.props[1];
    final items1 = event.indexScreen == 1 ? items : state.props[2];
    final items2 = event.indexScreen == 2 ? items : state.props[3];

    yield ListStockInitial(
      version: state.props[0],
      items0: items0,
      items1: items1,
      items2: items2,
    );
  }

  Stream<ListStockState> searchStock(
      ListStockSearch event, ListStockState state) async* {
    Stream<List<Item>> items = await _repo.searchStock(event, state);

    yield ListStockInitial(
      version: state.props[0],
      items0: state.props[1],
      items1: state.props[2],
      items2: state.props[3],
      itemsSearched: items,
    );
  }
}
