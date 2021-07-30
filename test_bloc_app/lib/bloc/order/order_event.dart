import 'package:test_bloc_app/models/menu_model.dart';

class OrderEvent {}

class DataLoadedEvent extends OrderEvent {
  final List<MenuModel> data;
  DataLoadedEvent(this.data);
}

class IncrementSetEvent extends OrderEvent {
  final int id;
  IncrementSetEvent({required this.id});
}

class DecrementSetEvent extends OrderEvent {
  final int id;
  DecrementSetEvent({required this.id});
}

class RemoveSetEvent extends OrderEvent {
  final int id;
  final bool isSetAdded = false;

  RemoveSetEvent({required this.id});
}

class ClearBasketEvent extends OrderEvent {}
