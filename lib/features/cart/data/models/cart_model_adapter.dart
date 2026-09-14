import 'package:navigations/features/cart/data/models/cart_model.dart';
import 'package:navigations/features/cart/data/models/update_cart_model.dart';

CartModel cartModelAdapter(UpdateCartModel data) {
  return CartModel(
    id: data.id,
    products: data.products
        .map(
          (product) => CartProductModel(
            id: product.id,
            title: product.title,
            price: product.price,
            quantity: product.quantity,
            total: product.total,
            discountPercentage: product.discountPercentage,
            discountedTotal: product
                .discountedPrice, // discountedTotal = discountedPrice
            thumbnail: product.thumbnail,
          ),
        )
        .toList(),
    total: data.total,
    discountedTotal: data.discountedTotal,
    userId: data.userId,
    totalProducts: data.totalProducts,
    totalQuantity: data.totalQuantity,
  );
}
