import 'package:flutter/material.dart';
import 'package:kasirnih_mobile/models/payment_method.dart';
import 'package:kasirnih_mobile/modules/transaction_report/cubit/transaction_selected_payment_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kasirnih_mobile/utils/extensions/string_extension.dart';

class ListCheckBoxListTile extends StatelessWidget {
  const ListCheckBoxListTile({
    Key key,
    @required this.paymentMethods,
  }) : super(key: key);

  final List<PaymentMethod> paymentMethods;

  @override
  Widget build(BuildContext context) {
    // final TransactionSelectedPaymentCubit _selectedPaymentCubit =
    //     BlocProvider.of<TransactionSelectedPaymentCubit>(context);
    return BlocBuilder<TransactionSelectedPaymentCubit,
        TransactionSelectedPaymentState>(
      builder: (context, state) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                value: paymentMethods[index].isSelected,
                title: Text(paymentMethods[index].name.capitalize()),
                onChanged: (value) {
                  context
                      .bloc<TransactionSelectedPaymentCubit>()
                      .changeSelected(index, value);
                },
              );
            });
      },
    );
  }
}
