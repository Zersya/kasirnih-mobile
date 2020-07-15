class Credential {
  final String docId;
  final String code;
  final String description;
  final String nameEn;
  final String nameId;
  
  bool isSelected = false;
  
  Credential(this.docId, this.code, this.description, this.nameEn, this.nameId);

  factory Credential.fromMap(Map<String, dynamic> map) => Credential(
        map['document_id'],
        map['code'],
        map['description'],
        map['name_en'],
        map['name_id'],
      );

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'code': this.code,
        'description': this.description,
        'name_id': this.nameId,
        'name_en': this.nameEn,
      };
}
