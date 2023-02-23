import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<Map> {
  ThemeCubit() : super(_lightTheme);

  static const _lightTheme = {
    "name": "light",
    "colors": [
      0xFF7AE5F5,
      0xFFC9F6FF,
    ],
    "icon": false,
  };

  static const _darkTheme = {
    "name": "dark",
    "colors": [
      0xFF0010F5,
      0xFF7AE5F5,
    ],
    "icon": true,
  };

  void toggleTheme() {
    emit(state['name'] == "dark" ? _lightTheme : _darkTheme);
  }

  void setTheme(theme) {
    emit(theme['name'] == "dark" ? _lightTheme : _darkTheme);
  }
}
