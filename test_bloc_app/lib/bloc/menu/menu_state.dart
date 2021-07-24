import 'package:equatable/equatable.dart';
import 'package:test_bloc_app/models/menu_model.dart';
import 'package:test_bloc_app/models/selector_button.dart';

abstract class MenuState extends Equatable {}

class MainState extends MenuState {
  final List<MenuModel> menuList;
  final List<SelectorButton> selectorButtons;
  final double finalPrice;

  MainState({
    required this.menuList,
    required this.selectorButtons,
    required this.finalPrice,
  });

  @override
  List<Object?> get props => [...menuList, ...selectorButtons, finalPrice];

  MainState copyWith({
    List<MenuModel>? menuList,
    List<SelectorButton>? selectorButtons,
    required double finalPrice,
  }) {
    return MainState(
        menuList: menuList ?? [], selectorButtons: selectorButtons ?? [], finalPrice: finalPrice);
  }
}

class LoadingMenuState extends MainState {
  LoadingMenuState({menuList, selectorButtons, finalOrderPrice})
      : super(menuList: [], selectorButtons: [], finalPrice: 0.0);

  @override
  List<Object?> get props => [...menuList, finalPrice];
}
