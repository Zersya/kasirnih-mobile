import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ks_bike_mobile/models/supplier.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:ks_bike_mobile/widgets/custom_text_field.dart';
import 'package:ks_bike_mobile/widgets/raised_button_gradient.dart';
import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';

import 'bloc/invoice_debt_form_bloc.dart';

class InvoiceDebtFormScreen extends StatefulWidget {
  InvoiceDebtFormScreen({Key key}) : super(key: key);

  @override
  _InvoiceDebtFormScreenState createState() => _InvoiceDebtFormScreenState();
}

class _InvoiceDebtFormScreenState extends State<InvoiceDebtFormScreen> {
  final TextEditingController _invoiceNameC = TextEditingController();
  final TextEditingController _totalDebtC = TextEditingController();
  final TextEditingController _dueDateC = TextEditingController();
  final TextEditingController _supplierName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _supplierForm = GlobalKey<FormState>();

  final InvoiceDebtFormBloc _bloc = InvoiceDebtFormBloc();

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _bloc.add(InvoiceDebtFormLoadSupplier());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('invoice_debt_screen.add_invoice_debt').tr(),
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
    return BlocConsumer<InvoiceDebtFormBloc, InvoiceDebtFormState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is InvoiceDebtFormInitial) {
          } else if (state is InvoiceDebtFormSuccessSupplier) {
            _supplierName.clear();
            _bloc.add(InvoiceDebtFormLoadSupplier());
          } else if (state is InvoiceDebtFormSuccessInvoice) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is InvoiceDebtFormLoading) {
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
                'invoice_debt_screen.upload_photo_invoice',
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
                controller: _invoiceNameC,
                label: tr('invoice_debt_screen.invoice_name'),
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: BlocBuilder<InvoiceDebtFormBloc,
                            InvoiceDebtFormState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          if (state is InvoiceDebtFormLoading) {
                            return LinearProgressIndicator();
                          }
                          final List<Supplier> listSupplier = state.props[1];
                          final int value = state.props[3];

                          if (listSupplier.isEmpty) {
                            return Text('messages.no_data').tr();
                          }

                          return DropdownButton<int>(
                              isExpanded: true,
                              hint: Text('invoice_debt_screen.choose_supplier')
                                  .tr(),
                              value: value,
                              items: listSupplier
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e.name.capitalize()),
                                        value: listSupplier.indexOf(e),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                _bloc.add(InvoiceDebtFormChooseSupplier(value));
                              });
                        }),
                  ),
                  FlatButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _dialogAddSupplier(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              BlocConsumer<InvoiceDebtFormBloc, InvoiceDebtFormState>(
                  bloc: _bloc,
                  listener: (context, state) {
                    final DateTime dt = state.props[4];
                    if (dt != null) {
                      _dueDateC.text = DateFormat.yMMMMEEEEd('id').format(dt);
                    }
                  },
                  builder: (context, state) {
                    return CustomTextField(
                      controller: _dueDateC,
                      label: tr('invoice_debt_screen.due_date'),
                      onTap: () {
                        _selectDate(context, state.props[4]);
                      },
                    );
                  }),
              SizedBox(height: 8.0),
              CustomTextField(
                controller: _totalDebtC,
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                label: tr('invoice_debt_screen.total_debt'),
              ),
              SizedBox(height: 16.0),
              RaisedButtonGradient(
                  width: double.infinity,
                  height: 43,
                  borderRadius: BorderRadius.circular(4),
                  child: Text(
                    'invoice_debt_screen.add_invoice_debt',
                    style: Theme.of(context).textTheme.button,
                  ).tr(),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      _submitInvoice();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      _bloc.add(InvoiceDebtFormChooseDate(picked));
    }
  }

  Widget buildImage(BuildContext context) {
    return BlocBuilder<InvoiceDebtFormBloc, InvoiceDebtFormState>(
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
              child: Text('invoice_debt_screen.choose_image_invoice').tr(),
              onPressed: () {
                _dialogChooseImage(context);
              },
            ),
          );
        });
  }

  _submitInvoice() {
    _bloc.add(InvoiceDebtFormAddInvoice(
        _invoiceNameC.text, int.parse(_totalDebtC.text)));
  }

  _submitSupplier() {
    _bloc.add(InvoiceDebtFormAddSupplier(_supplierName.text));
  }

  _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 70);

    _bloc.add(InvoiceDebtFormGetImage(pickedFile.path));
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

  _dialogAddSupplier(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Form(
              key: _supplierForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'invoice_debt_screen.add_supplier',
                    style: Theme.of(context).textTheme.subtitle1,
                  ).tr(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: _supplierName,
                      label: tr('invoice_debt_screen.supplier_name'),
                    ),
                  ),
                  RaisedButtonGradient(
                      width: double.infinity,
                      height: 43,
                      child: Text(
                        'invoice_debt_screen.add_supplier',
                        style: Theme.of(context).textTheme.button,
                      ).tr(),
                      onPressed: () {
                        if (_supplierForm.currentState.validate()) {
                          FocusScope.of(_supplierForm.currentContext).unfocus();
                          Navigator.of(context).pop();

                          _submitSupplier();
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}
