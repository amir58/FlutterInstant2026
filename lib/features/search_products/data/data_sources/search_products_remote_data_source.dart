import 'package:dio/dio.dart';
import 'package:navigations/core/api/endpoints.dart';
import 'package:navigations/core/api/safe_api_call.dart';
import 'package:navigations/features/products/data/models/product_model.dart';

import '../../../../core/api/api_result.dart';

// RemoteDataSource => APIs | Firebase | Supabase
// APIs => http | Dio | Retrofit | GetX
class SearchProductsRemoteDataSource {
  final Dio _dio;
  const SearchProductsRemoteDataSource(this._dio);

  Future<ApiResult<ProductModel>> search(
    String query, {
    CancelToken? cancelToken,
  }) {
    return safeApiCall(() async {
      final response = await _dio.get(
        EndPoints.productsSearch,
        queryParameters: {'q': query, 'limit': 20},
        cancelToken: cancelToken,
      );

      final model = ProductModel.fromJson(response.data);

      return model;
    });
  }
}
