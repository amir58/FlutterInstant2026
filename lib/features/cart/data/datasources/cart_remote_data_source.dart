import 'package:dio/dio.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/endpoints.dart';
import 'package:navigations/core/api/safe_api_call.dart';
import 'package:navigations/features/cart/data/models/cart_model.dart';
import 'package:navigations/features/cart/data/models/update_cart_model.dart';

class CartRemoteDataSource {
  final Dio _dio;

  CartRemoteDataSource(this._dio);

  Future<ApiResult<CartModel>> getCart() {
    return safeApiCall(() async {
      final response = await _dio.get('${EndPoints.cart}/1');

      final model = CartModel.fromJson(response.data);

      return model;
    });
  }

  Future<ApiResult<UpdateCartModel>> addToCart({
    required int productId,
    required int quantity,
  }) {
    return safeApiCall(() async {
      final response = await _dio.post(
        EndPoints.addToCart,
        data: {
          "userId": 1,
          "products": [
            {"id": productId, "quantity": quantity},
          ],
        },
      );

      final model = UpdateCartModel.fromJson(response.data);

      return model;
    });
  }

  Future<ApiResult<UpdateCartModel>> updateCart({
    required int productId,
    required int quantity,
  }) {
    return safeApiCall(() async {
      final response = await _dio.patch(
        '${EndPoints.cart}/1',
        data: {
          // this will include existing products in the cart
          "merge": true,
          "products": [
            {"id": productId, "quantity": quantity},
          ],
        },
      );

      final model = UpdateCartModel.fromJson(response.data);

      return model;
    });
  }

  Future<ApiResult<UpdateCartModel>> deleteCart() {
    return safeApiCall(() async {
      final response = await _dio.delete('${EndPoints.cart}/1');

      final model = UpdateCartModel.fromJson(response.data);

      return model;
    });
  }
}
