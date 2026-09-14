import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/exceptions/failure.dart';
import 'package:navigations/features/products/data/models/product_model.dart';
import 'package:navigations/features/search_products/data/repo/search_products_repo.dart';

part 'search_products_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  SearchProductsCubit(this._repo)
    : super(SearchProductsInitialState());

  final SearchProductsRepo _repo;

  Timer? _debounce;
  CancelToken? _cancelToken;

  void onQueryChanged(String query) {
    _debounce?.cancel();

    if (query.trim().length < 2) {
      _cancelToken?.cancel();
      emit(const SearchProductsInitialState());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 450), () {
      _runSearch(query.trim());
    });
  }

  Future<void> _runSearch(String query) async {
    // ألغِ أي بحث لسه شغّال — نتيجته بقت قديمة
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    emit(const SearchProductsLoadingState());
    
    final result = await _repo.search(
      query,
      cancelToken: _cancelToken,
    );

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          data.products.isEmpty
              ? SearchProductsEmptyState()
              : SearchProductsSuccessState(
                  products: data.products,
                  hasMore: false,
                ),
        );
      case ApiFailure(:final failure):
        if (failure is CancelledFailure) {
          return; // إلغاء متعمّد — متعملش حاجة
        }
        emit(SearchProductsFailureState(failure.message));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel(); // ⚠️ لازم
    _cancelToken?.cancel();
    return super.close();
  }
}
