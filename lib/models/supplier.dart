class Supplier {
  final String docId;
  final String name;
  int createdAt;

  Supplier(this.docId, this.name, {this.createdAt});

  factory Supplier.fromMap(Map<String, dynamic> map) =>
      Supplier(map['document_id'], map['name'], createdAt: map['created_at']);

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'name': this.name.toLowerCase(),
        'created_at': this.createdAt,
      };
}
