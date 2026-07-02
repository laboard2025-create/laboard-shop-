class OrderItem {
  final String productId;
  final String title;
  final num price;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
        productId: map['productId'] as String? ?? '',
        title: map['title'] as String? ?? '',
        price: map['price'] as num? ?? 0,
        quantity: map['quantity'] as int? ?? 1,
      );

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'title': title,
        'price': price,
        'quantity': quantity,
      };
}
