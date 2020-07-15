import 'package:flutter/material.dart';
import 'package:ks_bike_mobile/models/credential.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:ks_bike_mobile/widgets/custom_text_field.dart';
import 'package:ks_bike_mobile/widgets/raised_button_gradient.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import 'cubit/employee_credential_form_cubit.dart';

class EmployeeCredentialFormScreen extends StatefulWidget {
  EmployeeCredentialFormScreen({Key key}) : super(key: key);

  @override
  _EmployeeCredentialFormScreenState createState() =>
      _EmployeeCredentialFormScreenState();
}

class _EmployeeCredentialFormScreenState
    extends State<EmployeeCredentialFormScreen> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _usernameC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  final TextEditingController _passwordConfC = TextEditingController();

  final EmployeeCredentialFormCubit _credentialFormCubit =
      EmployeeCredentialFormCubit();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Akses Karyawan'),
      ),
      body: Stack(
        children: <Widget>[
          _body(context),
          _loading(context),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            CustomTextField(
              controller: _nameC,
              label: "Nama Karyawan",
            ),
            CustomTextField(
              controller: _usernameC,
              label: "Username",
            ),
            CubitProvider.value(
              value: _credentialFormCubit,
              child: CredentialPicker(),
            ),
            CustomTextField(
              controller: _passwordC,
              label: "Password",
            ),
            CustomTextField(
              controller: _passwordConfC,
              label: "Konfirmasi Password",
            ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButtonGradient(
                width: double.infinity,
                height: 43,
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  'Tambah Akses',
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  if (_passwordC.text != _passwordConfC.text) {
                    toastError('Password tidak sama');
                  } else if (_formKey.currentState.validate()) {
                    _credentialFormCubit.createUser(
                      _nameC.text,
                      _usernameC.text,
                      _passwordC.text,
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _loading(context) {
    return CubitConsumer<EmployeeCredentialFormCubit,
            EmployeeCredentialFormState>(
        cubit: _credentialFormCubit,
        listener: (context, state) {
          if (state is EmployeeCredentialFormSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is EmployeeCredentialFormLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }
}

class CredentialPicker extends StatelessWidget {
  const CredentialPicker({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CubitBuilder<EmployeeCredentialFormCubit,
        EmployeeCredentialFormState>(
      builder: (context, state) {
        final List<Credential> credentials = state.props[1];
        final List<Credential> selectedCreds =
            credentials.where((element) => element.isSelected).toList();
        return SizedBox(
          width: double.infinity,
          child: Card(
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () {
                final cubit =
                    CubitProvider.of<EmployeeCredentialFormCubit>(context);
                builderChooseCredentials(context, credentials, cubit);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  credentials.isEmpty
                      ? 'Pilih akses karyawan'
                      : '${selectedCreds.length} hak akses terpilih',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future builderChooseCredentials(BuildContext context,
      List<Credential> credentials, EmployeeCredentialFormCubit cubit) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Pilih hak akses',
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
                  CubitBuilder<EmployeeCredentialFormCubit,
                      EmployeeCredentialFormState>(
                    cubit: cubit,
                    builder: (context, state) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: credentials.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(credentials[index].nameId),
                              value: credentials[index].isSelected,
                              onChanged: (value) {
                                cubit.selectCredentials(value, index);
                              },
                            );
                          });
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
