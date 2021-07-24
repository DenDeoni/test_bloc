import 'package:equatable/equatable.dart';
import 'package:test_bloc_app/models/menu_model.dart';

abstract class MenuEvent extends Equatable {
  final double finalOrderPrice;
  MenuEvent(this.finalOrderPrice);
}

class CategorySelectionEvent extends MenuEvent {
  final String category;

  CategorySelectionEvent({required this.category}) : super(0.0);

  @override
  List<Object> get props => [category];
}

class DataLoadedEvent extends MenuEvent {
  final List<MenuModel> data;
  final List<String> categories;

  DataLoadedEvent(this.data, this.categories) : super(0.0);

  @override
  List<Object> get props => [data, categories];
}

class SetFavoritesPropertyEvent extends MenuEvent {
  final int id;
  final bool isFavorite;

  SetFavoritesPropertyEvent({required this.id, required this.isFavorite}) : super(0.0);

  @override
  List<Object> get props => [id, isFavorite];
}

class AddSetEvent extends MenuEvent {
  final int id;
  final bool isSetAdded;

  AddSetEvent({required this.id, required this.isSetAdded}) : super(0.0);

  @override
  List<Object> get props => [id, isSetAdded];
}

class IncrementSetEvent extends MenuEvent {
  final id;
  final count;
  IncrementSetEvent({this.id, this.count}) : super(0.0);

  @override
  List<Object?> get props => [];
}

class RemoveSetEvent extends MenuEvent {
  final int id;
  final bool isSetAdded;

  RemoveSetEvent({required this.id, required this.isSetAdded}) : super(0.0);

  @override
  List<Object?> get props => [id, isSetAdded];
}

class ClearBasketEvent extends MenuEvent {
  final double finalOrderPrice;
  ClearBasketEvent(this.finalOrderPrice) : super(0.0);

  @override
  List<Object?> get props => [finalOrderPrice];
}

class AddDishEvent extends MenuEvent {
  final int id;
  final bool isDishAdded;

  AddDishEvent({required this.id, required this.isDishAdded}) : super(0.0);

  @override
  List<Object> get props => [id, isDishAdded];
}
