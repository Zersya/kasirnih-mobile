class Item {
  final String docId;
  final String itemName;
  final String urlImage;
  final int totalStock;
  final int buyPrice;
  final int sellPrice;
  final String categoryName;
  final int createdAt;
  final String refCategory;
  final String supplierName;
  final String refSupplier;

  int qty = 0;

  Item(
    this.docId,
    this.itemName,
    this.urlImage,
    this.totalStock,
    this.buyPrice,
    this.sellPrice,
    this.createdAt,
    this.refCategory,
    this.categoryName,
    this.refSupplier,
    this.supplierName,
  );

  factory Item.fromMap(Map<String, dynamic> map) => Item(
      map['document_id'],
      map['item_name'],
      map['url_image'],
      map['total_stock'],
      map['buy_price'],
      map['sell_price'],
      map['created_at'],
      map['ref_category'],
      map['category_name'],
      map['ref_supplier'],
      map['supplier_name']);

  Map<String, dynamic> toMap() => {
        'document_id': this.docId,
        'item_name': this.itemName.toLowerCase(),
        'url_image': this.urlImage,
        'total_stock': this.totalStock,
        'buy_price': this.buyPrice,
        'sell_price': this.sellPrice,
        'created_at': this.createdAt,
        'ref_category': this.refCategory,
        'category_name': this.categoryName.toLowerCase(),
        'ref_supplier': this.refSupplier,
        'supplier_name': this.supplierName.toLowerCase()
      };
}
