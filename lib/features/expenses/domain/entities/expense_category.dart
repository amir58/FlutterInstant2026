class ExpenseCategoryEntity {
  final int id;
  final String name;
  final int
  colorValue; // ARGB كرقم — الدومين ميعرفش Color بتاعة Flutter

  const ExpenseCategoryEntity({
    required this.id,
    required this.name,
    required this.colorValue,
  });
}
