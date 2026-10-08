import '../../domain/entities/category_total.dart';
import 'category_model.dart';

class CategoryTotalModel {
  final CategoryModel category;
  final int totalPiasters;

  const CategoryTotalModel({
    required this.category,
    required this.totalPiasters,
  });

  factory CategoryTotalModel.fromMap(Map<String, Object?> map) {
    return CategoryTotalModel(
      category: CategoryModel.fromMap(map),
      totalPiasters: map['total_piasters'] as int,
    );
  }

  CategoryTotalEntity toEntity() => CategoryTotalEntity(
    category: category.toEntity(),
    totalPiasters: totalPiasters,
  );
}
