import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';

import 'widgets/simple_chart.dart';

class InvoiceDebtScreen extends StatefulWidget {
  InvoiceDebtScreen({Key key}) : super(key: key);

  @override
  _InvoiceDebtScreenState createState() => _InvoiceDebtScreenState();
}

class _InvoiceDebtScreenState extends State<InvoiceDebtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tagihan Hutang'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: (){
          Navigator.of(context).pushNamed(RouterHelper.kRouteInvoiceDebtForm);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 60,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SizedBox.expand(
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Tagihan Hutang',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text('Rp. 157.000.000',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 250,
              height: 250,
              child: SimpleChart.withSampleData(),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10 + 1,
                itemBuilder: (context, index) {
                  if(index == 10){
                    return SizedBox(height: 100,);
                  }
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl:
                              'https://omextemplates.content.office.net/support/templates/en-us/lt04068891.png',
                          height: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('09/10/2020'),
                              Text('Hutang Aksesoris Sepedah'),
                              Text('Rp.10.000.00$index'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
