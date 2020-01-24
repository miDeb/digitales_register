import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef ThemedWidgetBuilder = Widget Function(BuildContext context, ThemeData data);

typedef ThemeDataBuilder = ThemeData Function(Brightness brightness, bool platformOverride);

class DynamicTheme extends StatefulWidget {
  const DynamicTheme({
    Key key,
    this.data,
    this.themedWidgetBuilder,
    this.defaultBrightness = Brightness.light,
  }) : super(key: key);

  /// Builder that gets called when the brightness or theme changes
  final ThemedWidgetBuilder themedWidgetBuilder;

  /// Callback that returns the latest brightness
  final ThemeDataBuilder data;

  /// The default brightness on start
  ///
  /// Defaults to `Brightness.light`
  final Brightness defaultBrightness;

  @override
  DynamicThemeState createState() => DynamicThemeState();

  static DynamicThemeState of(BuildContext context) {
    return context.findAncestorStateOfType<State<DynamicTheme>>();
  }
}

class DynamicThemeState extends State<DynamicTheme> {
  ThemeData _themeData;

  Brightness _brightness;
  bool _platformOverride;

  static const String _sharedPreferencesBrightnessKey = 'isDark';
  static const String _sharedPreferencesPlatformKey = 'platformOverride';

  /// Get the current `ThemeData`
  ThemeData get themeData => _themeData;

  /// Get the current `Brightness`
  Brightness get brightness => _brightness;

  /// Get the current `platformOverride`
  bool get platformOverride => _platformOverride;

  @override
  void initState() {
    super.initState();
    _initVariables();
    _load();
  }

  /// Loads the brightness depending on the `loadBrightnessOnStart` value
  Future<void> _load() async {
    final bool isDark = await _getBrightnessBool();
    _platformOverride = await _getPlatformBool();
    _brightness = isDark ? Brightness.dark : Brightness.light;
    _themeData = widget.data(_brightness, _platformOverride);
    if (mounted) {
      setState(() {});
    }
  }

  /// Initializes the variables
  void _initVariables() {
    _brightness = widget.defaultBrightness;
    _platformOverride = false;
    _themeData = widget.data(_brightness, _platformOverride);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeData = widget.data(_brightness, _platformOverride);
  }

  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.data(_brightness, _platformOverride);
  }

  /// Sets the new brightness
  /// Rebuilds the tree
  Future<void> setBrightness(Brightness brightness) async {
    // Update state with new values
    setState(() {
      _themeData = widget.data(brightness, _platformOverride);
      _brightness = brightness;
    });
    // Save the brightness
    await _saveBrightness();
  }

  /// Sets the new platformOverride
  /// Rebuilds the tree
  Future<void> setPlatformOverride(bool platformOverride) async {
    // Update state with new values
    setState(() {
      _themeData = widget.data(_brightness, platformOverride);
      _platformOverride = platformOverride;
    });
    // Save the brightness
    await _savePlatformOverride();
  }

  /// Saves the provided brightness in `SharedPreferences`
  Future<void> _saveBrightness() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Saves whether or not the provided brightness is dark
    await prefs.setBool(
        _sharedPreferencesBrightnessKey, _brightness == Brightness.dark ? true : false);
  }

  /// Saves the provided platformOverride in `SharedPreferences`
  Future<void> _savePlatformOverride() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Saves whether or not the provided brightness is dark
    await prefs.setBool(_sharedPreferencesPlatformKey, _platformOverride);
  }

  /// Returns a boolean that gives you the latest brightness
  Future<bool> _getBrightnessBool() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Gets the bool stored in prefs
    // Or returns whether or not the `defaultBrightness` is dark
    return prefs.getBool(_sharedPreferencesBrightnessKey) ??
        widget.defaultBrightness == Brightness.dark;
  }

  /// Returns a boolean whether to override the platform
  Future<bool> _getPlatformBool() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sharedPreferencesPlatformKey) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _themeData);
  }
}
