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

part 'invoice_debt_form_event.dart';
part 'invoice_debt_form_state.dart';
part 'invoice_debt_form_repository.dart';

class InvoiceDebtFormBloc extends Bloc<InvoiceDebtFormEvent, InvoiceDebtFormState> {
  final InvoiceDebtFormRepository _repo = InvoiceDebtFormRepository();

  InvoiceDebtFormBloc(InvoiceDebtFormState initialState) : super(initialState);

  @override
  Stream<InvoiceDebtFormState> mapEventToState(
    InvoiceDebtFormEvent event,
  ) async* {
    yield InvoiceDebtFormLoading(state.props[0], state.props[1], state.props[2],
        state.props[3], state.props[4]);

    if (event is InvoiceDebtFormLoadSupplier) {
      yield* loadSupplier(event, state);
    }else if (event is InvoiceDebtFormAddInvoice) {
      yield* addInvoice(event, state);
    } else if (event is InvoiceDebtFormAddSupplier) {
      yield* addSupplier(event, state);
    } else if (event is InvoiceDebtFormGetImage) {
      yield* getImage(event, state);
    } else if (event is InvoiceDebtFormChooseSupplier) {
      yield* chooseSupplier(event, state);
    } else if (event is InvoiceDebtFormChooseDate) {
      yield* chooseDate(event, state);
    }
  }

  Stream<InvoiceDebtFormState> loadSupplier(
      InvoiceDebtFormLoadSupplier event, InvoiceDebtFormState state) async* {
    List<Supplier> result = await _repo.loadSupplier();

    final int version = state.props[0];
    yield InvoiceDebtFormInitial(
      version: version + 1,
      listSupplier: result,
      imagePath: state.props[2],
      indexSupplier: state.props[3],
      selectedDate: state.props[4],
    );
  }

  Stream<InvoiceDebtFormState> addInvoice(
      InvoiceDebtFormAddInvoice event, InvoiceDebtFormState state) async* {
    await _repo.addInvoice(event, state);

    final int version = state.props[0];
    yield InvoiceDebtFormSuccessInvoice(
      version + 1,
      state.props[1],
      state.props[2],
      state.props[3],
      state.props[4],
    );
  }

  Stream<InvoiceDebtFormState> addSupplier(
      InvoiceDebtFormAddSupplier event, InvoiceDebtFormState state) async* {
    await _repo.addSupplier(event);

    final int version = state.props[0];
    yield InvoiceDebtFormSuccessSupplier(
      version + 1,
      state.props[1],
      state.props[2],
      0,
      state.props[4],
    );
  }

  Stream<InvoiceDebtFormState> getImage(
      InvoiceDebtFormGetImage event, InvoiceDebtFormState state) async* {
    final int version = state.props[0];
    yield InvoiceDebtFormInitial(
      version: version + 1,
      listSupplier: state.props[1],
      imagePath: event.imagePath,
      indexSupplier: state.props[3],
      selectedDate: state.props[4],
    );
  }

  Stream<InvoiceDebtFormState> chooseDate(
      InvoiceDebtFormChooseDate event, InvoiceDebtFormState state) async* {
    final int version = state.props[0];
    yield InvoiceDebtFormInitial(
      version: version + 1,
      listSupplier: state.props[1],
      imagePath: state.props[2],
      indexSupplier: state.props[3],
      selectedDate: event.dateTime,
    );
  }

  Stream<InvoiceDebtFormState> chooseSupplier(
      InvoiceDebtFormChooseSupplier event, InvoiceDebtFormState state) async* {
    final int version = state.props[0];
    yield InvoiceDebtFormInitial(
      version: version + 1,
      listSupplier: state.props[1],
      imagePath: state.props[2],
      indexSupplier: event.indexSupplier,
      selectedDate: state.props[4],
    );
  }
}
