class Product {
  Product({required this.productId, required this.price, required this.name});

  Product.fromFirestore(Map<String, dynamic> firestore)
      : productId = firestore['productId'] as String,
        name = firestore['name'] as String,
        price = firestore['price'] as double;
  final String productId;
  final String name;
  final double price;

  Map<String, dynamic> toMap() =>
      {'productId': productId, 'name': name, 'price': price};
}
