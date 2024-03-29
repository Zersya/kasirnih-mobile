class PaymentMethod {
  final String docId;
  final String name;
  final int createdAt;

  bool isSelected = false;

  PaymentMethod(this.docId, this.name, this.createdAt);

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(map['document_id'], map['name'], map['created_at']);
  }

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'name': this.name.toLowerCase(),
        'created_at': this.createdAt,
      };
}
