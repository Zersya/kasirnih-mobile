import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasirnih_mobile/models/payment_method.dart';

part 'transaction_selected_payment_state.dart';

class TransactionSelectedPaymentCubit
    extends Cubit<TransactionSelectedPaymentState> {
  TransactionSelectedPaymentCubit()
      : super(TransactionSelectedPaymentInitial());

  void setList(List<PaymentMethod> list) {
    List<PaymentMethod> curList = state.props[1];
    if (list.isNotEmpty) {
      for (int i = 0; i < curList.length; i++) {
        list[i].isSelected = curList[i].isSelected;
      }
    }
    emit(TransactionSelectedPaymentInitial(
        version: state.incrementV(), list: list));
  }

  void changeSelected(int index, bool value) {
    List<PaymentMethod> list = state.props[1];
    list[index].isSelected = value;

    emit(TransactionSelectedPaymentInitial(
        version: state.incrementV(), list: list));
  }
}
