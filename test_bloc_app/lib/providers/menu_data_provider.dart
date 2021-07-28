import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_bloc_app/main.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MenuDataProvider {
  static const _url = 'https://run.mocky.io/v3/69a14e8c-62cc-4679-953e-d2d4a98d1901';

  late List<MenuModel> _loadedData;
  late List<MenuModel> menuModel;

  late SharedPreferences _preferences;

  Future<List<MenuModel>> _loadDataFromNetwork() async {
    final response = await http.get(
      Uri.parse(_url),
    );
    var dataParsed = json.decode(response.body);
    menuModel = await dataParsed
        .map<MenuModel>(
          (e) => MenuModel.fromJson(e),
        )
        .toList();
    return menuModel;
  }

  Future<List<MenuModel>> getData({required List<String> categoryFilter}) async {
    _preferences = await SharedPreferences.getInstance();
    _loadedData = await _loadDataFromNetwork();
    await _applySavedSets();
    final List<MenuModel> calculatedData = categoryFilter.isEmpty
        ? List<MenuModel>.from(_loadedData, growable: false)
        : _loadedData
            .where((element) => categoryFilter.contains(element.category.alias))
            .toList(growable: false);
    return calculatedData.map((e) => e).toList(growable: false);
  }

  Future _applySavedSets() async {
    for (var i = 0; i < _loadedData.length; i++) {
      if (_preferences.containsKey('${_loadedData[i].id}_set')) {
        _loadedData[i] = _loadedData[i].applyAddSet(
            isSetAdded: _preferences.getBool('${_loadedData[i].id}_set') ?? false,
            countSet: _preferences.getInt('${_loadedData[i].id}_set_count') ?? 0);
      }
    }
  }

  Future applyAddSet(int id, bool isSetAdded, double finalOrderPrice, int countSet) async {
    final index = _loadedData.indexWhere((element) => element.id == id);
    _loadedData[index] = _loadedData[index].applyAddSet(isSetAdded: isSetAdded, countSet: countSet);
    await Hive.box<MenuModel>(ORDER_BOX).put(id, _loadedData[index]);
    await Hive.box<MenuModel>(ORDER_BOX).compact();
    await _preferences.setBool('${id}_set', isSetAdded);
    await _preferences.setInt('${id}_set_count', countSet);
    await _preferences.setDouble('finalOrderPrice', finalOrderPrice);
  }

  Future applyRemoveSet(int id, bool isSetAdded, double finalOrderPrice) async {
    await _preferences.setBool('${id}_set', isSetAdded);
    await _preferences.setDouble('finalOrderPrice', finalOrderPrice);
    _loadedData[id].applyAddSet(isSetAdded: false, countSet: 0);
  }
}
