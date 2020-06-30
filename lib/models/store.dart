class Store {
  final String storeName;
  final String storePhone;
  final String storeAddress;
  final String storeOwnerName;
  final String storeOwnerPhone;

  Store(this.storeName, this.storePhone, this.storeAddress, this.storeOwnerName,
      this.storeOwnerPhone);

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(map['store_name'], map['store_phone'], map['store_address'],
        map['store_owner_name'], map['store_owner_phone']);
  }

  Map<String, dynamic> toMap() => {
        'store_name': this.storeName.toLowerCase(),
        'store_phone': this.storePhone,
        'store_address': this.storeAddress.toLowerCase(),
        'store_owner_name': this.storeOwnerName.toLowerCase(),
        'store_owner_phone': this.storeOwnerPhone,
      };
}
