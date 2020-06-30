
class Invoice {
  final String docId;
  final String invoiceName;
  final String urlImage;
  final int dueDate;
  final int totalDebt;
  final String supplierName;
  final bool isPaid;
  int createdAt;
  String refSupplier;

  Invoice(
      this.docId, this.invoiceName, this.urlImage, this.dueDate, this.totalDebt, this.supplierName, this.isPaid,
      {this.createdAt, this.refSupplier});

  factory Invoice.fromMap(Map<String, dynamic> map) => Invoice(
        map['document_id'],
        map['invoice_name'],
        map['url_image'],
        map['due_date'],
        map['total_debt'],
        map['supplier_name'],
        map['is_paid'],
        createdAt: map['created_at'],
        refSupplier: map['ref_supplier'],
      );

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'invoice_name': this.invoiceName.toLowerCase(),
        'url_image': this.urlImage,
        'due_date': this.dueDate,
        'total_debt': this.totalDebt,
        'created_at': this.createdAt,
        'is_paid': this.isPaid,
        'supplier_name': this.supplierName.toLowerCase(),
        'ref_supplier': this.refSupplier,
      };
}
