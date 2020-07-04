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
  final String paymentMethod;
  final int totalPaid;
  final int totalChange;

  Transaction(this.code, this.customerName, this.subtotal, this.discount,
      this.total, this.createdAt, this.items,
      {this.docId, this.paymentMethod, this.totalChange, this.totalPaid});

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
        map['code'],
        map['customer_name'],
        map['sub_total'],
        map['discount'],
        map['total'],
        map['created_at'],
        List.from(map['items']).map((e) => Item.fromMap(e)).toList(),
        docId: map['document_id'],
      );

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'code': this.code,
        'customer_name': this.customerName,
        'sub_total': this.subtotal,
        'discount': this.discount,
        'total': this.total,
        'created_at': this.createdAt,
        'items': this.items.map((e) => e.toMap()).toList()
      };

  Transaction copyWith({
    String docId,
    String code,
    String customerName,
    int subtotal,
    int discount,
    int total,
    int createdAt,
    List<Item> items,
    String paymentMethod,
    int totalPaid,
    int totalChange,
  }) =>
      Transaction(
        code ?? this.code,
        customerName ?? this.customerName,
        subtotal ?? this.subtotal,
        discount ?? this.discount,
        total ?? this.total,
        createdAt ?? this.createdAt,
        items ?? this.items,
        docId: docId ?? this.docId,
        totalChange: totalChange ?? this.totalChange,
        totalPaid: totalPaid ?? this.totalPaid,
        paymentMethod: paymentMethod ?? this.paymentMethod,
      );
}
