import 'package:navigations/features/ahwety/domain/entities/drink.dart';

sealed class MenuState {
  const MenuState();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final List<Drink> drinks; // المنيو كله
  final List<Drink> visible; // اللي ظاهر بعد فلتر القسم
  final DrinkCategory? category; // null = الكل
  final Set<int> favoriteIds;

  const MenuLoaded({
    required this.drinks,
    required this.visible,
    this.category,
    this.favoriteIds = const {},
  });
}

class MenuError extends MenuState {
  final String message;
  const MenuError(this.message);
}