import 'package:navigations/features/ahwety/domain/entities/drink.dart';

class CartItem {
  final Drink drink;
  final DrinkSize size;
  final int quantity;

  const CartItem({
    required this.drink,
    required this.size,
    required this.quantity,
  });

  int get total => drink.priceFor(size) * quantity;

  bool isSameLine(Drink other, DrinkSize otherSize) =>
      drink.id == other.id && size == otherSize;
}

/// السلة immutable: كل إضافة بترجّع سلة جديدة — والـ Cubit بيعمل emit ليها
class Cart {
  const Cart([this.items = const []]);

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;
  int get count => items.fold(0, (sum, item) => sum + item.quantity);
  int get total => items.fold(0, (sum, item) => sum + item.total);

  Cart add(Drink drink, DrinkSize size) {
    final index = items.indexWhere(
      (item) => item.isSameLine(drink, size),
    );
    if (index == -1) {
      return Cart(
        List.unmodifiable([
          ...items,
          CartItem(drink: drink, size: size, quantity: 1),
        ]),
      );
    }
    final current = items[index];
    final updated = [...items]
      ..[index] = CartItem(
        drink: drink,
        size: size,
        quantity: current.quantity + 1,
      );
    return Cart(List.unmodifiable(updated));
  }
}
