import 'dart:convert';

import 'item.dart';

class Transaction {
  final String docId;
  final String code;
  final String customerName;
  final int subtotal;
  final int discount;
  final int total;
  final int createdAt;
  final List<Item> items;

  Transaction(this.docId, this.code, this.customerName, this.subtotal,
      this.discount, this.total, this.createdAt, this.items);

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
        map['document_id'],
        map['code'],
        map['customer_name'],
        map['sub_total'],
        map['discount'],
        map['total'],
        map['created_at'],
        List.from(map['items'])
            .map((e) => Item.fromMap(jsonDecode(e)))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'code': this.code,
        'customer_name': this.customerName,
        'sub_total': this.subtotal,
        'discount': this.discount,
        'total': this.total,
        'created_at': this.createdAt,
        'items': this.items.map((e) => jsonEncode(e.toMap())).toList()
      };
}
