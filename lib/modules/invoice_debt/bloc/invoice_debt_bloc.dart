import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ks_bike_mobile/models/invoice.dart';
import 'package:ks_bike_mobile/models/supplier.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'invoice_debt_event.dart';
part 'invoice_debt_state.dart';
part 'invoice_debt_repository.dart';

class InvoiceDebtBloc extends Bloc<InvoiceDebtEvent, InvoiceDebtState> {
  final InvoiceDebtRepository _repo = InvoiceDebtRepository();

  @override
  InvoiceDebtState get initialState => InvoiceDebtInitial();

  @override
  Stream<InvoiceDebtState> mapEventToState(
    InvoiceDebtEvent event,
  ) async* {
    yield InvoiceDebtLoading(state.props[0], state.props[1], state.props[2],
        state.props[3], state.props[4]);

    if (event is InvoiceDebtAddInvoice) {
      yield* addInvoice(event, state);
    } else if (event is InvoiceDebtLoad) {
      yield* loadSupplier(event, state);
    } else if (event is InvoiceDebtAddSupplier) {
      yield* addSupplier(event, state);
    } else if (event is InvoiceDebtGetImage) {
      yield* getImage(event, state);
    } else if (event is InvoiceDebtChooseSupplier) {
      yield* chooseSupplier(event, state);
    } else if (event is InvoiceDebtChooseDate) {
      yield* chooseDate(event, state);
    }
  }

  Stream<InvoiceDebtState> addInvoice(
      InvoiceDebtAddInvoice event, InvoiceDebtState state) async* {
    await _repo.addInvoice(event, state);

    final int version = state.props[0];
    yield InvoiceDebtSuccessInvoice(
      version + 1,
      state.props[1],
      state.props[2],
      state.props[3],
      state.props[4],
    );
  }

  Stream<InvoiceDebtState> addSupplier(
      InvoiceDebtAddSupplier event, InvoiceDebtState state) async* {
    await _repo.addSupplier(event);

    final int version = state.props[0];
    yield InvoiceDebtSuccessSupplier(
      version + 1,
      state.props[1],
      state.props[2],
      state.props[3],
      state.props[4],
    );
  }

  Stream<InvoiceDebtState> loadSupplier(
      InvoiceDebtLoad event, InvoiceDebtState state) async* {
    List<Supplier> result = await _repo.loadSupplier();

    final int version = state.props[0];
    yield InvoiceDebtInitial(
      version: version + 1,
      listSupplier: result,
      imagePath: state.props[2],
      supplier: state.props[3],
      selectedDate: state.props[4],
    );
  }

  Stream<InvoiceDebtState> getImage(
      InvoiceDebtGetImage event, InvoiceDebtState state) async* {
    final int version = state.props[0];
    yield InvoiceDebtInitial(
      version: version + 1,
      listSupplier: state.props[1],
      imagePath: event.imagePath,
      supplier: state.props[3],
      selectedDate: state.props[4],
    );
  }

  Stream<InvoiceDebtState> chooseDate(
      InvoiceDebtChooseDate event, InvoiceDebtState state) async* {
    final int version = state.props[0];
    yield InvoiceDebtInitial(
      version: version + 1,
      listSupplier: state.props[1],
      imagePath: state.props[2],
      supplier: state.props[3],
      selectedDate: event.dateTime,
    );
  }

  Stream<InvoiceDebtState> chooseSupplier(
      InvoiceDebtChooseSupplier event, InvoiceDebtState state) async* {
    final int version = state.props[0];
    yield InvoiceDebtInitial(
      version: version + 1,
      listSupplier: state.props[1],
      imagePath: state.props[2],
      supplier: event.supplier,
      selectedDate: state.props[4],
    );
  }
}
