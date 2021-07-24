import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'package:injector/injector.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/pages/not_found.dart';
import 'package:test_bloc_app/pages/order_page.dart';
import 'package:test_bloc_app/pages/restaurant_menu.dart';
import 'package:test_bloc_app/providers/menu_data_provider.dart';
import 'package:test_bloc_app/providers/order_data_provider.dart';
import 'package:test_bloc_app/redux/actions.dart';
import 'package:test_bloc_app/redux/store.dart';
import 'package:test_bloc_app/theme.dart';
import 'package:test_bloc_app/utils/consts.dart';

import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/app_state.dart';
import 'models/menu_route_params.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<MenuModel>(MenuModelAdapter());
  Hive.registerAdapter<Category>(CategoryAdapter());
  final Store<AppState> store = await createReduxStore();
  final _prefs = await SharedPreferences.getInstance();
  await Hive.openBox<MenuModel>(ORDER_BOX);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => MenuDataProvider()),
        RepositoryProvider(create: (_) => OrderDataProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        path: 'assets/translations',
        child: StoreProvider<AppState>(
          store: store,
          child: MyApp(_prefs),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final _prefs;

  MyApp(this._prefs);

  @override
  Widget build(BuildContext context) {
    final Store store = StoreProvider.of<AppState>(context);
    late Locale _loc;
    if (_prefs.getString(LANGUAGE_CODE) != null) {
      _loc = Locale(_prefs.getString(LANGUAGE_CODE) ?? 'en_US');
      print('LOC 1: $_loc');
    } else {
      print('supportedLocales: ${EasyLocalization.of(context)!.supportedLocales}');
      print('Intl.systemLocale: ${Intl.systemLocale}');
      print(
          'CONTAINS?: ${EasyLocalization.of(context)!.supportedLocales.contains(Intl.systemLocale.toLocale())}');
      _loc = EasyLocalization.of(context)!.supportedLocales.contains(Intl.systemLocale.toLocale())
          ? Locale(Intl.systemLocale)
          : Locale('en', 'US');

      print('LOC 2: $_loc');
      _prefs.setString(LANGUAGE_CODE, _loc.toString());
      store.dispatch(LocaleChanged(_loc));
    }
    //context.setLocale(_loc);
    print(' context.locale 1: ${context.locale}');
    return StoreConnector<AppState, Locale>(
      converter: (store) {
/*      EasyLocalization.of(context)
          ?.setLocale(store.state.locale ?? _loc); // ToDo bug! Duplicate call*/
        print(' context.locale 2: ${context.locale}');
        return context.locale;
      },
      builder: (BuildContext context, Locale locale) {
        print('MyApp Locale: $locale');
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: RESTAURANT_MENU,
          theme: newTheme,
          debugShowCheckedModeBanner: false,
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return NotFound();
              },
            );
          },
          // Routing
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case RestaurantMenu.routeName:
                SingletonOrder.instance.flag = 'menu';
                return MaterialPageRoute(
                  builder: (context) {
                    return RestaurantMenu();
                  },
                );
              case OrderPage.routeName:
                SingletonOrder.instance.flag = 'order';
                return MaterialPageRoute(builder: (BuildContext context) {
                  return OrderPage();
                });
              default:
                return MaterialPageRoute(
                  builder: (context) {
                    return NotFound();
                  },
                );
            }
          },
        );
      },
    );
  }
}

// singleton for Restaurant List / Favorites List choice (between Network and DB)
class SingletonFavorites {
  SingletonFavorites._privateConstructor();

  static SingletonFavorites instance = SingletonFavorites._privateConstructor();
  var flag;
}

// singleton for Menu List / Order List choice (between Network and DB)
class SingletonOrder {
  SingletonOrder._privateConstructor();

  static SingletonOrder instance = SingletonOrder._privateConstructor();
  var flag;
}
