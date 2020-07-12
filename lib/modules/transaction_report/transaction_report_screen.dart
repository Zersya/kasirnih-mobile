import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';

import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';
import 'package:ks_bike_mobile/models/transaction.dart';
import 'package:ks_bike_mobile/utils/function.dart';
import "package:collection/collection.dart";

import 'cubit/transaction_report_cubit.dart';

class TransactionReportScreen extends StatefulWidget {
  TransactionReportScreen({Key key}) : super(key: key);

  @override
  _TransactionReportScreenState createState() =>
      _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {
  final TransactionReportCubit _cubit = TransactionReportCubit();

  @override
  void initState() {
    super.initState();
    _cubit.loadTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Transaksi'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(children: <Widget>[
                Text(
                  'Detail Transaksi',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ]),
            ),
          ),
          CubitBuilder<TransactionReportCubit, TransactionReportState>(
            cubit: _cubit,
            builder: (context, state) {
              final stream = state.props[1];

              return StreamBuilder<List<Transaction>>(
                stream: stream,
                initialData: [],
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  final List<Transaction> transactions = snapshot.data;
                  if (transactions.isEmpty) {
                    return Center(child: Text('messages.no_data').tr());
                  }
                  final items = groupBy(transactions, (element) {
                    final dt =
                        DateTime.fromMillisecondsSinceEpoch(element.createdAt);
                    return DateFormat.yMMMMEEEEd('id').format(dt);
                  });

                  return Expanded(
                    flex: 6,
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
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
                              ListTile(
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
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    final Transaction trx = transactions[index];

                                    return ListTile(
                                        onTap: () =>
                                            buildShowDialog(context, trx),
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(trx.code),
                                            Text('${trx.customerName}'),
                                          ],
                                        ),
                                        title: Text(
                                          currencyFormatter.format(trx.profit),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                            'Jumlah Barang : ${trx.items.length}'),
                                        trailing: Text(
                                            trx.paymentMethod.capitalize()));
                                  })
                            ],
                          );
                        }),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future buildShowDialog(BuildContext context, Transaction trx) {
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                controller: scrollCItem,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: trx.items.length,
                                separatorBuilder: (context, index) {
                                  return Divider(height: 8.0);
                                },
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CachedNetworkImage(
                                        imageUrl: trx.items[index].urlImage),
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
