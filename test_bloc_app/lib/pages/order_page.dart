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

class OrderPage extends StatelessWidget {
  static const routeName = ORDER_PAGE;

  late List<MenuModel> listOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            listOrders = orderState.listOrders;
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Stack(
                        children: [
                          // Menu list Block
                          Container(
                            padding: EdgeInsets.only(top: 60),
                            child: orderState is LoadingOrderState
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
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
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 0), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              // Order Text
                              child: Text(
                                LocaleKeys.order.tr(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
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
                        ],
                      ),
                    ),
                    _orderButton(context, orderState),
                  ],
                ),
              ),
            );
          },
        ));
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
        count, (i) => StaggeredTile.extent(double.maxFinite.toInt(), data[i].cook ? 160 : 140));
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
            mainAxisSpacing: 0,
            staggeredTileBuilder: _getTile,
            itemBuilder: _getChild,
            itemCount: orderState.listOrders.length,
          ),
        ),
      ],
    );
  }

  Widget _getChild(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15.0, right: 15.0),
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
