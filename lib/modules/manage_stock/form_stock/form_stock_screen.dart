import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:ks_bike_mobile/widgets/custom_text_field.dart';
import 'package:ks_bike_mobile/widgets/raised_button_gradient.dart';

import 'bloc/form_stock_bloc.dart';

class FormStockScreen extends StatefulWidget {
  FormStockScreen({Key key}) : super(key: key);

  @override
  _FormStockScreenState createState() => _FormStockScreenState();
}

class _FormStockScreenState extends State<FormStockScreen> {
  final TextEditingController _itemNameC = TextEditingController();
  final TextEditingController _totalStockC = TextEditingController();
  final TextEditingController _buyPrice = TextEditingController();
  final TextEditingController _sellPrice = TextEditingController();
  final TextEditingController _categoryName = TextEditingController();

  final FormStockBloc _bloc = FormStockBloc();
  final _formKey = GlobalKey<FormState>();
  final _categoryForm = GlobalKey<FormState>();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _bloc.add(FormStockLoadCategory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('form_stock_screen.add_stock').tr(),
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
    return BlocConsumer<FormStockBloc, FormStockState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is FormStockInitial) {
          } else if (state is FormStockSuccessCategory) {
            _categoryName.clear();
            _bloc.add(FormStockLoadCategory());
          } else if (state is FormStockSuccessItem) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is FormStockLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'form_stock_screen.upload_photo_item',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.bold),
              ).tr(),
              SizedBox(
                height: 8.0,
              ),
              Card(
                margin: EdgeInsets.zero,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: buildImage(context),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                controller: _itemNameC,
                label: tr('form_stock_screen.item_name'),
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: BlocBuilder<FormStockBloc, FormStockState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          if (state is FormStockLoading) {
                            return LinearProgressIndicator();
                          }
                          final List<Category> listCategory = state.props[1];
                          final int value = state.props[3];

                          if (listCategory.isEmpty) {
                            return Text('messages.no_data').tr();
                          }

                          return DropdownButton<int>(
                              isExpanded: true,
                              hint: Text('form_stock_screen.choose_category')
                                  .tr(),
                              value: value,
                              items: listCategory
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e.name),
                                        value: listCategory.indexOf(e),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                _bloc.add(FormStockChooseCategory(value));
                              });
                        }),
                  ),
                  FlatButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _dialogAddCategory(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              CustomTextField(
                controller: _totalStockC,
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                label: tr('form_stock_screen.total_stock'),
              ),
              SizedBox(height: 8.0),
              CustomTextField(
                controller: _buyPrice,
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                label: tr('form_stock_screen.buy_price'),
              ),
              SizedBox(height: 8.0),
              CustomTextField(
                controller: _sellPrice,
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                label: tr('form_stock_screen.sell_price'),
              ),
              SizedBox(height: 16.0),
              RaisedButtonGradient(
                  width: double.infinity,
                  height: 43,
                  borderRadius: BorderRadius.circular(4),
                  child: Text(
                    'form_stock_screen.save_item',
                    style: Theme.of(context).textTheme.button,
                  ).tr(),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      _submitFormStock();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    return BlocBuilder<FormStockBloc, FormStockState>(
        bloc: _bloc,
        builder: (context, state) {
          final String imagePath = state.props[2];
          if (imagePath != null) {
            return Image.file(File(imagePath));
          }
          return Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: FlatButton(
              child: Text('form_stock_screen.choose_image_item').tr(),
              onPressed: () {
                _dialogChooseImage(context);
              },
            ),
          );
        });
  }

  _submitFormStock() {
    _bloc.add(FormStockAddItem(_itemNameC.text, int.parse(_totalStockC.text), int.parse(_buyPrice.text), int.parse(_sellPrice.text)));
  }

  _submitCategory() {
    _bloc.add(FormStockAddCategory(_categoryName.text));
  }

  _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 70);
    _bloc.add(FormStockGetImage(pickedFile.path));
  }

  _dialogChooseImage(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  'widgets.choose_image_source',
                  style: Theme.of(context).textTheme.subtitle1,
                ).tr(),
                SizedBox(
                  height: 16.0,
                ),
                ListTile(
                  title: Text('Kamera'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    title: Text('Gallery'),
                    onTap: () {
                      _getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }

  _dialogAddCategory(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Form(
              key: _categoryForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'form_stock_screen.add_category',
                    style: Theme.of(context).textTheme.subtitle1,
                  ).tr(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: _categoryName,
                      label: tr('form_stock_screen.category_name'),
                    ),
                  ),
                  RaisedButtonGradient(
                      width: double.infinity,
                      height: 43,
                      child: Text(
                        'form_stock_screen.add_category',
                        style: Theme.of(context).textTheme.button,
                      ).tr(),
                      onPressed: () {
                        if (_categoryForm.currentState.validate()) {
                          FocusScope.of(_categoryForm.currentContext).unfocus();
                          Navigator.of(context).pop();

                          _submitCategory();
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}