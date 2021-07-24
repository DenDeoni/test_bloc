import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_bloc_app/bloc/menu/menu_bloc.dart';
import 'package:test_bloc_app/bloc/menu/menu_event.dart';
import 'package:test_bloc_app/bloc/menu/menu_state.dart';
import 'package:test_bloc_app/generated/locale_keys.g.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:test_bloc_app/widgets/object_name.dart';

import 'package:easy_localization/easy_localization.dart';

import 'object_description.dart';

class MenuItem extends StatelessWidget {
  final MenuModel menuListItem;

  MenuItem(this.menuListItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _recipeDetails(context),
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name and Description
                      ObjectName(menuListItem.name),
                      ObjectDescription(menuListItem.description),
                      // Buttons for orders
                      menuListItem.cook ? _buttonOrderSet(context, menuListItem) : Container(),
                      menuListItem.dish ? _buttonOrderDish(context, menuListItem) : Container(),
                    ],
                  ),
                ),
              ),
              // Block Photo of recipe
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 150,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(menuListItem.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buttonOrderSet(context, MenuModel menuListItem) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: InkWell(
        onTap: () {
          menuListItem.isSetAdded
              ? null
              : BlocProvider.of<MenuBloc>(context)
                  .add(AddSetEvent(id: menuListItem.id, isSetAdded: true));
        },
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            color: Colors.white,
            //border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/products_set.svg',
                  alignment: Alignment.centerLeft,
                  width: 18,
                  height: 18,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: menuListItem.isSetAdded
                      ? Text(
                          '${LocaleKeys.set_in_basket.tr()}',
                          style: TextStyle(fontSize: 13, color: Colors.blueAccent),
                        )
                      : Text(
                          '${LocaleKeys.set.tr()} ${menuListItem.priceSet} ${menuListItem.unit}',
                          style: TextStyle(fontSize: 13, color: Colors.blueAccent),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonOrderDish(context, MenuModel menuListItem) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            color: Color(0xFF4FA5F5),
            //border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/dish.svg',
                  alignment: Alignment.centerLeft,
                  width: 18,
                  height: 18,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Готовое блюдо: ${menuListItem.priceDish} ${menuListItem.unit}',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _recipeDetails(BuildContext context) {
    Navigator.pushNamed(context, RECIPE_DETAILS);
  }
}
