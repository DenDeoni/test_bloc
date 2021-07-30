import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_bloc_app/bloc/menu/menu_bloc.dart';
import 'package:test_bloc_app/bloc/menu/menu_event.dart' as menuEvent;
import 'package:test_bloc_app/bloc/menu/menu_event.dart';
import 'package:test_bloc_app/bloc/menu/menu_state.dart' as menuState;
import 'package:test_bloc_app/bloc/menu/menu_state.dart';
import 'package:test_bloc_app/bloc/order/order_bloc.dart';
import 'package:test_bloc_app/bloc/order/order_state.dart' as orderState;
import 'package:test_bloc_app/generated/locale_keys.g.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/models/selector_button.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:test_bloc_app/widgets/menu_item.dart';

class RestaurantMenu extends StatelessWidget {
  //RestaurantModel restaurantModel;
  bool isFavorite = false;

  var selectorKey = GlobalKey();

  static const routeName = RESTAURANT_MENU;

// BODY
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderBloc, orderState.OrderState>(
        builder: (context, orderState) {
          return BlocBuilder<MenuBloc, menuState.MainState>(
            builder: (context, menuState) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 50),
                              // Menu List Block
                              child: menuState is LoadingMenuState
                                  ? Container(
                                      height: 400,
                                      child: Center(child: CircularProgressIndicator()))
                                  : menuState.menuList.isEmpty
                                      ? Container(
                                          height: 350,
                                          child: Center(child: CircularProgressIndicator()))
                                      : Column(
                                          children: [
                                            _buildMenuList(context, menuState.menuList),
                                          ],
                                        ),
                              // List selector category buttons
                            ),
                            _selector(context),
                          ],
                        ),
                      ), // Order button
                      _orderButton(context, menuState),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _selector(BuildContext context) {
    return Container(
      key: selectorKey,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<MenuBloc, menuState.MainState>(
              builder: (context, state) {
                return state is menuState.LoadingMenuState
                    ? Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                          height: 10,
                          width: 100,
                          child: LinearProgressIndicator(),
                        ),
                      )
                    : state.selectorButtons.isEmpty
                        ? _noCategoriesText
                        : _selectorButtons(
                            context,
                            state.selectorButtons,
                          );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorButtons(BuildContext context, List<SelectorButton> list) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...list
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: FilterChip(
                    onSelected: (V) {
                      // Выбор категории
                      BlocProvider.of<MenuBloc>(context).add(
                        menuEvent.CategorySelectionEvent(category: item.alias),
                      );
                      item.isSelected = V;
                    },
                    selected: item.isSelected,
                    label: Text(
                      item.alias,
                      style: TextStyle(
                        color: item.isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildMenuList(context, List<MenuModel> listMenu) {
    return Expanded(
      flex: 7,
      child: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 2.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        children: listMenu.map((item) => MenuItem(item)).toList(growable: false),
      ),
    );
  }

  Widget _orderButton(context, menuState.MainState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    height: 45,
                    minWidth: double.maxFinite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    color: Color(0xFF4FA5F5),
                    onPressed: () {
                      Navigator.pushNamed(context, ORDER_PAGE);
                    },
                    child: Text(
                      state.menuList.isNotEmpty
                          ? '${LocaleKeys.order.tr()} ${state.finalPrice} ${state.menuList.first.unit}'
                          : '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _noCategoriesText => Container(
        alignment: Alignment.topCenter,
        width: 100,
        height: 100,
        child: Text(LocaleKeys.no_categories_found.tr()),
      );
}
