import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasirnih_mobile/helpers/route_helper.dart';
import 'package:kasirnih_mobile/models/item.dart';
import 'package:kasirnih_mobile/models/transaction.dart';
import 'package:kasirnih_mobile/modules/summary/bloc/summary_bloc.dart';
import 'package:kasirnih_mobile/utils/function.dart';
import 'package:kasirnih_mobile/utils/toast.dart';
import 'package:kasirnih_mobile/widgets/custom_text_field.dart';

class SummaryScreen extends StatefulWidget {
  final List<Item> selectedItems;
  SummaryScreen({Key key, this.selectedItems}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  SummaryBloc _summaryBloc;

  final TextEditingController _customerNameC = TextEditingController();
  final TextEditingController _sellPriceC = TextEditingController();
  final TextEditingController _qtyC = TextEditingController();
  final TextEditingController _discountC = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  String codeTransaction;

  @override
  void initState() {
    super.initState();
    _summaryBloc = SummaryBloc(SummaryInitial(0, items: widget.selectedItems));
    _summaryBloc.add(SummaryLoad());
  }

  @override
  Widget build(BuildContext context) {
    final dateNow = DateFormat.yMMMMEEEEd('id').format(DateTime.now());
    final timeNow = DateFormat.Hm('id').format(DateTime.now());

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_summaryBloc.state.props[1]);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ringkasan'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BlocBuilder<SummaryBloc, SummaryState>(
                      cubit: _summaryBloc,
                      builder: (context, state) {
                        return StreamBuilder<String>(
                            stream: state.props[3],
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Flexible(
                                    child: LinearProgressIndicator());
                              }
                              codeTransaction = snapshot.data;
                              return Text(
                                codeTransaction,
                                style: Theme.of(context).textTheme.subtitle1,
                              );
                            });
                      },
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      '$dateNow | $timeNow',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                CustomTextField(
                  controller: _customerNameC,
                  label: 'Customer name',
                ),
                SizedBox(height: 8.0),
                BlocBuilder<SummaryBloc, SummaryState>(
                  cubit: _summaryBloc,
                  builder: (context, state) {
                    List<Item> items = state.props[1];

                    return SizedBox(
                      height: 300,
                      child: Scrollbar(
                        controller: _scrollController,
                        isAlwaysShown: true,
                        child: ListView.builder(
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final subItemtotal =
                                  items[index].qty * items[index].sellPrice;

                              return SizedBox(
                                height: 100,
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: CachedNetworkImage(
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          imageUrl: items[index].urlImage,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: InkWell(
                                          onTap: () async {
                                            _qtyC.text =
                                                items[index].qty.toString();
                                            _sellPriceC.text = items[index]
                                                .sellPrice
                                                .toString();
                                            await buildShowDialog(
                                                context, items, index);
                                            _qtyC.clear();
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                items[index].itemName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2,
                                                      text:
                                                          '${items[index].qty.toString()} x '),
                                                  TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2,
                                                      text: currencyFormatter
                                                          .format(items[index]
                                                              .sellPrice))
                                                ]),
                                              ),
                                              Text(
                                                  currencyFormatter
                                                      .format(subItemtotal),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          _qtyC.text =
                                              items[index].qty.toString();
                                          _sellPriceC.text =
                                              items[index].sellPrice.toString();
                                          await buildShowDialog(
                                              context, items, index);
                                          _qtyC.clear();
                                        },
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                BlocBuilder<SummaryBloc, SummaryState>(
                  cubit: _summaryBloc,
                  builder: (context, state) {
                    List<Item> items = state.props[1];
                    final subtotal = items.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + (element.qty * element.sellPrice));
                    return Container(
                      color: Color(0xFFededed),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Subtotal',
                                  style: Theme.of(context).textTheme.subtitle2),
                              Text(currencyFormatter.format(subtotal),
                                  style: Theme.of(context).textTheme.subtitle2)
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Diskon',
                                  style: Theme.of(context).textTheme.subtitle2),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _discountC,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.only(
                                          top: 0, right: 4, left: 4),
                                      hintText: '0'),
                                  onChanged: (value) {
                                    _summaryBloc.add(
                                        SummaryAddDiscount(int.parse(value)));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                BlocBuilder<SummaryBloc, SummaryState>(
                  cubit: _summaryBloc,
                  builder: (context, state) {
                    List<Item> items = state.props[1];
                    int discount = state.props[2];

                    final subtotal = items.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + (element.qty * element.sellPrice));
                    final total = subtotal - discount;

                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Total',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                            Text(currencyFormatter.format(total),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text(
                                'Bayar (${currencyFormatter.format(total)})'),
                            onPressed: total <= 0
                                ? null
                                : () {
                                    final dt = DateTime.now();
                                    Transaction transaction = Transaction(
                                      codeTransaction,
                                      _customerNameC.text,
                                      subtotal,
                                      discount,
                                      total,
                                      dt.millisecondsSinceEpoch,
                                      items,
                                    );
                                    Navigator.of(context).pushNamed(
                                      RouterHelper.kRoutePayment,
                                      arguments: transaction,
                                    );
                                  },
                          ),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context, List<Item> items, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Ubah Jumlah dan Harga',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(
                  height: 16.0,
                ),
                RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2,
                      text: 'Ubah Jumlah ',
                      children: [
                        TextSpan(
                          text: items[index].itemName,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          int qty = int.parse(_qtyC.text);
                          if (qty <= 0) return;
                          qty--;
                          _qtyC.text = '$qty';
                        },
                      ),
                      SizedBox(
                        height: 45.0,
                        width: 45.0,
                        child: TextField(
                          controller: _qtyC,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(
                                  top: 0, right: 8.0, left: 8.0),
                              hintText: '0'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          int qty = int.parse(_qtyC.text);
                          qty++;
                          _qtyC.text = '$qty';
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 16.0,
                ),
                RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2,
                      text: 'Ubah Harga ',
                      children: [
                        TextSpan(
                          text: items[index].itemName,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _sellPriceC,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.only(top: 0, right: 8, left: 8),
                            hintText: '0'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        OutlineButton(
                          child: Text('Batalkan'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          child: Text('Simpan'),
                          onPressed: () {
                            final int qty = int.parse(_qtyC.text);
                            final int price = int.parse(_sellPriceC.text);
                            if (qty > items[index].totalStock) {
                              toastError(
                                  'Stok tersisa ${items[index].totalStock}');
                              return;
                            }
                            _summaryBloc
                                .add(SummaryChangeQty(index, qty, price));
                            Navigator.of(context).pop();
                          },
                        )
                      ]),
                ),
              ],
            ),
          );
        });
  }
}
