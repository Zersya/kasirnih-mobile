import 'package:flutter/material.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Pengaturan Profil'),
              centerTitle: true,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Ubah Profil'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Ubah Toko'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RouterHelper.kRouteStoreFormState);
              },
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('Tambah Sarana Baru'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RouterHelper.kRouteNewItemFacilities);
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Tagihan Hutang'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context).pushNamed(RouterHelper.kRouteInvoiceDebt);
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Metode Pembayaran'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RouterHelper.kRoutePaymentMethod);
              },
            ),
          ],
        ),
      ),
    );
  }
}
