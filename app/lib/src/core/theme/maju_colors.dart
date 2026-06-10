import 'package:flutter/material.dart';

/// MAJU brand palette — derived from the logo and the design reference
/// (blue "Maju" + orange "FINANÇAS" + green for positive money).
abstract class MajuColors {
  // Brand — blue
  static const blue900 = Color(0xFF102A4F);
  static const blue800 = Color(0xFF15396B);
  static const blue700 = Color(0xFF1B4D8F);
  static const blue500 = Color(0xFF1F5AA8);
  static const blue100 = Color(0xFFE7EFFA);

  // Brand — orange (accent / primary CTA)
  static const orange600 = Color(0xFFD2631C);
  static const orange500 = Color(0xFFE8742C);
  static const orange100 = Color(0xFFFCEBDD);

  // Semantic
  static const green500 = Color(0xFF27A567);
  static const green100 = Color(0xFFE2F4EC);
  static const red500 = Color(0xFFE0533D);
  static const red100 = Color(0xFFFBE7E3);
  static const amber500 = Color(0xFFE9A93C);

  // Neutrals
  static const bg = Color(0xFFF3F5F9);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1A2433);
  static const ink2 = Color(0xFF5B6675);
  static const ink3 = Color(0xFF9AA4B2);
  static const line = Color(0xFFE8ECF2);
}
