import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/models/supplier.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'form_stock_event.dart';
part 'form_stock_state.dart';
part 'form_stock_repository.dart';

class FormStockBloc extends Bloc<FormStockEvent, FormStockState> {
  final FormStockRepository _repo = FormStockRepository();

  @override
  FormStockState get initialState => FormStockInitial();

  @override
  Stream<FormStockState> mapEventToState(
    FormStockEvent event,
  ) async* {
    yield FormStockLoading(state.props[0], state.props[1], state.props[2],
        state.props[3], state.props[4], state.props[5]);

    if (event is FormStockLoadCategory) {
      yield* loadCategory(event, state);
    } else if (event is FormStockAddCategory) {
      yield* addCategory(event, state);
    } else if (event is FormStockLoadSupplier) {
      yield* loadSupplier(event, state);
    } else if (event is FormStockAddSupplier) {
      yield* addSupplier(event, state);
    } else if (event is FormStockAddItem) {
      yield* addItem(event, state);
    } else if (event is FormStockGetImage) {
      yield* getImage(event, state);
    } else if (event is FormStockChooseCategory) {
      yield* chooseCategory(event, state);
    } else if (event is FormStockChooseSupplier) {
      yield* chooseSupplier(event, state);
    }
  }

  Stream<FormStockState> addItem(
      FormStockAddItem event, FormStockState state) async* {
    await _repo.addItem(event, state);

    final int version = state.props[0];
    yield FormStockSuccessItem(
      version + 1,
      state.props[1],
      state.props[2],
      state.props[3],
      state.props[4],
      state.props[5],
    );
  }

  Stream<FormStockState> loadCategory(
      FormStockLoadCategory event, FormStockState state) async* {
    List<Category> result = await _repo.loadCategory();

    final int version = state.props[0];
    yield FormStockInitial(
      version: version + 1,
      listCategory: result,
      imagePath: state.props[2],
      indexCategory: state.props[3],
      indexSupplier: state.props[4],
    );
  }

  Stream<FormStockState> addCategory(
      FormStockAddCategory event, FormStockState state) async* {
    await _repo.addCategory(event);

    final int version = state.props[0];
    yield FormStockSuccessCategory(
        version + 1, state.props[1], state.props[2], 0, state.props[4], state.props[5]);
  }

  Stream<FormStockState> loadSupplier(
      FormStockLoadSupplier event, FormStockState state) async* {
    List<Supplier> result = await _repo.loadSupplier();

    final int version = state.props[0];
    yield FormStockInitial(
      version: version + 1,
      listCategory: state.props[1],
      listSupplier: result,
      imagePath: state.props[2],
      indexCategory: state.props[3],
      indexSupplier: state.props[4],
    );
  }

  Stream<FormStockState> addSupplier(
      FormStockAddSupplier event, FormStockState state) async* {
    await _repo.addSupplier(event);

    final int version = state.props[0];
    yield FormStockSuccessSupplier(version + 1, state.props[1], state.props[2],
        state.props[3], 0, state.props[5]);
  }

  Stream<FormStockState> getImage(
      FormStockGetImage event, FormStockState state) async* {
    final int version = state.props[0];
    yield FormStockInitial(
      version: version + 1,
      listCategory: state.props[1],
      listSupplier: state.props[5],
      imagePath: event.imagePath,
      indexCategory: state.props[3],
      indexSupplier: state.props[4],
    );
  }

  Stream<FormStockState> chooseCategory(
      FormStockChooseCategory event, FormStockState state) async* {
    final int version = state.props[0];
    yield FormStockInitial(
      version: version + 1,
      listCategory: state.props[1],
      listSupplier: state.props[5],
      imagePath: state.props[2],
      indexCategory: event.indexCategory,
      indexSupplier: state.props[4],
    );
  }

  
  Stream<FormStockState> chooseSupplier(
      FormStockChooseSupplier event, FormStockState state) async* {
    final int version = state.props[0];
    yield FormStockInitial(
      version: version + 1,
      listCategory: state.props[1],
      listSupplier: state.props[5],
      imagePath: state.props[2],
      indexCategory: state.props[3],
      indexSupplier:  event.indexSupplier,
    );
  }
}
