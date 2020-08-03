import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/models/store.dart';
import 'package:ks_bike_mobile/modules/store_form/bloc/store_form_bloc.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:ks_bike_mobile/widgets/custom_text_field.dart';
import 'package:ks_bike_mobile/widgets/raised_button_gradient.dart';
import 'package:easy_localization/easy_localization.dart';

class StoreFormStateScreen extends StatefulWidget {
  StoreFormStateScreen({Key key}) : super(key: key);

  @override
  _StoreFormStateScreenState createState() => _StoreFormStateScreenState();
}

class _StoreFormStateScreenState extends State<StoreFormStateScreen> {
  final TextEditingController _storeNameC = TextEditingController();
  final TextEditingController _storePhoneC = TextEditingController();
  final TextEditingController _storeAddressC = TextEditingController();
  final TextEditingController _storeOwnerNameC = TextEditingController();
  final TextEditingController _storeOwnerPhoneC = TextEditingController();

  final FocusNode _storeNameNode = FocusNode();
  final FocusNode _storePhoneNode = FocusNode();
  final FocusNode _storeAddressNode = FocusNode();
  final FocusNode _storeOwnerNameNode = FocusNode();
  final FocusNode _storeOwnerPhoneNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final StoreFormBloc _bloc = StoreFormBloc(StoreFormStateInitial());

  @override
  void initState() {
    super.initState();

    final FirebaseAnalytics analytics = FirebaseAnalytics();
    analytics.setCurrentScreen(screenName: RouterHelper.kRouteStoreFormState);

    _bloc.add(StoreFormLoad());
    if (kDebugMode) {
      // _storeNameC.text = 'ks-bike 1';
      // _storePhoneC.text = '08192';
      // _storeAddressC.text = 'Jl.Telkom';
      // _storeOwnerNameC.text = 'Salma';
      // _storeOwnerPhoneC.text = '1234';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<StoreFormBloc, StoreFormState>(
            cubit: _bloc,
            builder: (context, state) {
              final Store store = state.props[1];
              if (store == null) {
                return Text("store_registration_screen.store_register").tr();
              } else {
                return Text("store_registration_screen.store_update").tr();
              }
            }),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            _body(context),
            _loading(context),
          ],
        ),
      ),
    );
  }

  Widget _loading(context) {
    return BlocConsumer<StoreFormBloc, StoreFormState>(
        cubit: _bloc,
        listener: (context, state) {
          if (state is StoreFormStateInitial) {
            final Store store = state.props[1];
            if (store != null) {
              _storeNameC.text = store.storeName;
              _storePhoneC.text = store.storePhone;
              _storeAddressC.text = store.storeAddress;
              _storeOwnerNameC.text = store.storeOwnerName;
              _storeOwnerPhoneC.text = store.storeOwnerPhone;
            }
          } else if (state is StoreFormStateSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is StoreFormStateLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            CustomTextField(
              controller: _storeNameC,
              label: tr('store_registration_screen.store_name'),
              node: _storeNameNode,
            ),
            CustomTextField(
              controller: _storePhoneC,
              label: tr('store_registration_screen.store_phone'),
              node: _storePhoneNode,
              keyboardType: TextInputType.phone,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            ),
            CustomTextField(
              controller: _storeAddressC,
              label: tr('store_registration_screen.store_address'),
              node: _storeAddressNode,
            ),
            CustomTextField(
              controller: _storeOwnerNameC,
              label: tr('store_registration_screen.store_owner_name'),
              node: _storeOwnerNameNode,
            ),
            CustomTextField(
              controller: _storeOwnerPhoneC,
              label: tr('store_registration_screen.store_owner_phone'),
              node: _storeOwnerPhoneNode,
            ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButtonGradient(
                width: double.infinity,
                height: 43,
                borderRadius: BorderRadius.circular(4),
                child: BlocBuilder<StoreFormBloc, StoreFormState>(
                    cubit: _bloc,
                    builder: (context, state) {
                      final Store store = state.props[1];
                      return Text(
                        store == null
                            ? 'store_registration_screen.store_register'
                            : 'store_registration_screen.store_update',
                        style: Theme.of(context).textTheme.button,
                      ).tr();
                    }),
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
          ],
        ),
      ),
    );
  }

  void _submit() {
    Store store = _bloc.state.props[1];

    final isUpdate = store != null;

    store = Store(_storeNameC.text, _storePhoneC.text, _storeAddressC.text,
        _storeOwnerNameC.text, _storeOwnerPhoneC.text);
    if (isUpdate) {
      _bloc.add(StoreFormUpdate(store));
    } else {
      _bloc.add(StoreFormRegister(store));
    }
  }
}
