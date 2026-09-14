import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/products/data/models/product_model.dart';
import 'package:navigations/features/products/data/repo/products_repo.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.repo) : super(ProductsInitialState());

  final ProductsRepo repo;
  static const int _pageSize = 20;
  int _skip = 0;
  bool _isFetching = false;

  Future<void> loadFirstPage() async {
    _skip = 0;
    emit(const ProductsLoadingState());
    final result = await repo.getProducts(limit: _pageSize, skip: 0);

    switch (result) {
      case ApiSuccess(:final data):
        _skip = data.products.length;
        emit(
          data.products.isEmpty
              ? const ProductsEmptyState()
              : ProductsSuccessState(
                  products: data.products,
                  hasMore: data.hasMore,
                ),
        );
      case ApiFailure(:final failure):
        emit(ProductsFailureState(failure.message));
    }
  }

  Future<void> loadNextPage() async {
    final current = state;
    // الشروط التلاتة دي بتمنع الطلبات المكررة
    if (current is! ProductsSuccessState) return;
    if (!current.hasMore || _isFetching) return;

    _isFetching = true;

    emit(
      current.copyWith(isLoadingMore: true),
    ); // مؤشر تحميل تحت القايمة

    // await Future.delayed(Duration(seconds: 1));
    final result = await repo.getProducts(
      limit: _pageSize,
      skip: _skip,
    );

    _isFetching = false;

    switch (result) {
      case ApiSuccess(:final data):
        debugPrint('Skip before: $_skip');
        debugPrint('Product length: ${data.products.length}');

        _skip += data.products.length;
        debugPrint('Skip after: $_skip');

        emit(
          current.copyWith(
            products: [
              ...current.products,
              ...data.products,
            ], // ← الإضافة
            hasMore: data.hasMore,
            isLoadingMore: false,
          ),
        );

      case ApiFailure(:final failure):
        debugPrint('ApiFailure ${failure.message}');
        // فشل صفحة إضافية ⇒ متمسحش اللي معروض، بس شيل المؤشر
        emit(current.copyWith(isLoadingMore: false));
    }
  }

  // Future<void> loadProducts() async {
  //   emit(const ProductsLoadingState());
  //   final result = await repo.getProducts(limit: _pageSize, skip: 0);
  //   switch (result) {
  //     case ApiSuccess(:final data):
  //       if (data.products.isEmpty) {
  //         emit(const ProductsEmptyState());
  //       } else {
  //         emit(
  //           ProductsSuccessState(
  //             products: data.products,
  //             hasMore: data.hasMore,
  //           ),
  //         );
  //       }
  //     case ApiFailure(:final failure):
  //       emit(ProductsFailureState(failure.message));
  //   }
  // }
}
