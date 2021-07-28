import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/models/selector_button.dart';
import 'package:test_bloc_app/providers/menu_data_provider.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MainState> {
  final MenuDataProvider menuDataProvider;

  MenuBloc(this.menuDataProvider) : super(LoadingMenuState(menuList: [], selectorButtons: [])) {
    _loadData(categories: []);
  }

  late List<String> categories;
  List<String> newCategories = [];
  late List<MenuModel> menuList;
  double finalPrice = 0.0;
  List<SelectorButton>? selectorButtons;
  late var index;

  @override
  Stream<MainState> mapEventToState(
    MenuEvent event,
  ) async* {
    finalPrice = await _getFinalPrice() ?? 0.0;
    if (event is CategorySelectionEvent) {
      List<String> updatedCategories;
      index = categories.indexOf(event.category);
      if (state.selectorButtons[index].isSelected) {
        // Selected
        updatedCategories = newCategories + [event.category];
      } else {
        // Unselected
        updatedCategories = List<String>.from(newCategories);
        updatedCategories.remove(state.selectorButtons[index].alias);
      }
      newCategories = updatedCategories;
      yield state.copyWith(
        menuList: menuList,
        selectorButtons: selectorButtons,
        finalPrice: finalPrice,
      );
      await _loadData(
        categories: updatedCategories,
      );
    } else if (event is DataLoadedEvent) {
      yield state.copyWith(
        menuList: menuList,
        selectorButtons: selectorButtons,
        finalPrice: finalPrice,
      );
    } else if (event is AddSetEvent) {
      List<MenuModel> newMenuList = List<MenuModel>.from(state.menuList);
      final indexOfUpdated = newMenuList.indexWhere((element) => element.id == event.id);
      MenuModel item = newMenuList[indexOfUpdated];
      item = item.applyAddSet(
          isSetAdded: event.isSetAdded, countSet: state.menuList[event.id].countSet + 1);
      newMenuList.add(item);
      finalPrice = state.finalPrice + item.priceSet;
      yield state.copyWith(
        menuList: newMenuList,
        selectorButtons: state.selectorButtons,
        finalPrice: finalPrice,
      );
      _loadData(categories: categories);
      menuDataProvider.applyAddSet(event.id, item.isSetAdded, finalPrice, item.countSet);
    }
    // Remove Set
    else if (event is RemoveSetEvent) {
      final newMenuList = List<MenuModel>.from(state.menuList);
      final indexOfUpdated = newMenuList.indexWhere((element) => element.id == event.id);
      MenuModel item = newMenuList[indexOfUpdated];
      final double finalPrice = state.finalPrice - item.priceSet * item.countSet;
      item = item.applyAddSet(isSetAdded: false, countSet: 0);
      newMenuList.toSet().add(item);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('${item.id}_set', false);
      await preferences.setInt('${item.id}_set_count', 0);
      yield state.copyWith(
        menuList: newMenuList,
        selectorButtons: selectorButtons,
        finalPrice: finalPrice,
      );
      await _loadData(categories: categories);
      await menuDataProvider.applyRemoveSet(event.id, false, finalPrice);
    }
    // Clear Basket
    else if (event is ClearBasketEvent) {
      final finalPrice = 0.0;
      List<MenuModel> newMenuList = List<MenuModel>.from(state.menuList);
      for (var i = 0; i < state.menuList.length; i++) {
        var item = state.menuList[i].applyAddSet(isSetAdded: false, countSet: 0);
        print('$i: ${item.isSetAdded}');
        newMenuList.add(item);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setBool('${newMenuList[i].id}_set', false);
        await preferences.setInt('${newMenuList[i].id}_set_count', 0);
      }
      yield state.copyWith(
        menuList: newMenuList,
        selectorButtons: selectorButtons,
        finalPrice: finalPrice,
      );
      await _loadData(categories: categories);
    }
  }

  Future<double?> _getFinalPrice() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getDouble('finalOrderPrice');
  }

  Future _loadData({
    required List<String> categories,
  }) async {
    final data = await menuDataProvider.getData(categoryFilter: categories);
    add(DataLoadedEvent(
      data,
      categories,
    ));
    menuList = data;
    selectorButtons = selectorButtons == null ? buildBtnListFirst(data) : buildBtnListSecond(data);
  }

  Future<String> getLocale() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var loc = Locale(preferences.getString(LANGUAGE_CODE) ?? 'en_US');

    return loc.toString();
  }

  List<SelectorButton> buildBtnListFirst(List<MenuModel> menuModel) {
    List<SelectorButton> list = [];
    Set<String> set = Set();
    List.generate(menuModel.length, (index) {
      set.add(menuModel[index].category.alias);
    });
    categories = set.toList();
    List.generate(
        set.length,
        (index) => list.add(
              SelectorButton(
                name: '',
                alias: set.elementAt(index),
                isSelected: false,
              ),
            ));
    return list;
  }

  List<SelectorButton> buildBtnListSecond(List<MenuModel> restaurants) {
    List<SelectorButton> list = [];
    Set<String> set = categories.toSet();

    List.generate(
        set.length,
        (index) => list.add(
              SelectorButton(
                name: '',
                alias: set.elementAt(index),
                isSelected: state.selectorButtons[index].isSelected,
              ),
            ));
    return list;
  }
}
