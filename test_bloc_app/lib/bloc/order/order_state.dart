import 'package:equatable/equatable.dart';
import 'package:test_bloc_app/models/menu_model.dart';

class OrderState extends Equatable {
  final List<MenuModel> listOrders;
  final double finalPrice;

  OrderState({required this.listOrders, required this.finalPrice});

  @override
  List<Object?> get props => [...listOrders, finalPrice];

  OrderState copyWith({required List<MenuModel> listOrders, required double finalPrice}) {
    return OrderState(listOrders: listOrders, finalPrice: finalPrice);
  }
}

class LoadingOrderState extends OrderState {
  LoadingOrderState({listOrders, finalPrice}) : super(listOrders: [], finalPrice: 0.0);

  @override
  List<Object?> get props => [...listOrders, finalPrice];
}
