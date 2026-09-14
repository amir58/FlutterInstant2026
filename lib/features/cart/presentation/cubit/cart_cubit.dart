import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/cart/data/models/cart_model.dart';
import 'package:navigations/features/cart/data/models/cart_model_adapter.dart';
import 'package:navigations/features/cart/data/models/update_cart_model.dart';
import 'package:navigations/features/cart/data/repositories/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repo) : super(CartInitialState());

  final CartRepo _repo;
  
  Timer? _updateCartDebounce;

  Future<void> getCart() async {
    emit(CartLoadingState());

    await Future.delayed(Duration(seconds: 3));
    final apiResult = await _repo.getCart();

    switch (apiResult) {
      case ApiSuccess<CartModel>(:final data):
        emit(CartLoadedState(data));

      case ApiFailure<CartModel>(:final failure):
        emit(CartFailureState(failure.message));
    }
  }

  Future<void> deleteCart() async {
    emit(DeleteCartLoadingState());

    final apiResult = await _repo.deleteCart();

    switch (apiResult) {
      case ApiSuccess<UpdateCartModel>():
        emit(DeleteCartSuccessState());

      case ApiFailure<UpdateCartModel>(:final failure):
        emit(DeleteCartFailureState(failure.message));
    }
  }

  Future<void> updateQuntity({
    required int productId,
    required int quantity,
  }) async {
    _updateCartDebounce?.cancel();

    _updateCartDebounce = Timer(
      const Duration(milliseconds: 450),
      () async {
        emit(UpdateCartLoadingState());

        final apirResult = await _repo.updateCart(
          productId: productId,
          quantity: quantity,
        );

        switch (apirResult) {
          case ApiSuccess<UpdateCartModel>(:final data):
            // emit(UpdateCartSuccessState(productId: productId));

            // Adapter
            final cartModel = cartModelAdapter(data);

            // final cartModel = CartModel.fromJson(data.toJson());

            emit(CartLoadedState(cartModel));

          case ApiFailure<UpdateCartModel>(:final failure):
            emit(UpdateCartFailureState(failure.message));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _updateCartDebounce?.cancel();
    return super.close();
  }
}
