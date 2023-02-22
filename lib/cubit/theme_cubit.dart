import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<Map> {
  ThemeCubit() : super(_lightTheme);

  static const _lightTheme = {
    "name": "light",
    "colors": [
      Color(0xFF7AE5F5),
      Color(0xFFC9F6FF),
    ],
    "icon": Icon(Icons.light_mode),
  };

  static const _darkTheme = {
    "name": "dark",
    "colors": [
      Color(0xFF0010F5),
      Color(0xFF7AE5F5),
    ],
    "icon": Icon(Icons.dark_mode),
  };

  void toggleTheme() {
    emit(state['name'] == "dark" ? _lightTheme : _darkTheme);
  }
}
