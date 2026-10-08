import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';

import '../../domain/entities/expense_category.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_month_overview_usecase.dart';
import 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit(this._getCategories, this._getMonthOverview)
    : super(const ExpensesLoading());

  final GetCategoriesUseCase _getCategories;
  final GetMonthOverviewUseCase _getMonthOverview;

  List<ExpenseCategoryEntity> _categories = const [];
  DateTime _month = _startOfMonth(DateTime.now());
  int? _categoryId;

  static DateTime _startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  // أول تحميل وزرار «حاول تاني» — هنا بس بنعرض Loading
  Future<void> load() async {
    emit(const ExpensesLoading());
    final result = await _getCategories();
    if (isClosed) return;
    switch (result) {
      case ApiSuccess(:final data):
        _categories = data;
        await _fetch(_month, _categoryId);
      case ApiFailure(:final failure):
        emit(ExpensesError(failure.message));
    }
  }

  Future<void> changeMonth(int delta) => _fetch(
    DateTime(_month.year, _month.month + delta),
    _categoryId,
  );

  Future<void> selectCategory(int? categoryId) =>
      _fetch(_month, categoryId);

  // بعد الحفظ أو المسح: تحديث صامت من غير Loading
  Future<void> refresh() => _fetch(_month, _categoryId);

  Future<void> _fetch(DateTime month, int? categoryId) async {
    final result = await _getMonthOverview(
      month,
      categoryId: categoryId,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccess(:final data):
        _month = month;
        _categoryId = categoryId;
        emit(
          ExpensesLoaded(
            categories: _categories,
            overview: data,
            selectedCategoryId: categoryId,
          ),
        );
      case ApiFailure(:final failure):
        final current = state;
        // الداتا معروضة بالفعل؟ متكسرهاش بشاشة خطأ — سيبها وقول للمستخدم
        emit(
          current is ExpensesLoaded
              ? current.withNotice(failure.message)
              : ExpensesError(failure.message),
        );
    }
  }
}
