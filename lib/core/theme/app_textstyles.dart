import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle appName = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    letterSpacing: 0.5,
  );

  static const TextStyle metaInfo = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    height: 1.4,
  );

  static const TextStyle newsTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    height: 1.3,
  );

  static const TextStyle description = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
    height: 1.5,
  );

  static const TextStyle content = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
    height: 1.6,
  );
}
