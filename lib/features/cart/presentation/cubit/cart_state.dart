part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitialState extends CartState {}

final class CartLoadingState extends CartState {}

final class CartLoadedState extends CartState {
  final CartModel cart;

  CartLoadedState(this.cart);
}

final class CartFailureState extends CartState {
  final String error;

  CartFailureState(this.error);
}

final class DeleteCartLoadingState extends CartState {}

final class DeleteCartSuccessState extends CartState {}

final class DeleteCartFailureState extends CartState {
  final String error;

  DeleteCartFailureState(this.error);
}

final class UpdateCartLoadingState extends CartState {}

final class UpdateCartSuccessState extends CartState {
  final int productId;

  UpdateCartSuccessState({required this.productId});
}

final class UpdateCartFailureState extends CartState {
  final String error;

  UpdateCartFailureState(this.error);
}
