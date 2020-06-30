class NewItemFacilities {
  final String docId;
  final String name;
  final int createdAt;
  bool isBought;

  NewItemFacilities(this.docId, this.name, this.createdAt, this.isBought);

  factory NewItemFacilities.fromMap(Map<String, dynamic> map) {
    return NewItemFacilities(map['document_id'], map['name'], map['created_at'], map['is_bought']);
  }

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'name': this.name.toLowerCase(),
        'created_at':this.createdAt,
        'is_bought': this.isBought
      };
}
