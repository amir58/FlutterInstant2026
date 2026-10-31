import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;
  
  static const _key = 'theme_mode';

  // آخر اختيار متحفظ — ولو مفيش (أول مرة) يبقى system
  static ThemeMode _load(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
  }

  Future<void> toggle(Brightness current) async {
    final next = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next); // الشاشة تتغيّر فوراً
    await _prefs.setString(_key, next.name); // ويتحفظ للمرة الجاية
  }
}