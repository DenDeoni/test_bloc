import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_bloc_app/generated/locale_keys.g.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderMenu extends StatelessWidget {
  //final RestaurantModel restaurantModel;
  final SharedPreferences _prefs;
  bool isFavorite = false;

  HeaderMenu(this._prefs);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // Block Photo of restaurant
          height: 150,
/*          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(restaurantModel.image),
              fit: BoxFit.fitWidth,
            ),
          ),*/

          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0x00000000),
                const Color(0x00000000),
                const Color(0xCC000000),
                const Color(0xAA000000),
              ],
            ),
          ),
        ),
        Container(
          // Button 'Back'
          padding: EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image(
              image: AssetImage('assets/images/back_arrow.png'),
              width: 35,
            ),
          ),
        ),
        // Button "Favorites"
/*        Align(
            alignment: Alignment.topRight,
            child: BlocBuilder<RestaurantsBloc, restaurantsState.MainState>(
                builder: (BuildContext context, state) {
              // Button Favorite
              return Padding(
                padding: EdgeInsets.only(top: 10, right: 10),
                child: FavoritesButton(
                  onSelectionChange: (isSelected) {
                    BlocProvider.of<RestaurantsBloc>(context).add(
                      restaurantEvent.SetFavoritesPropertyEvent(
                          id: restaurantModel.id, isFavorite: isSelected),
                    );
                    print('restaurantModel.isFavorite: ${restaurantModel.isFavorite}');
                    print('IS SELECTED: $isSelected');
                  },
                  isSelected: _prefs.getBool(restaurantModel.id.toString()) ?? false,
                ),
              );
            })),*/
        Align(
          // Name of Restaurant
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 150,
            padding: EdgeInsets.only(bottom: 20),
            alignment: Alignment.bottomCenter,
            child: Text(
              "restaurantModel.name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
