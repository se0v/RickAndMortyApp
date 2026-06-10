part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class SetTheme extends ThemeEvent {
  final bool isDark;
  SetTheme({required this.isDark});
}