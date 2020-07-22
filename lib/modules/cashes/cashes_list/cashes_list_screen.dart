import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:collection/collection.dart";
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/models/cashes.dart';

import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';
import 'package:ks_bike_mobile/models/transaction.dart';
import 'package:ks_bike_mobile/utils/function.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';

import 'cubit/cashes_list_cubit.dart';

class CashesListScreen extends StatefulWidget {
  CashesListScreen({Key key}) : super(key: key);

  @override
  _CashesListScreenState createState() => _CashesListScreenState();
}

class _CashesListScreenState extends State<CashesListScreen> {
  final CashesListCubit _cubit = CashesListCubit();

  @override
  void initState() {
    super.initState();
    _cubit.loadTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _body(context),
          _loading(context),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder<CashesListCubit, CashesListState>(
      cubit: _cubit,
      builder: (context, state) {
        final streamData = state.props[1];
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor,
                        Color(0xFF74a6f3)
                      ]),
                ),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Center(
                          child: Text('Kas',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RouterHelper.kRouteCashesForm);
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        leading: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 51.0,
                      ),
                      StreamBuilder<Map<String, dynamic>>(
                          stream: streamData,
                          initialData: {},
                          builder: (context, snapshot) {
                            final int totalTrx = snapshot.data['totalTrx'];
                            final String formated =
                                currencyFormatter.format(totalTrx ?? 0.0);

                            return Text(formated,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold));
                          }),
                    ],
                  ),
                ),
              ),
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top: -60,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.hot_tub)
                                  // Text('Transaksi Hari ini',
                                  //     style: Theme.of(context)
                                  //         .textTheme
                                  //         .bodyText2),
                                  // Text(currencyFormatter.format(80000),
                                  //     style: Theme.of(context)
                                  //         .textTheme
                                  //         .bodyText2
                                  //         .copyWith(
                                  //             color: Theme.of(context)
                                  //                 .primaryColor,
                                  //             fontWeight: FontWeight.bold)),
                                ],
                              )),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.hot_tub)
                                // Text('Transaksi Bulan ini',
                                //     style:
                                //         Theme.of(context).textTheme.bodyText2),
                                // Text(currencyFormatter.format(50000),
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .bodyText2
                                //         .copyWith(
                                //             color:
                                //                 Theme.of(context).primaryColor,
                                //             fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16.0, bottom: 16.0, top: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Riwayat Transaksi',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   'Lihat Semua',
                        //   style:
                        //       Theme.of(context).textTheme.bodyText2.copyWith(),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: streamData,
                initialData: {},
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  final List<Transaction> transactions =
                      snapshot.data['transactions'];

                  final List<Cashes> cashes = snapshot.data['cashes'];

                  if (transactions == null || transactions.isEmpty) {
                    return Center(child: Text('messages.no_data').tr());
                  }

                  final itemsTrx = groupBy(transactions, (element) {
                    final dt =
                        DateTime.fromMillisecondsSinceEpoch(element.createdAt);
                    return DateFormat.yMMMMEEEEd('id').format(dt);
                  });

                  final itemsCashes = groupBy(cashes, (element) {
                    final dt =
                        DateTime.fromMillisecondsSinceEpoch(element.createdAt);
                    return DateFormat.yMMMMEEEEd('id').format(dt);
                  });

                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: itemsTrx.length,
                      padding: EdgeInsets.only(top: 0),
                      separatorBuilder: (context, index) {
                        return Divider(height: 16.0);
                      },
                      itemBuilder: (context, index) {
                        final key = itemsTrx.keys.elementAt(index);
                        final List<Transaction> transactions = itemsTrx[key];
                        final List<Cashes> cashes = itemsCashes[key];

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
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(trx.code),
                                          Text(
                                              '${trx.customerName.capitalize()}'),
                                        ],
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
                                }),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cashes?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final Cashes cas = cashes[index];

                                  return Container(
                                    color: Color(0xFFf4f4f4),
                                    child: ListTile(
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('${cas.name.capitalize()}'),
                                        ],
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('${cas.cashesType()}'),
                                        ],
                                      ),
                                      title: Text(
                                        currencyFormatter.format(cas.total),
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _loading(context) {
    return BlocBuilder<CashesListCubit, CashesListState>(
        cubit: _cubit,
        builder: (context, state) {
          if (state is CashesListLoading) {
            return CustomLoading();
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
