import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int iconCode;

  Category({
    required this.name,
    required IconData icon,
  }) : iconCode = icon.codePoint;

  Category.hive({required this.name, required this.iconCode});

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.name == name && other.iconCode == iconCode;
  }

  @override
  int get hashCode => name.hashCode ^ iconCode.hashCode;
}

// class Category {
//   final String name;
//   final IconData icon;

//   Category({required this.name, required this.icon});

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is Category && other.name == name && other.icon == icon;
//   }

//   @override
//   int get hashCode => name.hashCode ^ icon.hashCode;
// }
