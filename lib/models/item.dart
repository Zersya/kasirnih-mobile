class Item {
  final String docId;
  final String itemName;
  final String urlImage;
  final int totalStock;
  final int buyPrice;
  final int sellPrice;

  final int createdAt;
  final String refCategory;

  Item(this.docId, this.itemName, this.urlImage, this.totalStock, this.buyPrice,
      this.sellPrice, this.createdAt, this.refCategory);

  factory Item.fromMap(Map<String, dynamic> map) => Item(
        map['document_id'],
        map['item_name'],
        map['url_image'],
        map['total_stock'],
        map['buy_price'],
        map['sell_price'],
        map['created_at'],
        map['ref_supplier'],
      );

      Map<String, dynamic> toMap()=> {
        'document_id' : this.docId,
        'item_name' : this.itemName,
        'url_image' : this.urlImage,
        'total_stock' : this.totalStock,
        'buy_price' : this.buyPrice,
        'sell_price' : this.sellPrice,
        'created_at' : this.createdAt,
        'ref_category' : this.refCategory
      };
}
