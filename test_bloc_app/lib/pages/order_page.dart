import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_bloc_app/bloc/menu/menu_bloc.dart';
import 'package:test_bloc_app/bloc/menu/menu_event.dart' as menuEvent;
import 'package:test_bloc_app/bloc/menu/menu_state.dart';
import 'package:test_bloc_app/bloc/order/order_bloc.dart';
import 'package:test_bloc_app/bloc/order/order_state.dart';
import 'package:test_bloc_app/bloc/order/order_event.dart' as orderEvent;
import 'package:test_bloc_app/generated/locale_keys.g.dart';
import 'package:test_bloc_app/main.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/providers/menu_data_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:test_bloc_app/providers/order_data_provider.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:test_bloc_app/widgets/order_item.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OrderPage extends StatefulWidget {
  static const routeName = ORDER_PAGE;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void dispose() {
    SingletonOrder.instance.flag = 'menu';
    super.dispose();
  }

  late List<MenuModel> listOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*    appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleKeys.order.tr()),
      ),
        drawer: BuildingLeftDrawer(),
      bottomNavigationBar: BottomNavBar(),*/
      body: BlocProvider<OrderBloc>(
        create: (context) => OrderBloc(RepositoryProvider.of<OrderDataProvider>(context)),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            listOrders = orderState.listOrders;
            return BlocProvider<MenuBloc>(
              create: (context) => MenuBloc(RepositoryProvider.of<MenuDataProvider>(context)),
              child: BlocBuilder<MenuBloc, MainState>(
                builder: (context, menuState) {
                  return SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        LocaleKeys.order.tr(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/back_arrow.svg',
                                              alignment: Alignment.centerLeft,
                                              width: 35,
                                              height: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: listOrders.isNotEmpty
                                              ? GestureDetector(
                                                  onTap: () {
                                                    _showAlertDialog(context);
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/images/trash.svg',
                                                    alignment: Alignment.centerLeft,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Menu list Block
                                Container(
                                  padding: EdgeInsets.only(top: 60),
                                  child: orderState is LoadingMenuState
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 12.0),
                                          child: SizedBox(
                                            height: 10,
                                            width: 100,
                                            child: LinearProgressIndicator(),
                                          ),
                                        )
                                      : listOrders.isNotEmpty
                                          ? _buildList(orderState)
                                          : Container(
                                              height: 500,
                                              child: Center(child: _noOrdersText),
                                            ),
                                ),
                              ],
                            ),
                          ),
                          _orderButton(context, orderState),
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

  Widget _orderButton(context, OrderState state) {
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
                  child: state.listOrders.isNotEmpty
                      ? MaterialButton(
                          height: 45,
                          minWidth: double.maxFinite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                          color: Color(0xFF4FA5F5),
                          onPressed: () {},
                          child: Text(
                            '${LocaleKeys.make_order.tr()} ${state.finalPrice} ${state.listOrders.first.unit}',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _noOrdersText => Container(
        alignment: Alignment.topCenter,
        child: Center(
          child: Container(
            height: 180,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/no_order.svg',
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    LocaleKeys.no_orders.tr(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  List<StaggeredTile> _generateTiles(List<MenuModel> data, int count) {
    return List.generate(
        count, (i) => StaggeredTile.extent(double.maxFinite.toInt(), data[i].cook ? 170 : 140));
  }

  Widget _buildList(OrderState orderState) {
    StaggeredTile _getTile(int index) =>
        _generateTiles(orderState.listOrders, orderState.listOrders.length)[index];
    return Column(
      children: [
        Expanded(
          child: StaggeredGridView.countBuilder(
            primary: false,
            crossAxisCount: 1,
            mainAxisSpacing: 5,
            staggeredTileBuilder: _getTile,
            itemBuilder: _getChild,
            itemCount: orderState.listOrders.length,
          ),
        ),
      ],
    );
  }

/*  Widget _buildList(OrderState orderState) {
    List<MenuModel> list = orderState.listOrders;
    return Expanded(
      child: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 3,
        mainAxisSpacing: 15.0,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        children: list
            .map((item) => Wrap(children: [OrderItem(orderListItem: item)]))
            .toList(growable: false),
      ),
    );
  }*/

  Widget _getChild(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 15.0, right: 15.0),
      child: OrderItem(orderListItem: listOrders[index]),
    );
  }

  _showAlertDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      child: Text(LocaleKeys.cancel.tr()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text(LocaleKeys.yes.tr()),
      onPressed: () {
        BlocProvider.of<MenuBloc>(context).add(menuEvent.ClearBasketEvent(0.0));
        BlocProvider.of<OrderBloc>(context).add(orderEvent.ClearBasketEvent());
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      scrollable: true,
      title: Text(LocaleKeys.really_empty_basket.tr()),
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
