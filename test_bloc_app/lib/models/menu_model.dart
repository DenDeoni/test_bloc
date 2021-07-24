import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'menu_model.g.dart';

@HiveType(typeId: 1)
class MenuModel {
  const MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priceSet,
    required this.priceDish,
    required this.isSetAdded,
    required this.isDishAdded,
    required this.unit,
    required this.cook,
    required this.dish,
    required this.image,
    required this.category,
    required this.countSet,
    required this.countDish,
  });

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final double priceSet;
  @HiveField(4)
  final double priceDish;
  @HiveField(5)
  final bool isSetAdded;
  @HiveField(6)
  final bool isDishAdded;
  @HiveField(7)
  final String unit;
  @HiveField(8)
  final bool cook;
  @HiveField(9)
  final bool dish;
  @HiveField(10)
  final String image;
  @HiveField(11)
  final Category category;
  @HiveField(12)
  final int countSet;
  @HiveField(13)
  final int countDish;

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      priceSet: json['priceSet'] as double,
      priceDish: json['priceDish'] as double,
      isSetAdded: json['isSetAdded'] as bool,
      isDishAdded: json['isDishAdded'] as bool,
      unit: json['unit'] as String,
      cook: json['cook'] as bool,
      dish: json['dish'] as bool,
      image: json['image'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      countSet: json['countSet'] as int,
      countDish: json['countDish'] as int);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'priceSet': priceSet,
        'priceDish': priceDish,
        'isSetAdded': isSetAdded,
        'isDishAdded': isDishAdded,
        'unit': unit,
        'cook': cook,
        'dish': dish,
        'image': image,
        'category': category.toJson(),
        'countSet': countSet,
        'countDish': countDish
      };

  MenuModel clone() => MenuModel(
        id: id,
        name: name,
        description: description,
        priceSet: priceSet,
        priceDish: priceDish,
        isSetAdded: isSetAdded,
        isDishAdded: isDishAdded,
        unit: unit,
        image: image,
        category: category.clone(),
        countSet: countSet,
        countDish: countDish,
        cook: cook,
        dish: dish,
      );

  MenuModel applyAddSet({required bool isSetAdded, required int countSet}) => MenuModel(
        id: id,
        name: name,
        description: description,
        priceSet: priceSet,
        priceDish: priceDish,
        isSetAdded: isSetAdded,
        isDishAdded: isDishAdded,
        unit: unit,
        image: image,
        category: category,
        countSet: countSet,
        countDish: 0,
        cook: cook,
        dish: dish,
      );

  MenuModel changeCountSet({required int countSet, required double priceSet}) => MenuModel(
        id: id,
        name: name,
        description: description,
        priceSet: priceSet,
        priceDish: priceDish,
        isSetAdded: isSetAdded,
        isDishAdded: isDishAdded,
        unit: unit,
        image: image,
        category: category,
        countSet: countSet,
        countDish: countDish,
        cook: cook,
        dish: dish,
      );

  MenuModel applyAddDish(bool isDishAdded) => MenuModel(
        id: id,
        name: name,
        description: description,
        priceSet: priceSet,
        priceDish: priceDish,
        isSetAdded: isSetAdded,
        isDishAdded: isDishAdded,
        unit: unit,
        image: image,
        category: category,
        countSet: countSet,
        countDish: countDish,
        dish: dish,
        cook: cook,
      );

  MenuModel copyWith(
          {int? id,
          String? name,
          String? description,
          double? priceSet,
          double? priceDish,
          bool? isSetAdded,
          bool? isDishAdded,
          String? unit,
          bool? cook,
          bool? dish,
          String? image,
          Category? category,
          int? countSet,
          int? countDish}) =>
      MenuModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        priceSet: priceSet ?? this.priceSet,
        priceDish: priceDish ?? this.priceDish,
        isSetAdded: isSetAdded ?? this.isSetAdded,
        isDishAdded: isDishAdded ?? this.isDishAdded,
        unit: unit ?? this.unit,
        cook: cook ?? this.cook,
        dish: dish ?? this.dish,
        image: image ?? this.image,
        category: category ?? this.category,
        countSet: countSet ?? this.countSet,
        countDish: countDish ?? this.countDish,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuModel &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          priceSet == other.priceSet &&
          priceDish == other.priceDish &&
          isSetAdded == other.isSetAdded &&
          isDishAdded == other.isDishAdded &&
          unit == other.unit &&
          cook == other.cook &&
          dish == other.dish &&
          image == other.image &&
          category == other.category &&
          countSet == other.countSet &&
          countDish == other.countDish;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      priceSet.hashCode ^
      priceDish.hashCode ^
      isSetAdded.hashCode ^
      isDishAdded.hashCode ^
      unit.hashCode ^
      cook.hashCode ^
      dish.hashCode ^
      image.hashCode ^
      category.hashCode ^
      countSet.hashCode ^
      countDish.hashCode;
}

@immutable
@HiveType(typeId: 2)
class Category {
  const Category({
    required this.name,
    required this.alias,
  });

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String alias;

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json['name'] as String, alias: json['alias'] as String);

  Map<String, dynamic> toJson() => {'name': name, 'alias': alias};

  Category clone() => Category(name: name, alias: alias);

  Category copyWith({String? name, String? alias}) => Category(
        name: name ?? this.name,
        alias: alias ?? this.alias,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category && name == other.name && alias == other.alias;

  @override
  int get hashCode => name.hashCode ^ alias.hashCode;
}
