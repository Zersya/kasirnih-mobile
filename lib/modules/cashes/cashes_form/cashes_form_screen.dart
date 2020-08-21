import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kasirnih_mobile/modules/cashes/cashes_form/cubit/cashes_form_cubit.dart';
import 'package:kasirnih_mobile/utils/toast.dart';
import 'package:kasirnih_mobile/widgets/custom_loading.dart';
import 'package:kasirnih_mobile/widgets/custom_text_field.dart';
import 'package:kasirnih_mobile/widgets/raised_button_gradient.dart';

class CashesFormScreen extends StatefulWidget {
  CashesFormScreen({Key key}) : super(key: key);

  @override
  _CashesFormScreenState createState() => _CashesFormScreenState();
}

class _CashesFormScreenState extends State<CashesFormScreen> {
  final TextEditingController _nameC = TextEditingController();
  final MoneyMaskedTextController _totalC = MoneyMaskedTextController(
      thousandSeparator: '.',
      initialValue: 0,
      precision: 0,
      decimalSeparator: '',
      leftSymbol: 'Rp. ');
  final _formKey = GlobalKey<FormState>();
  final CashesFormCubit _cubit = CashesFormCubit();

  @override
  void initState() {
    super.initState();
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    analytics.setCurrentScreen(screenName: '/cashes_form');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi Kas'),
      ),
      body: Stack(
        children: <Widget>[
          _body(context),
          _loading(context),
        ],
      ),
    );
  }

  Widget _loading(context) {
    return BlocConsumer<CashesFormCubit, CashesFormState>(
        cubit: _cubit,
        listener: (context, state) {
          if (state is CashesFormSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is CashesFormLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            CustomTextField(
              controller: _nameC,
              label: 'Nama Transaksi',
            ),
            BlocBuilder<CashesFormCubit, CashesFormState>(
              cubit: _cubit,
              builder: (context, state) {
                return DropdownButton<int>(
                  hint: Text('Pilih Tipe Kas'),
                  isExpanded: true,
                  onChanged: (value) {
                    _cubit.changeType(value);
                  },
                  value: state.props[0],
                  items: [
                    DropdownMenuItem(
                      child: Text('Pengeluaran'),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text('Pemasukan'),
                      value: 1,
                    ),
                  ],
                );
              },
            ),
            CustomTextField(
              controller: _totalC,
              label: 'Total Transaksi',
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButtonGradient(
                width: double.infinity,
                height: 43,
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  'Tambah Transaksi',
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  if (_cubit.state.props[0] == null) {
                    toastError('Silahkan pilih tipe kas');
                  } else if (_formKey.currentState.validate()) {
                    FocusScope.of(context).unfocus();
                    _submitTrx();
                  }
                }),
          ],
        ),
      ),
    );
  }

  _submitTrx() {
    _cubit.submitCashes(_nameC.text, _totalC.numberValue.toInt());
  }
}
