import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ks_bike_mobile/models/payment_method.dart';
import 'package:ks_bike_mobile/models/transaction.dart';
import 'package:ks_bike_mobile/modules/payment/bloc/payment_bloc.dart';
import 'package:ks_bike_mobile/modules/payment/widgets/print_widget.dart';
import 'package:ks_bike_mobile/utils/function.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';

class PaymentScreen extends StatefulWidget {
  final Transaction transaction;
  PaymentScreen({Key key, this.transaction}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentBloc _paymentBloc = PaymentBloc(PaymentInitial());
  TotalChangeBloc _totalChangeBloc;

  final MoneyMaskedTextController _paidC = MoneyMaskedTextController(
      thousandSeparator: '.',
      initialValue: 0,
      precision: 0,
      decimalSeparator: '',
      leftSymbol: 'Rp. ');

  String codeTransaction;

  @override
  void initState() {
    super.initState();
    _totalChangeBloc = TotalChangeBloc(widget.transaction.total);
    _paymentBloc.add(PaymentLoad());

    _paidC.addListener(() {
      _totalChangeBloc.add(TotalChangeEvent(
          _paidC.numberValue.floor(), widget.transaction.total));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
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
    return BlocBuilder<PaymentBloc, PaymentState>(
        cubit: _paymentBloc,
        builder: (context, state) {
          if (state is PaymentLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }

  SingleChildScrollView _body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<PaymentBloc, PaymentState>(
                cubit: _paymentBloc,
                builder: (context, state) {
                  return StreamBuilder<String>(
                      stream: state.props[1],
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return LinearProgressIndicator();
                        }
                        codeTransaction = snapshot.data;
                        return Card(
                          child: ListTile(
                            title: Text(
                              '$codeTransaction',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            trailing: Text(
                              '${widget.transaction.customerName}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        );
                      });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Total Bayar',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        currencyFormatter.format(widget.transaction.total),
                        style: Theme.of(context).textTheme.headline5),
                  ),
                ),
              ),
              Divider(
                height: 16.0,
              ),
              Text('Metode Pembayaran',
                  style: Theme.of(context).textTheme.headline6),
              BlocBuilder<PaymentBloc, PaymentState>(
                cubit: _paymentBloc,
                builder: (context, state) {
                  final value = state.props[2];
                  final List<PaymentMethod> list = state.props[3];
                  if (list.isEmpty) {
                    return Center(child: Text('messages.no_data').tr());
                  }
                  return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio: 2 / 1),
                      itemBuilder: (context, index) {
                        return ChoiceWidget(
                          label: list[index].name.capitalize(),
                          value: '$value',
                          onTap: (value) {
                            _paymentBloc.add(PaymentChooseMethod(value));
                          },
                        );
                      });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Text('Jumlah yang dibayar',
                  style: Theme.of(context).textTheme.headline6),
              Column(
                children: <Widget>[
                  Wrap(children: <Widget>[
                    ChoiceWidget(
                      label: 'Rp. 20.000',
                      onTap: (value) {
                        int paid = _paidC.numberValue.floor();
                        paid += 20000;
                        _paidC.text = '$paid';
                      },
                    ),
                    ChoiceWidget(
                      label: 'Rp. 50.000',
                      onTap: (value) {
                        int paid = _paidC.numberValue.floor();
                        paid += 50000;
                        _paidC.text = '$paid';
                      },
                    ),
                    ChoiceWidget(
                      label: 'Rp. 100.000',
                      onTap: (value) {
                        int paid = _paidC.numberValue.floor();
                        paid += 100000;
                        _paidC.text = '$paid';
                      },
                    ),
                    ChoiceWidget(
                      label: 'Uang Pas',
                      onTap: (value) {
                        _paidC.text = '${widget.transaction.total}';
                      },
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26,
                    ),
                    const BoxShadow(
                      color: Color(0xFFF4F4F4),
                      spreadRadius: -2.0,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _paidC,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(filled: false, border: InputBorder.none),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                ),
              ),
              Divider(
                height: 16.0,
              ),
              BlocBuilder<TotalChangeBloc, int>(
                cubit: _totalChangeBloc,
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total kembalian',
                          style: Theme.of(context).textTheme.headline6),
                      Text(currencyFormatter.format(state),
                          style: Theme.of(context).textTheme.headline5),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlineButton(
                      child: Text('Batalkan'),
                      onPressed: () {
                        buildShowDialogCancel(context);
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  BlocConsumer<PaymentBloc, PaymentState>(
                    cubit: _paymentBloc,
                    listener: (context, state) async {
                      if (state is PaymentSuccess) {
                        final Transaction trx = state.props[4];
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: PrintWidget(
                                  transaction: trx,
                                ),
                              );
                            });
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      } else if (state is PaymentFailed) {
                        _paymentBloc.add(PaymentLoad());
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<TotalChangeBloc, int>(
                        cubit: _totalChangeBloc,
                        builder: (context, state) {
                          final String paymentMethod =
                              _paymentBloc.state.props[2];

                          return Expanded(
                            child: RaisedButton(
                              child: Text('Konfirmasi'),
                              onPressed: state < 0 ||
                                      _paidC.numberValue == 0 ||
                                      paymentMethod.isEmpty
                                  ? null
                                  : () => _showDialogConfirm(context, state),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ]),
      ),
    );
  }

  _showDialogConfirm(context, state) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text('Konfirmasi pembayaran'),
            actions: <Widget>[
              FlatButton(
                child: Text('${tr('labels.yes')}'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _confirmPaid(state);
                },
              ),
              FlatButton(
                child: Text('${tr('labels.no')}'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _confirmPaid(state) {
    final totalBuyPriceItem = widget.transaction.items.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.buyPrice * element.qty));

    final trx = widget.transaction.copyWith(
        code: codeTransaction,
        paymentMethod: _paymentBloc.state.props[2],
        totalPaid: _paidC.numberValue.floor(),
        totalChange: state,
        profit: widget.transaction.total - totalBuyPriceItem);

    _paymentBloc.add(PaymentSubmit(trx));
  }

  Future buildShowDialogCancel(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Kamu yakin ingin membatalkannya?'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            actions: <Widget>[
              FlatButton(
                child: Text('Tidak'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Iya'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          );
        });
  }
}

class ChoiceWidget extends StatelessWidget {
  const ChoiceWidget({
    Key key,
    @required this.label,
    this.value = '',
    this.onTap,
    this.width = 150,
  }) : super(key: key);

  final String label;
  final Function(String) onTap;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final bool isActive = value.toLowerCase() == label.toLowerCase();

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => onTap(label.toLowerCase()),
        child: Card(
          elevation: 2.0,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Theme.of(context).primaryColor),
                color:
                    isActive ? Theme.of(context).primaryColor : Colors.white),
            child: Text('$label',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: isActive ? Colors.white : Colors.black87)),
          ),
        ),
      ),
    );
  }
}
