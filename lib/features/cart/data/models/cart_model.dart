class CartModel {
  final int id;
  final List<CartProductModel> products;
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;

  CartModel({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    id: (json['id'] as num? ?? 0).toInt(),
    products: (json['products'] as List<dynamic>? ?? [])
        .map(
          (e) => CartProductModel.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    total: (json['total'] as num? ?? 0).toDouble(),
    discountedTotal: (json['discountedTotal'] as num? ?? 0)
        .toDouble(),
    userId: (json['userId'] as num? ?? 0).toInt(),
    totalProducts: (json['totalProducts'] as num? ?? 0).toInt(),
    totalQuantity: (json['totalQuantity'] as num? ?? 0).toInt(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['products'] = products.map((e) => e.toJson()).toList();
    data['total'] = total;
    data['discountedTotal'] = discountedTotal;
    data['userId'] = userId;
    data['totalProducts'] = totalProducts;
    data['totalQuantity'] = totalQuantity;
    return data;
  }
}

class CartProductModel {
  final int id;
  final String title;
  final double price;
  int quantity;
  final double total;
  final double discountPercentage;
  final double discountedTotal;
  final String thumbnail;
  final int maxQuantityPerOrder = 5;

  CartProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discountPercentage,
    required this.discountedTotal,
    required this.thumbnail,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) =>
      CartProductModel(
        id: (json['id'] as num? ?? 0).toInt(),
        title: json['title'] as String? ?? '',
        price: (json['price'] as num? ?? 0).toDouble(),
        quantity: (json['quantity'] as num? ?? 0).toInt(),
        total: (json['total'] as num? ?? 0).toDouble(),
        discountPercentage: (json['discountPercentage'] as num? ?? 0)
            .toDouble(),
        discountedTotal: (json['discountedTotal'] as num? ?? 0)
            .toDouble(),
        thumbnail: json['thumbnail'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['quantity'] = quantity;
    data['total'] = total;
    data['discountPercentage'] = discountPercentage;
    data['discountedTotal'] = discountedTotal;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
