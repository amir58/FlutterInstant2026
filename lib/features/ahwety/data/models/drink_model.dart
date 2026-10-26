import 'package:navigations/features/ahwety/domain/entities/drink.dart';

class DrinkModel {
  final int id;
  final String name;
  final String description;
  final String emoji;
  final int tintValue;
  final DrinkCategory category;
  final int basePrice;

  const DrinkModel({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.tintValue,
    required this.category,
    required this.basePrice,
  });

  /// أي حقل ناقص أو نوعه غلط ⇐ FormatException، والـ Repository بيحوّلها Failure
  factory DrinkModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'name': final String name,
        'description': final String description,
        'emoji': final String emoji,
        'tint': final String tint,
        'category': final String category,
        'price': final int price,
      } when price > 0 =>
        DrinkModel(
          id: id,
          name: name,
          description: description,
          emoji: emoji,
          tintValue: _parseTint(tint),
          category: _parseCategory(category),
          basePrice: price,
        ),
      _ => throw FormatException('Invalid drink', json),
    };
  }

  static int _parseTint(String hex) {
    final value = hex.length == 7 && hex.startsWith('#')
        ? int.tryParse(hex.substring(1), radix: 16)
        : null;
    if (value == null) throw FormatException('Invalid tint', hex);
    return 0xFF000000 | value;
  }

  static DrinkCategory _parseCategory(String name) {
    return DrinkCategory.values.asNameMap()[name] ??
        (throw FormatException('Unknown category', name));
  }

  Drink toEntity() => Drink(
        id: id,
        name: name,
        description: description,
        emoji: emoji,
        tintValue: tintValue,
        category: category,
        basePrice: basePrice,
      );
}