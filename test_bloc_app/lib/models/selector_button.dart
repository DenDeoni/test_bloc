import 'package:equatable/equatable.dart';

class SelectorButton extends Equatable {
  final String name;
  final String alias;
  late bool isSelected;

  SelectorButton({
    required this.name,
    required this.alias,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [name + alias];
}
