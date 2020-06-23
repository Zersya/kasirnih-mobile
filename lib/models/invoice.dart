import 'package:ks_bike_mobile/models/supplier.dart';

class Invoice {
  final String docId;
  final String invoiceName;
  final String urlImage;
  final int dueDate;
  final int totalDebt;
  int createdAt;
  String refSupplier;

  Invoice(
      this.docId, this.invoiceName, this.urlImage, this.dueDate, this.totalDebt,
      {this.createdAt, this.refSupplier});

  factory Invoice.fromMap(Map<String, dynamic> map) => Invoice(
        map['document_id'],
        map['invoice_name'],
        map['url_image'],
        map['due_date'],
        map['total_debt'],
        createdAt: map['created_at'],
      );

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'invoice_name': this.invoiceName,
        'url_image': this.urlImage,
        'due_date': this.dueDate,
        'total_debt': this.totalDebt,
        'created_at': this.createdAt,
        'refSupplier': this.refSupplier,
      };
}
