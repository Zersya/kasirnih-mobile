class Category {
  final String docId;
  final String name;
  int createdAt;

  Category(this.docId, this.name, {this.createdAt});

  factory Category.fromMap(Map<String, dynamic> map) =>
      Category(map['document_id'], map['name'], createdAt: map['created_at']);

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'name': this.name,
        'created_at': this.createdAt,
      };
}
