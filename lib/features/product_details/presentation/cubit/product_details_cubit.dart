import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/exceptions/failure.dart';
import 'package:navigations/features/product_details/data/models/products_details_model.dart';
import 'package:navigations/features/product_details/data/repositories/product_details_repo.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._repo)
    : super(ProductDetailsInitialState());

  final ProductDetailsRepo _repo;

  Future<void> getProductDetails({required int productId}) async {
    emit(ProductDetailsLoadingState());

    final apiResult = await _repo.getProductDetails(
      productId: productId,
    );

    switch (apiResult) {
      case ApiSuccess<ProductDetailsModel>(:final data):
        emit(ProductDetailsSuccessState(data: data));

      case ApiFailure<ProductDetailsModel>(:final failure):
        emit(
          failure is NotFoundFailure
              ? ProductDetailsNotFoundState()
              : ProductDetailsFailureState(message: failure.message),
        );

        // if (failure is NotFoundFailure) {
        //   emit(ProductDetailsNotFoundState());
        // } else {
        //   emit(ProductDetailsFailureState(message: failure.message));
        // }
    }
  }
}
