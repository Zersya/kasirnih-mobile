import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasirnih_mobile/helpers/route_helper.dart';
import 'package:kasirnih_mobile/models/invoice.dart';
import 'package:kasirnih_mobile/utils/function.dart';
import 'package:kasirnih_mobile/widgets/custom_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kasirnih_mobile/utils/extensions/string_extension.dart';

import 'bloc/invoice_debt_list_bloc.dart';
import 'widgets/simple_chart.dart';

class InvoiceDebtListScreen extends StatefulWidget {
  InvoiceDebtListScreen({Key key}) : super(key: key);

  @override
  _InvoiceDebtListScreenState createState() => _InvoiceDebtListScreenState();
}

class _InvoiceDebtListScreenState extends State<InvoiceDebtListScreen> {
  final InvoiceDebtListBloc _bloc =
      InvoiceDebtListBloc(InvoiceDebtListInitial());

  @override
  void initState() {
    super.initState();

    final FirebaseAnalytics analytics = FirebaseAnalytics();
    analytics.setCurrentScreen(screenName: RouterHelper.kRouteInvoiceDebt);

    _bloc.add(InvoiceDebtListLoadInvoice());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('invoice_debt_screen.invoice_debt').tr(),
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
        cubit: _bloc,
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
        cubit: _bloc,
        listener: (context, state) {
          if (state is InvoiceDebtListSuccessUpdate) {
            _bloc.add(InvoiceDebtListLoadInvoice());
          }
        },
        builder: (context, state) {
          final List<Invoice> listItem = state.props[1];
          if (listItem.isEmpty) {
            return Center(child: Text('messages.no_data').tr());
          }
          List<InvoiceDebtChart> listDebtChart = listItem
              .where((element) => !element.isPaid)
              .map((e) =>
                  InvoiceDebtChart(e.supplierName.capitalize(), e.totalDebt))
              .toList();

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
                              'invoice_debt_screen.total_invoice_debt',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ).tr(),
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
                  child: listDebtChart.isEmpty
                      ? Center(child: Text('invoice_debt_screen.no_debt').tr())
                      : SimpleChart.withRealData(listDebtChart),
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
                                  child: Text('messages.no_image').tr(),
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
                                      Text(invoice.invoiceName.capitalize(),
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
              title: Text(invoice.isPaid
                      ? 'invoice_debt_screen.mark_as_invoice_not_paid'
                      : 'invoice_debt_screen.mark_as_invoice_paid')
                  .tr(),
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
