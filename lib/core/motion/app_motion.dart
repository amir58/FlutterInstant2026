import 'package:flutter/material.dart';

/// كل مدد ومنحنيات الحركة في التطبيق — مبنية على أرقام Material 3
abstract final class AppMotion {
  // المدد
  static const Duration fast = Durations.short4; // 200ms — أيقونات وعدّادات
  static const Duration medium = Durations.medium2; // 300ms — chips وأزرار وأرقام
  static const Duration page = Durations.medium4; // 400ms — الصفحات والـ Hero

  // المنحنيات
  static const Curve standard = Easing.standard; // حاجة بتتغير في مكانها
  static const Curve enter = Easing.emphasizedDecelerate; // داخلة الشاشة
  static const Curve exit = Easing.emphasizedAccelerate; // خارجة من الشاشة
  static const Curve pop = Curves.easeOutBack; // «نطّة» صغيرة: قلب، badge
}