import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/products/data/data_sources/products_remote_data_source.dart';
import 'package:navigations/features/products/data/models/product_model.dart';

class ProductsRepo {
  ProductsRemoteDataSource remote;

  ProductsRepo(this.remote);

  Future<ApiResult<ProductModel>> getProducts({
    required int limit,
    required int skip,
  }) {
    return remote.getProducts(limit: limit, skip: skip);
  }
}
