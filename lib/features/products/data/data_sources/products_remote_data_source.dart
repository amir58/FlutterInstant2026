import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:navigations/core/api/endpoints.dart';
import 'package:navigations/core/api/exceptions/failure_handler.dart';
import 'package:navigations/features/products/data/models/product_model.dart';

import '../../../../core/api/api_result.dart';

// RemoteDataSource => APIs | Firebase | Supabase
// APIs => http | Dio | Retrofit | GetX
class ProductsRemoteDataSource {
  final Dio _dio;
  const ProductsRemoteDataSource(this._dio);

  Future<ApiResult<ProductModel>> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.products,
        queryParameters: {'limit': limit, 'skip': skip},
      );

      final data = ProductModel.fromJson(response.data);

      return ApiSuccess(data);
    } catch (error) {
      debugPrint(error.toString());

      return ApiFailure(ApiFailureHandler.handle(error));
    }
  }
}
