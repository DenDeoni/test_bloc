import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:test_bloc_app/providers/menu_data_provider.dart';
import 'package:test_bloc_app/providers/order_data_provider.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:test_bloc_app/widgets/header_menu.dart';
import 'package:test_bloc_app/widgets/menu_item.dart';
import 'package:test_bloc_app/widgets/object_description.dart';
import 'package:test_bloc_app/widgets/object_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantMenu extends StatelessWidget {
  //RestaurantModel restaurantModel;
  bool isFavorite = false;

  var selectorKey = GlobalKey();

  static const routeName = RESTAURANT_MENU;

// BODY
  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleKeys.title.tr()),
      ),
      drawer: BuildingLeftDrawer(),
      bottomNavigationBar: BottomNavBar(),*/
      body: BlocProvider<OrderBloc>(
        create: (context) => OrderBloc(RepositoryProvider.of<OrderDataProvider>(context)),
        child: BlocBuilder<OrderBloc, orderState.OrderState>(
          builder: (context, orderState) {
            return BlocProvider<MenuBloc>(
              create: (context) => MenuBloc(RepositoryProvider.of<MenuDataProvider>(context)),
              child: BlocBuilder<MenuBloc, menuState.MainState>(
                builder: (context, menuState) {
                  return SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
/*                          BlocProvider<RestaurantsBloc>(
                            create: (context) => RestaurantsBloc(
                                RepositoryProvider.of<RestaurantsDataProvider>(context)),
                            child: BlocBuilder<RestaurantsBloc, restaurantsState.MainState>(
                              builder: (context, state) {
                                // HEADER
                                return Column(
                                  children: [
                                    HeaderMenu(restaurantModel, _prefs),
                                  ],
                                );
                              },
                            ),
                          ),*/
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
              ),
            );
          },
        ),
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
          // Icon settings
          IconButton(
            onPressed: () {
              _showAlertDialog(context);
            },
            icon: Icon(Icons.settings),
          ),
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

  _showAlertDialog(BuildContext context) {
    // Buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      scrollable: true,
      title: Text("Primary Criteria - Health & Lifestyle"),
      content: Text(
          "Aging: Healthy aging, Malnutrition\nBrain health: Epilepsy, Alzheimers, Mild Cognitive Impairment\nCancer: Cancer/Oncology\nCritical care/Surgery: Adult Enteral Nutrition, Major Surgery\nDysphagia: Dysphagia\nFood allergy: Cow milk allergy, gluten allergy\nGut health: Constipation, Inflammatory bowel disease, Irritable bowel syndrome\nInborn errors of metabolism\nMetabolic health: Diabetes, Weight management\nPediatrics: Pediatric dysphagia and reflux, Neurological disorders, Kids with Cerebral Palsy, Gastrointestinal diseases, Feeding difficulties, Growth delay, Cystic fibrosis\nLifestyle - Vegan, Vegetarian, Halal, Kosher,"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: alert,
        );
      },
    );
  }
}
