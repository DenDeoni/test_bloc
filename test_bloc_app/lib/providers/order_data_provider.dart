import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/utils/consts.dart';

class OrderDataProvider {
  late List<MenuModel> _loadedData;
  late List<MenuModel> menuModel;
  late SharedPreferences _preferences;

  Future<List<MenuModel>> _loadDataFromHive() async {
    return Hive.box<MenuModel>(ORDER_BOX).values.toList();
  }

  Future<List<MenuModel>> getData() async {
    _loadedData = await _loadDataFromHive();
    return _loadedData;
  }

  Future changeCountSet(int id, MenuModel item, double finalPrice) async {
    _preferences = await SharedPreferences.getInstance();
    await Hive.box<MenuModel>(ORDER_BOX).delete(id);
    await Hive.box<MenuModel>(ORDER_BOX).put(id, item);
    await Hive.box<MenuModel>(ORDER_BOX).compact();
    await _preferences.setDouble('finalOrderPrice', finalPrice);
  }

  Future applyRemoveSet(int id, double finalPrice) async {
    _preferences = await SharedPreferences.getInstance();
    await Hive.box<MenuModel>(ORDER_BOX).delete(id);
    await Hive.box<MenuModel>(ORDER_BOX).compact();
    await _preferences.setDouble('finalOrderPrice', finalPrice);
  }

  clearBasket() async {
    _preferences = await SharedPreferences.getInstance();
    Hive.box<MenuModel>(ORDER_BOX).clear();
    await Hive.box<MenuModel>(ORDER_BOX).compact();
    await _preferences.setDouble('finalOrderPrice', 0.0);
  }
}
