import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SimpleChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleChart(this.seriesList, {this.animate});

  factory SimpleChart.withSampleData() {
    return SimpleChart(
      _createSampleData(),
      animate: !kDebugMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
          charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.auto)
        ]));
  }

  /// Create series list with one series
  static List<charts.Series<InvoiceDebtChart, String>> _createSampleData() {
    final data = [
      InvoiceDebtChart('Xtreme Bike', 2000100),
      InvoiceDebtChart('Planet Bike Cirebon', 1200175),
      InvoiceDebtChart('Terlaksana Bike', 1201125),
      InvoiceDebtChart('Cinta Bike', 20000),
    ];

    return [
      charts.Series<InvoiceDebtChart, String>(
        id: 'Sales',
        domainFn: (InvoiceDebtChart sales, _) => sales.name,
        measureFn: (InvoiceDebtChart sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class InvoiceDebtChart {
  final String name;
  final int sales;

  InvoiceDebtChart(this.name, this.sales);
}
