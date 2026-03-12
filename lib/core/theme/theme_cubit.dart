import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences prefs) {
    final stored = prefs.getString(_key);
    switch (stored) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setLight() => _save(ThemeMode.light);
  void setDark() => _save(ThemeMode.dark);
  void setSystem() => _save(ThemeMode.system);

  void toggle() {
    switch (state) {
      case ThemeMode.light:
        _save(ThemeMode.dark);
      case ThemeMode.dark:
        _save(ThemeMode.system);
      case ThemeMode.system:
        _save(ThemeMode.light);
    }
  }

  void _save(ThemeMode mode) {
    emit(mode);
    _prefs.setString(_key, mode.name);
  }
}
