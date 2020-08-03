import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/models/payment_method.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:ks_bike_mobile/widgets/custom_text_field.dart';
import 'package:ks_bike_mobile/widgets/raised_button_gradient.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';

import 'bloc/payment_method_bloc.dart';

class PaymentMethodScreen extends StatefulWidget {
  PaymentMethodScreen({Key key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final PaymentMethodBloc _bloc = PaymentMethodBloc();
  final TextEditingController _paymentName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final FirebaseAnalytics analytics = FirebaseAnalytics();
    analytics.setCurrentScreen(screenName: RouterHelper.kRoutePaymentMethod);

    _bloc.add(PaymentMethodLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('payment_method_screen.payment_method').tr(),
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
    return BlocConsumer<PaymentMethodBloc, PaymentMethodState>(
        cubit: _bloc,
        listener: (context, state) {
          if (state is PaymentMethodStateInitial) {
          } else if (state is PaymentMethodStateSuccess) {
            _paymentName.clear();
            _bloc.add(PaymentMethodLoad());
          }
        },
        builder: (context, state) {
          if (state is PaymentMethodStateLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: CustomTextField(
                controller: _paymentName,
                label: tr('payment_method_screen.item_name'),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: RaisedButtonGradient(
                  width: double.infinity,
                  height: 43,
                  borderRadius: BorderRadius.circular(4),
                  child: Text(
                    'payment_method_screen.add_new_payment_method',
                    style: Theme.of(context).textTheme.button,
                  ).tr(),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      _submit();
                    }
                  }),
            ),
            SizedBox(
              height: 16.0,
            ),
            Card(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'payment_method_screen.list_payment_method',
                      style: Theme.of(context).textTheme.subtitle1,
                    ).tr(),
                  ),
                  Divider(),
                  SizedBox(
                    height: 450,
                    child: Hero(
                      tag: _bloc,
                      child: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
                          cubit: _bloc,
                          builder: (context, state) {
                            final List<PaymentMethod> listItem = state.props[1];
                            if (listItem.isEmpty) {
                              return Center(
                                  child: Text('payment_method_screen.no_list')
                                      .tr());
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: listItem.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title:
                                        Text(listItem[index].name.capitalize()),
                                  );
                                });
                          }),
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

  void _submit() {
    _bloc.add(PaymentMethodAdd(_paymentName.text));
  }
}
