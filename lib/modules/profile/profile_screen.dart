import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/modules/home/cubit/credentials_access_cubit.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _accessCubit = BlocProvider.of<CredentialsAccessCubit>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Pengaturan Profil'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Ubah Profil'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            if (_accessCubit.state.props[3] && _accessCubit.state.props[6])
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Ubah Toko'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouterHelper.kRouteStoreFormState);
                },
              ),
            if (_accessCubit.state.props[3] && _accessCubit.state.props[6])
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Tambah Karyawan'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context).pushNamed(RouterHelper.kRouteEmployees);
                },
              ),
            if ((_accessCubit.state.props[3] || _accessCubit.state.props[0]) &&
                _accessCubit.state.props[6])
              ListTile(
                leading: Icon(Icons.mail),
                title: Text('Tambah Sarana Baru'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouterHelper.kRouteNewItemFacilities);
                },
              ),
            if ((_accessCubit.state.props[3] || _accessCubit.state.props[1]) &&
                _accessCubit.state.props[6])
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Tagihan Hutang'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouterHelper.kRouteInvoiceDebt);
                },
              ),
            if (_accessCubit.state.props[3] && _accessCubit.state.props[6])
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Metode Pembayaran'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouterHelper.kRoutePaymentMethod);
                },
              ),
            if (_accessCubit.state.props[6])
              ListTile(
                leading: Icon(Icons.assignment_turned_in),
                title: Text('Laporan Kas'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouterHelper.kRouteCashesList);
                },
              ),
            // ListTile(
            //   leading: Icon(Icons.print),
            //   title: Text('Test Print'),
            //   trailing: Icon(Icons.keyboard_arrow_right),
            //   onTap: () async {
            //     await Navigator.of(context).push(
            //         MaterialPageRoute(builder: (context) => PrintScreen()));
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () async {
                final storage = FlutterSecureStorage();
                await storage.deleteAll();
                await Navigator.of(context)
                    .pushReplacementNamed(RouterHelper.kRouteAuth);
              },
            ),
          ],
        ),
      ),
    );
  }
}
