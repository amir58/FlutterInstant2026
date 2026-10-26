
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/ahwety/domain/entities/drink.dart';
import 'package:navigations/features/ahwety/domain/usecases/get_menu_use_case.dart';
import 'package:navigations/features/ahwety/presentation/bloc/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit(this._getMenu) : super(const MenuLoading());

  final GetMenuUseCase _getMenu;

  Future<void> load() async {
    emit(const MenuLoading());
    final result = await _getMenu();
    if (isClosed) return;
    switch (result) {
      case ApiSuccess(:final data):
        emit(MenuLoaded(drinks: data, visible: data));
      case ApiFailure(:final failure):
        emit(MenuError(failure.message));
    }
  }

  void selectCategory(DrinkCategory? category) {
    final current = state;
    if (current is! MenuLoaded || current.category == category) return;
    emit(MenuLoaded(
      drinks: current.drinks,
      visible: category == null
          ? current.drinks
          : current.drinks.where((drink) => drink.category == category).toList(growable: false),
      category: category,
      favoriteIds: current.favoriteIds,
    ));
  }

  void toggleFavorite(int drinkId) {
    final current = state;
    if (current is! MenuLoaded) return;
    final favorites = {...current.favoriteIds};
    if (!favorites.remove(drinkId)) favorites.add(drinkId);
    emit(MenuLoaded(
      drinks: current.drinks,
      visible: current.visible, // نفس الـ List بالظبط — الـ grid مش هيعيد الدخول
      category: current.category,
      favoriteIds: Set.unmodifiable(favorites),
    ));
  }
}