class UpdateCartModel {
  final int id;
  final List<UpdateCartProductModel> products;
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;

  UpdateCartModel({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  factory UpdateCartModel.fromJson(Map<String, dynamic> json) => UpdateCartModel(
    id: (json['id'] as num? ?? 0).toInt(),
    products: (json['products'] as List<dynamic>? ?? [])
        .map((e) => UpdateCartProductModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    total: (json['total'] as num? ?? 0).toDouble(),
    discountedTotal: (json['discountedTotal'] as num? ?? 0).toDouble(),
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

class UpdateCartProductModel {
  final int id;
  final String title;
  final double price;
  final int quantity;
  final double total;
  final double discountPercentage;
  final double discountedPrice;
  final String thumbnail;

  UpdateCartProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discountPercentage,
    required this.discountedPrice,
    required this.thumbnail,
  });

  factory UpdateCartProductModel.fromJson(Map<String, dynamic> json) =>
      UpdateCartProductModel(
        id: (json['id'] as num? ?? 0).toInt(),
        title: json['title'] as String? ?? '',
        price: (json['price'] as num? ?? 0).toDouble(),
        quantity: (json['quantity'] as num? ?? 0).toInt(),
        total: (json['total'] as num? ?? 0).toDouble(),
        discountPercentage: (json['discountPercentage'] as num? ?? 0)
            .toDouble(),
        discountedPrice: (json['discountedPrice'] as num? ?? 0).toDouble(),
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
    data['discountedPrice'] = discountedPrice;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
