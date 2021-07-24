import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_bloc_app/bloc/order/order_event.dart';
import 'package:test_bloc_app/bloc/order/order_state.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/providers/order_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderDataProvider orderDataProvider;

  OrderBloc(this.orderDataProvider) : super(LoadingOrderState(listOrders: [], finalPrice: 0.0)) {
    _loadData();
  }

  late List<MenuModel> listOrders;
  double finalPrice = 0.0;

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    finalPrice = await _getFinalPrice() ?? 0.0;
    if (event is DataLoadedEvent) {
      yield state.copyWith(
        listOrders: listOrders,
        finalPrice: finalPrice,
      );
    }
    // Increment
    else if (event is IncrementSetEvent) {
      final List<MenuModel> newOrderList = List<MenuModel>.from(state.listOrders);
      final int indexOfUpdated = newOrderList.indexWhere((element) => element.id == event.id);
      MenuModel item = newOrderList[indexOfUpdated];
      final int countSet = item.countSet + 1;
      final double priceSetPiece = item.priceSet / item.countSet;
      final double priceSet = priceSetPiece + item.priceSet;
      item = item.changeCountSet(countSet: countSet, priceSet: priceSet);
      newOrderList.toSet().add(item);
      double finalPrice = state.finalPrice + priceSetPiece;
      yield state.copyWith(
        listOrders: newOrderList,
        finalPrice: finalPrice,
      );
      await orderDataProvider.changeCountSet(event.id, item, finalPrice);
      _loadData();
    }
    // Decrement
    else if (event is DecrementSetEvent) {
      final List<MenuModel> newOrderList = List<MenuModel>.from(state.listOrders);
      final int indexOfUpdated = newOrderList.indexWhere((element) => element.id == event.id);
      MenuModel item = newOrderList[indexOfUpdated];
      if (item.countSet > 1) {
        final int countSet = item.countSet - 1;
        final double priceSet = item.priceSet - item.priceSet / item.countSet;
        item = item.changeCountSet(countSet: countSet, priceSet: priceSet);
        newOrderList.toSet().add(item);
        double finalPrice = state.finalPrice - priceSet;
        yield state.copyWith(
          listOrders: newOrderList,
          finalPrice: finalPrice,
        );
        await orderDataProvider.changeCountSet(event.id, item, finalPrice);
        _loadData();
      }
    }
    // Remove Set
    else if (event is RemoveSetEvent) {
      List<MenuModel> newOrderList = List<MenuModel>.from(state.listOrders);
      final int indexOfUpdated = newOrderList.indexWhere((element) => element.id == event.id);
      MenuModel item = newOrderList[indexOfUpdated];
      final double finalPrice = state.finalPrice - item.priceSet * item.countSet;
      print('state.finalPrice 3: ${state.finalPrice}');
      print('item.priceSet 3: ${item.priceSet}');
      print('item.countSet 3: ${item.countSet}');
      newOrderList.remove(item);
      yield state.copyWith(
        listOrders: newOrderList,
        finalPrice: finalPrice,
      );
      await orderDataProvider.applyRemoveSet(event.id, finalPrice);
    }
    // Clear Basket
    else if (event is ClearBasketEvent) {
      yield state.copyWith(
        listOrders: [],
        finalPrice: 0.0,
      );
      orderDataProvider.clearBasket();
    }
  }

  Future<double?> _getFinalPrice() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getDouble('finalOrderPrice');
  }

  Future _loadData() async {
    final List<MenuModel>data = await orderDataProvider.getData();
    add(DataLoadedEvent(
      data,
    ));
    listOrders = data;
  }
}
