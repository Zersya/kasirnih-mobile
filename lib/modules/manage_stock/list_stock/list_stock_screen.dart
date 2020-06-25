import 'package:flutter/material.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';

class ListStockScreen extends StatefulWidget {
  ListStockScreen({Key key}) : super(key: key);

  @override
  _ListStockScreenState createState() => _ListStockScreenState();
}

class _ListStockScreenState extends State<ListStockScreen> {
  final TextEditingController _fieldSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Stok Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 5,
                  child: TextField(
                    controller: _fieldSearch,
                    decoration: InputDecoration(
                      hintText: 'Cari Barang',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.close),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouterHelper.kRouteStockForm);
                    },
                  ),
                )
              ],
            ),
            Container(
              child: Text('Stok'),
            ),
          ],
        ),
      ),
    );
  }
}
