import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:navigations/features/cart/data/models/cart_model.dart';
import 'package:navigations/features/cart/data/models/update_cart_model.dart';

class CartRepo {
  final CartRemoteDataSource _remote;

  CartRepo(this._remote);

  Future<ApiResult<CartModel>> getCart() {
    return _remote.getCart();
  }

  Future<ApiResult<UpdateCartModel>> addToCart({
    required int productId,
    required int quantity,
  }) {
    return _remote.addToCart(productId: productId, quantity: quantity);
  }

  Future<ApiResult<UpdateCartModel>> updateCart({
    required int productId,
    required int quantity,
  }) {
    return _remote.updateCart(productId: productId, quantity: quantity);
  }

  Future<ApiResult<UpdateCartModel>> deleteCart() {
    return _remote.deleteCart();
  }
}
