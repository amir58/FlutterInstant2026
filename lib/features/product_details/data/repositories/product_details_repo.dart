import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/product_details/data/datasources/product_details_remote_data_source.dart';
import 'package:navigations/features/product_details/data/models/products_details_model.dart';

class ProductDetailsRepo {
  final ProductDetailsRemoteDataSource _remoteDataSource;

  ProductDetailsRepo(this._remoteDataSource);

  Future<ApiResult<ProductDetailsModel>> getProductDetails({
    required int productId,
  }) async {
    return await _remoteDataSource.getProductDetails(
      productId: productId,
    );
  }
}
