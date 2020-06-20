import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/models/store.dart';
import 'package:ks_bike_mobile/modules/store_registration/bloc/store_registration_bloc.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:ks_bike_mobile/widgets/custom_text_field.dart';
import 'package:ks_bike_mobile/widgets/raised_button_gradient.dart';
import 'package:easy_localization/easy_localization.dart';

class StoreRegistrationScreen extends StatefulWidget {
  StoreRegistrationScreen({Key key}) : super(key: key);

  @override
  _StoreRegistrationScreenState createState() =>
      _StoreRegistrationScreenState();
}

class _StoreRegistrationScreenState extends State<StoreRegistrationScreen> {
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

  final StoreRegistrationBloc _bloc = StoreRegistrationBloc();

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      _storeNameC.text = 'ks-bike 1';
      _storePhoneC.text = '08192';
      _storeAddressC.text = 'Jl.Telkom';
      _storeOwnerNameC.text = 'Salma';
      _storeOwnerPhoneC.text = '1234';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("store_registration_screen.store_register").tr(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              _body(context),
              _loading(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading(context) {
    return BlocConsumer<StoreRegistrationBloc, StoreRegistrationState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is StoreRegistrationSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is StoreRegistrationLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }

  Widget _body(BuildContext context) {
    return Column(
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
            child: Text(
              'store_registration_screen.store_register',
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
                _register();
              }
            }),
      ],
    );
  }

  void _register() {
    final store = Store(_storeNameC.text, _storePhoneC.text,
        _storeAddressC.text, _storeOwnerNameC.text, _storeOwnerPhoneC.text);

    _bloc.add(StoreRegistrationRegister(store));
  }
}
