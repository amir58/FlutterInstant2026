import '../../domain/entities/expense_category.dart';

class CategoryModel {
  final int id;
  final String name;
  final int colorValue;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  factory CategoryModel.fromMap(Map<String, Object?> map) {
    return CategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      colorValue: map['color'] as int,
    );
  }

  factory CategoryModel.fromEntity(ExpenseCategoryEntity category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      colorValue: category.colorValue,
    );
  }

  ExpenseCategoryEntity toEntity() => ExpenseCategoryEntity(
    id: id,
    name: name,
    colorValue: colorValue,
  );
}
