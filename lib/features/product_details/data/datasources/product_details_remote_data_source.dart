import 'package:dio/dio.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/endpoints.dart';
import 'package:navigations/core/api/safe_api_call.dart';
import 'package:navigations/features/product_details/data/models/products_details_model.dart';

class ProductDetailsRemoteDataSource {
  final Dio _dio;

  ProductDetailsRemoteDataSource(this._dio);

  Future<ApiResult<ProductDetailsModel>> getProductDetails({
    required int productId,
  }) {
    return safeApiCall(() async {
      final response = await _dio.get(
        EndPoints.productDetails(productId),
        // '${EndPoints.products}/$productId'
      );

      final model = ProductDetailsModel.fromJson(response.data);

      return model;
    });
  }
}
