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
    yield ListStockLoading(state.props[0], state.props[1]);

    if (event is ListStockLoad) {
      yield* loadStock(event, state);
    }
  }

  Stream<ListStockState> loadStock(
      ListStockEvent event, ListStockState state) async* {
    Stream<List<Item>> items = await _repo.loadStock(event, state);
    yield ListStockInitial(version: state.props[0], items: items);
  }
}
