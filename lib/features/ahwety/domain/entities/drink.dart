enum DrinkCategory { hot, iced, dessert }

enum DrinkSize {
  small(extraPrice: 0),
  medium(extraPrice: 10),
  large(extraPrice: 20);

  const DrinkSize({required this.extraPrice});
  final int extraPrice;
}

class Drink {
  final int id;
  final String name;
  final String description;
  final String emoji;
  final int tintValue; // لون الخلفية ARGB كرقم — الدومين ميعرفش Color بتاعة Flutter
  final DrinkCategory category;
  final int basePrice; // بالجنيه، للحجم الصغير

  const Drink({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.tintValue,
    required this.category,
    required this.basePrice,
  });

  /// الحلويات مالهاش أحجام
  bool get hasSizes => category != DrinkCategory.dessert;

  int priceFor(DrinkSize size) => hasSizes ? basePrice + size.extraPrice : basePrice;
}