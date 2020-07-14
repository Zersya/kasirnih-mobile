import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubit/cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/payment_method.dart';

import 'package:ks_bike_mobile/models/transaction.dart' as trx;
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transaction_selected_payment_cubit.dart';

part 'transaction_report_state.dart';
part 'transaction_report_repository.dart';

class TransactionReportCubit extends Cubit<TransactionReportState> {
  final TransactionReportRepository _repo = TransactionReportRepository();

  TransactionReportCubit() : super(TransactionReportInitial());

  TransactionSelectedPaymentCubit selectedPaymentCubit;

  void loadTransaction() async {
    emit(TransactionReportLoading(
        state.props[0], state.props[1], state.props[2]));

    final List<PaymentMethod> list = selectedPaymentCubit.state.props[1];

    final transactions = await _repo.loadTransaction(list
        .where((element) => element.isSelected)
        .map((e) => e.name)
        .toList());
    final paymentMethods = await _repo.loadListPaymentMethod();

    int version = state.props[0];
    version++;

    emit(await TransactionReportInitial(
        version: version,
        transaction: transactions,
        paymentMethods: paymentMethods));
  }
}
