import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/features/ahwety/domain/entities/cart.dart';
import 'package:navigations/features/ahwety/domain/entities/drink.dart';

class MenuCartCubit extends Cubit<Cart> {
  MenuCartCubit() : super(const Cart());

  // الحساب كله جوّه Cart (الدومين) — الـ Cubit بيوصّل بس
  void add(Drink drink, DrinkSize size) =>
      emit(state.add(drink, size));
}
