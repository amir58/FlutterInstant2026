import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navigations/features/ahwety/data/models/drink_model.dart';

abstract class MenuLocalDataSource {
  Future<List<DrinkModel>> getMenu();
}

/// المنيو جاي من ملف JSON جوّه التطبيق — بكرة يبقى API والباقي ميتغيرش
class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  const MenuLocalDataSourceImpl(this._bundle);
  final AssetBundle _bundle; // rootBundle في التطبيق، وأي bundle وهمي في الاختبار

  static const _path = 'assets/data/menu.json';

  @override
  Future<List<DrinkModel>> getMenu() async {
    final decoded = jsonDecode(await _bundle.loadString(_path));
    if (decoded is! List) throw const FormatException('menu.json must be a list');
    return decoded
        .map((item) => item is Map<String, dynamic>
            ? DrinkModel.fromJson(item)
            : throw const FormatException('Invalid drink item'))
        .toList(growable: false);
  }
}