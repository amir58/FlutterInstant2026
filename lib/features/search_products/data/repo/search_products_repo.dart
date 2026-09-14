import 'package:dio/dio.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/products/data/models/product_model.dart';
import 'package:navigations/features/search_products/data/data_sources/search_products_remote_data_source.dart';

class SearchProductsRepo {
  SearchProductsRemoteDataSource _remote;

  SearchProductsRepo(this._remote);

  Future<ApiResult<ProductModel>> search(
    String query, {
    CancelToken? cancelToken,
  }) {
    return _remote.search(query, cancelToken: cancelToken);
  }
}
