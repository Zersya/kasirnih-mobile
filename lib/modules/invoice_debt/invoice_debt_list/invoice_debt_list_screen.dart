import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/models/invoice.dart';
import 'package:ks_bike_mobile/utils/function.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';

import 'bloc/invoice_debt_list_bloc.dart';
import 'widgets/simple_chart.dart';

class InvoiceDebtListScreen extends StatefulWidget {
  InvoiceDebtListScreen({Key key}) : super(key: key);

  @override
  _InvoiceDebtListScreenState createState() => _InvoiceDebtListScreenState();
}

class _InvoiceDebtListScreenState extends State<InvoiceDebtListScreen> {
  final InvoiceDebtListBloc _bloc = InvoiceDebtListBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(InvoiceDebtListLoadInvoice());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tagihan Hutang'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          await Navigator.of(context)
              .pushNamed(RouterHelper.kRouteInvoiceDebtForm);
          _bloc.add(InvoiceDebtListLoadInvoice());
        },
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
    return BlocConsumer<InvoiceDebtListBloc, InvoiceDebtListState>(
        bloc: _bloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InvoiceDebtListLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }

  Widget _body(BuildContext context) {
    return BlocConsumer<InvoiceDebtListBloc, InvoiceDebtListState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is InvoiceDebtListSuccessUpdate) {
            _bloc.add(InvoiceDebtListLoadInvoice());
          }
        },
        builder: (context, state) {
          final List<Invoice> listItem = state.props[1];
          if (listItem.isEmpty) {
            return Center(child: Text('Tidak ada data'));
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 60,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SizedBox.expand(
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total Tagihan Hutang',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                            Text(currencyFormatter.format(state.props[2]),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  height: 250,
                  child: SimpleChart.withRealData(listItem.where((element) => !element.isPaid)
                      .map((e) => InvoiceDebtChart(e.supplierName, e.totalDebt))
                      .toList()),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listItem.length + 1,
                    itemBuilder: (context, index) {
                      if (index == listItem.length) {
                        return SizedBox(
                          height: 100,
                        );
                      }
                      final Invoice invoice = listItem[index];
                      final DateTime dt =
                          DateTime.fromMillisecondsSinceEpoch(invoice.dueDate);
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (invoice.urlImage.isEmpty)
                              SizedBox(
                                height: 150,
                                child: Center(
                                  child: Text('Tidak ada gambar'),
                                ),
                              ),
                            if (invoice.urlImage.isNotEmpty)
                              CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                imageUrl: invoice.urlImage,
                                height: 150,
                                width: double.infinity,
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        DateFormat.yMMMMEEEEd('id').format(dt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(
                                                color: invoice.isPaid
                                                    ? Colors.green
                                                    : Colors.red),
                                      ),
                                      Text(invoice.invoiceName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Text(
                                          currencyFormatter
                                              .format(invoice.totalDebt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      _showBottomSheet(context, invoice, state);
                                    },
                                    child: Icon(
                                      Icons.more_vert,
                                      size: 34,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          );
        });
  }

  _showBottomSheet(context, Invoice invoice, InvoiceDebtListState state) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: ListTile(
              title: Text('Tandai Tagihan Terbayar'),
              onTap: () {
                _bloc.add(InvoiceDebtListUpdateHasPaid(
                    invoice.docId, !invoice.isPaid, invoice.totalDebt));
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }
}
