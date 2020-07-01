
class Category {
  final String docId;
  final String name;
  final int createdAt;

  bool isSelected = false;

  Category(this.docId, this.name, {this.createdAt});

  factory Category.fromMap(Map<String, dynamic> map) =>
      Category(map['document_id'], map['name'], createdAt: map['created_at']);

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'name': this.name.toLowerCase(),
        'created_at': this.createdAt,
      };

  Category copy() => Category(this.docId, this.name, createdAt: this.createdAt);
}
