import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:collection/collection.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:kasirnih_mobile/models/payment_method.dart';
import 'package:kasirnih_mobile/utils/extensions/string_extension.dart';
import 'package:kasirnih_mobile/models/transaction.dart';
import 'package:kasirnih_mobile/utils/function.dart';
import 'package:kasirnih_mobile/utils/key.dart';
import 'package:kasirnih_mobile/widgets/custom_loading.dart';

import 'widgets/range_picker_widget.dart';
import 'widgets/list_checkbox_listtile_widget.dart';

import 'cubit/range_picker_cubit.dart';
import 'cubit/transaction_report_cubit.dart';
import 'cubit/transaction_selected_payment_cubit.dart';

class TransactionReportScreen extends StatefulWidget {
  TransactionReportScreen({Key key}) : super(key: key);

  @override
  _TransactionReportScreenState createState() =>
      _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {
  final TransactionSelectedPaymentCubit _selectedPaymentCubit =
      TransactionSelectedPaymentCubit();
  final RangePickerCubit _rangePickerCubit = RangePickerCubit();
  final TransactionReportCubit _transactionReportCubit =
      TransactionReportCubit();

  @override
  void initState() {
    super.initState();
    _transactionReportCubit.selectedPaymentCubit = _selectedPaymentCubit;
    _transactionReportCubit.rangePickerCubit = _rangePickerCubit;
    _transactionReportCubit.loadTransaction();

    _selectedPaymentCubit.listen((state) {
      if (state is TransactionSelectedPaymentInitial) {
        List<PaymentMethod> curList = state.props[1];

        if (curList.isNotEmpty) {
          _transactionReportCubit.loadTransaction();
        }
      }
    });

    _rangePickerCubit.listen((state) {
      _transactionReportCubit.loadTransaction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Transaksi'),
      ),
      body: Stack(
        children: <Widget>[
          _body(context),
          _loading(context),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder<TransactionReportCubit, TransactionReportState>(
      cubit: _transactionReportCubit,
      builder: (context, state) {
        final streamTrx = state.props[1];
        final streamPayment = state.props[2];
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: BlocProvider.value(
                                value: _rangePickerCubit,
                                child: RangePickerWidget(),
                              ),
                            );
                          });
                    },
                    child: Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BlocBuilder<RangePickerCubit, RangePickerState>(
                          cubit: _rangePickerCubit,
                          builder: (context, state) {
                            final DateTime start = state.props[0];
                            final DateTime end = state.props[1];
                            if (start != null && end != null) {
                              if (start !=
                                  DateTime(end.year, end.month, end.day)) {
                                return Text(
                                    '${DateFormat.yMMMEd('id').format(start)} - ${DateFormat.yMMMEd('id').format(end)}');
                              } else {
                                return Text(
                                    '${DateFormat.yMMMEd('id').format(start)}');
                              }
                            }
                            return Text('Pilih tanggal periode transaksi');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          buildShowDialogFilterCategory(context, streamPayment);
                        },
                        child: Icon(Icons.filter_list)))
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Detail Transaksi',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.email),
                        label: Text('Email Laporan'),
                        onPressed: () => _reportEmail(),
                      )
                    ]),
              ),
            ),
            StreamBuilder<List<Transaction>>(
              stream: streamTrx,
              initialData: [],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final List<Transaction> transactions = snapshot.data;
                if (transactions.isEmpty) {
                  return Expanded(
                      flex: 6,
                      child: Center(child: Text('messages.no_data').tr()));
                }
                final items = groupBy(transactions, (element) {
                  final dt =
                      DateTime.fromMillisecondsSinceEpoch(element.createdAt);
                  return DateFormat.yMMMMEEEEd('id').format(dt);
                });

                return Expanded(
                  flex: 6,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final key = items.keys.elementAt(index);
                        final List<Transaction> transactions = items[key];
                        final total = transactions.fold(
                            0,
                            (previousValue, element) =>
                                previousValue + element.profit);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: Color(0xFFf4f4f4),
                              child: ListTile(
                                leading: Text('$key',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                                trailing: Text(
                                  currencyFormatter.format(total),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final Transaction trx = transactions[index];

                                  return ListTile(
                                      onTap: () => buildShowDialogDetailTrx(
                                          context, trx),
                                      leading: SizedBox(
                                        width: 80,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(trx.code),
                                            Text('${trx.customerName}'),
                                          ],
                                        ),
                                      ),
                                      title: Text(
                                        currencyFormatter.format(trx.profit),
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                          'Jumlah Barang : ${trx.items.length}'),
                                      trailing:
                                          Text(trx.paymentMethod.capitalize()));
                                })
                          ],
                        );
                      }),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future buildShowDialogFilterCategory(
      BuildContext context, Object streamPayment) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: StreamBuilder<List<PaymentMethod>>(
              stream: streamPayment,
              initialData: [],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final List<PaymentMethod> paymentMethods = snapshot.data;

                if (paymentMethods.isEmpty) {
                  return Center(child: Text('messages.no_data').tr());
                }

                _selectedPaymentCubit.setList(paymentMethods);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Filter Kategori',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Divider(
                      height: 8.0,
                    ),
                    BlocProvider.value(
                        value: _selectedPaymentCubit,
                        child: ListCheckBoxListTile(
                            paymentMethods: paymentMethods)),
                  ],
                );
              },
            ),
          );
        });
  }

  _reportEmail() async {
    final storage = FlutterSecureStorage();
    final email = await storage.read(key: kEmail);

    final dt = DateTime.now();
    final DateTime start =
        _rangePickerCubit.state.props[0] ?? DateTime(dt.year, dt.month);
    final DateTime end =
        _rangePickerCubit.state.props[1] ?? DateTime(dt.year, dt.month + 1, -1);
    final String selected = start != DateTime(end.year, end.month, end.day)
        ? '${DateFormat.yMMMd('id').format(start)} - ${DateFormat.yMMMd('id').format(end)}'
        : DateFormat.yMMMd('id').format(start);

    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Info',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Divider(
                    height: 16.0,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Laporan akan dikirim ke ',
                        style: Theme.of(context).textTheme.bodyText2,
                        children: [
                          TextSpan(
                            text: email,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Periode Transaksi ',
                        style: Theme.of(context).textTheme.bodyText2,
                        children: [
                          TextSpan(
                            text: selected,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                  ),
                  Divider(
                    height: 16.0,
                  ),
                  RaisedButton.icon(
                      onPressed: () {
                        _transactionReportCubit.requestEmail(start, end);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.send),
                      label: Text('Kirim'))
                ],
              ),
            ),
          );
        });
  }

  Widget _loading(context) {
    return BlocBuilder<TransactionReportCubit, TransactionReportState>(
        cubit: _transactionReportCubit,
        builder: (context, state) {
          if (state is TransactionReportLoading) {
            return CustomLoading(
              withBackground: false,
            );
          } else {
            return SizedBox();
          }
        });
  }

  Future buildShowDialogDetailTrx(BuildContext context, Transaction trx) {
    final dt = DateTime.fromMillisecondsSinceEpoch(trx.createdAt);
    final customerName = trx.customerName.isEmpty ? '-' : trx.customerName;
    final scrollCItem = ScrollController();

    return showDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Customer Name ${customerName}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close),
                      )
                    ],
                  ),
                  Divider(height: 16.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text('Code'),
                            subtitle: Text(trx.code),
                          ),
                          ListTile(
                            title: Text('Tanggal'),
                            subtitle:
                                Text(DateFormat.yMMMMEEEEd('id').format(dt)),
                          ),
                          ListTile(
                            title: Text('Total'),
                            subtitle: Text(currencyFormatter.format(trx.total)),
                          ),
                          ListTile(
                            title: Text('Profit'),
                            subtitle:
                                Text(currencyFormatter.format(trx.profit)),
                          ),
                          ListTile(
                            title: Text('Jumlah'),
                            subtitle: Text('${trx.items.length}'),
                          ),
                          ListTile(
                            title: Text('Barang'),
                            subtitle: ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                controller: scrollCItem,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: trx.items.length,
                                separatorBuilder: (context, index) {
                                  return Divider(height: 8.0);
                                },
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: trx.items[index].urlImage.isEmpty
                                        ? Container(
                                            width: 70,
                                            padding: EdgeInsets.all(4.0),
                                            color: Colors.grey[200],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.image),
                                                Text('No Image')
                                              ],
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            width: 70,
                                            fit: BoxFit.fitWidth,
                                            imageUrl:
                                                trx.items[index].urlImage),
                                    title: Text(trx.items[index].itemName),
                                    trailing:
                                        Text('${trx.items[index].qty} Qty'),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
