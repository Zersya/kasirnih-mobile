import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/models/payment_method.dart';

import 'package:ks_bike_mobile/models/transaction.dart' as trx;
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';

import 'transaction_selected_payment_cubit.dart';
import 'range_picker_cubit.dart';

part 'transaction_report_state.dart';
part 'transaction_report_repository.dart';

class TransactionReportCubit extends Cubit<TransactionReportState> {
  final TransactionReportRepository _repo = TransactionReportRepository();

  TransactionReportCubit() : super(TransactionReportInitial());

  TransactionSelectedPaymentCubit selectedPaymentCubit;
  RangePickerCubit rangePickerCubit;

  void loadTransaction() async {
    emit(TransactionReportLoading(
        state.props[0], state.props[1], state.props[2]));

    final List<PaymentMethod> list = selectedPaymentCubit.state.props[1];
    final List<String> keys =
        list.where((element) => element.isSelected).map((e) => e.name).toList();
    final DateTime start = rangePickerCubit.state.props[0];
    final DateTime end = rangePickerCubit.state.props[1];

    final transactions = await _repo.loadTransaction(keys, start, end);
    final paymentMethods = await _repo.loadListPaymentMethod();

    int version = state.props[0];
    version++;

    emit(await TransactionReportInitial(
        version: version,
        transaction: transactions,
        paymentMethods: paymentMethods));
  }

  void requestEmail(DateTime start, DateTime end) async {
    await _repo.requestEmail(start, end);

    int version = state.props[0];
    version++;

    emit(
      await TransactionReportInitial(
        version: version,
        transaction: state.props[1],
        paymentMethods: state.props[2],
      ),
    );
  }
}
