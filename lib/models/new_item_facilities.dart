class NewItemFacilities {
  final String docId;
  final String name;
  bool isBought;

  NewItemFacilities(this.docId, this.name, this.isBought);

  factory NewItemFacilities.fromMap(Map<String, dynamic> map) {
    return NewItemFacilities(map['document_id'], map['name'], map['is_bought']);
  }

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'name': this.name,
        'is_bought': this.isBought
      };
}
