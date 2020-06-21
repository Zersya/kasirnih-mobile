import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/models/new_item_facilities.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:ks_bike_mobile/widgets/custom_text_field.dart';
import 'package:ks_bike_mobile/widgets/raised_button_gradient.dart';
import 'package:easy_localization/easy_localization.dart';

import './bloc/new_item_facilities_bloc.dart';

part 'new_item_facilities_list_screen.dart';
part 'widgets/new_item_facilities_list.dart';

class NewItemFacilitiesScreen extends StatefulWidget {
  NewItemFacilitiesScreen({Key key}) : super(key: key);

  @override
  _NewItemFacilitiesScreenState createState() =>
      _NewItemFacilitiesScreenState();
}

class _NewItemFacilitiesScreenState extends State<NewItemFacilitiesScreen> {
  final NewItemFacilitiesBloc _bloc = NewItemFacilitiesBloc();
  final TextEditingController _itemNameC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc.add(NewItemFacilitiesLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new_item_facilities_screen.new_item_facilities').tr(),
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
    return BlocConsumer<NewItemFacilitiesBloc, NewItemFacilitiesState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is NewItemFacilitiesStateInitial) {
          } else if (state is NewItemFacilitiesStateSuccess) {
            _itemNameC.clear();
            _bloc.add(NewItemFacilitiesLoad());
          }
        },
        builder: (context, state) {
          if (state is NewItemFacilitiesStateLoading) {
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
                controller: _itemNameC,
                label: tr('new_item_facilities_screen.item_name'),
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
                    'new_item_facilities_screen.add_new_item_facilitis',
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
                      'new_item_facilities_screen.list_new_item_facilities',
                      style: Theme.of(context).textTheme.subtitle1,
                    ).tr(),
                  ),
                  SizedBox(
                    height: 450,
                    child: Hero(
                        tag: _bloc, child: NewItemFacilitiesList(bloc: _bloc)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouterHelper.kRouteNewItemFacilitiesList,
                            arguments: _bloc,
                          );
                        },
                        child: Text(
                          'new_item_facilities_screen.see_all',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(decoration: TextDecoration.underline),
                        ).tr(),
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

  void _submit() {
    _bloc.add(NewItemFacilitiesAdd(_itemNameC.text));
  }
}
