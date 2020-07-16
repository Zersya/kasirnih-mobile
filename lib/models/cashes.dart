class Cashes {
  final String docId;
  final String name;
  final int type;
  final int total;
  final int createdAt;

  Cashes(this.docId, this.name, this.type, this.total, this.createdAt);

  factory Cashes.fromMap(Map<String, dynamic> map) => Cashes(map['document_id'],
      map['name'], map['type'], map['total'], map['created_at']);

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'name': this.name.toLowerCase(),
        'type': this.type,
        'total': this.total,
        'created_at': this.createdAt,
      };

  Cashes copy() =>
      Cashes(this.docId, this.name, this.type, this.total, this.createdAt);

  String cashesType() => this.type == 1 ? 'Pemasukan' : 'Pengeluaran';
}
