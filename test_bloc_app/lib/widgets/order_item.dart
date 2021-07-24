import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_bloc_app/bloc/menu/menu_bloc.dart';
import 'package:test_bloc_app/bloc/menu/menu_event.dart' as menuEvent;
import 'package:test_bloc_app/bloc/order/order_bloc.dart';
import 'package:test_bloc_app/bloc/order/order_event.dart';
import 'package:test_bloc_app/generated/locale_keys.g.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderItem extends StatelessWidget {
  final MenuModel orderListItem;

  OrderItem({required this.orderListItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () => _recipeDetails(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    // Block Photo of recipe
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(orderListItem.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    //child: Image.network(data.image),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trash button
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                _showAlertDialog(context);
                              },
                              child: SvgPicture.asset(
                                'assets/images/trash.svg',
                                alignment: Alignment.centerLeft,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                          // Name of dish
                          Padding(
                            padding: EdgeInsets.only(left: 6.0, bottom: 20),
                            child: Text(
                              orderListItem.name,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          // Buttons + / - , price
                          Row(
                            children: [
                              _buttonMinus(context),
                              Text(orderListItem.countSet.toString()),
                              _buttonPlus(context),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    orderListItem.priceSet.toString() + ' ' + orderListItem.unit,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // INFO
          orderListItem.cook
              ? Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/info_green.svg',
                        alignment: Alignment.centerLeft,
                        width: 18,
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(LocaleKeys.cook_yourself.tr()),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 0.0,
                ),
        ],
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text(LocaleKeys.no.tr()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text(LocaleKeys.yes.tr()),
      onPressed: () {
        BlocProvider.of<OrderBloc>(context).add(RemoveSetEvent(id: orderListItem.id));
        BlocProvider.of<MenuBloc>(context)
            .add(menuEvent.RemoveSetEvent(id: orderListItem.id, isSetAdded: false));
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      scrollable: true,
      title: Text(LocaleKeys.really_delete_item.tr()),
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

  Widget _buttonPlus(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<OrderBloc>(context).add(IncrementSetEvent(id: orderListItem.id));
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/plus.svg',
                alignment: Alignment.centerLeft,
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonMinus(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<OrderBloc>(context).add(DecrementSetEvent(id: orderListItem.id));
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/minus.svg',
                alignment: Alignment.centerLeft,
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _recipeDetails(BuildContext context) {
    Navigator.pushNamed(context, RECIPE_DETAILS);
  }
}
