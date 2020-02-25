import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef ThemedWidgetBuilder = Widget Function(
    BuildContext context, ThemeData data);

typedef ThemeDataBuilder = ThemeData Function(
    Brightness brightness, bool platformOverride);

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

class DynamicThemeState extends State<DynamicTheme>
    with WidgetsBindingObserver {
  ThemeData _themeData;

  Brightness _brightness;
  Brightness _deviceBrightness;
  bool _followDevice;
  bool _platformOverride;

  static const String _sharedPreferencesBrightnessKey = 'isDark';
  static const String _sharedPreferencesFollowDeviceKey = 'followDeviceTheme';
  static const String _sharedPreferencesPlatformKey = 'platformOverride';

  /// Get the current `ThemeData`
  ThemeData get themeData => _themeData;

  /// Get the current `Brightness`
  Brightness get brightness => _followDevice ? _deviceBrightness : _brightness;

  /// Get the custom set `Brightness`
  ///
  /// If [followDevice] is true, this might not be the same as [brightness]
  Brightness get customBrightness => _brightness;

  /// Get the current `followDevice`
  bool get followDevice => _followDevice;

  /// Get the current `platformOverride`
  bool get platformOverride => _platformOverride;

  Brightness _getDeviceBrightness() {
    return WidgetsBinding.instance.window.platformBrightness;
  }

  @override
  void initState() {
    super.initState();
    _initVariables();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  /// Loads the brightness depending on the `loadBrightnessOnStart` value
  Future<void> _load() async {
    final bool isDark = await _getBrightnessBool();
    _platformOverride = await _getPlatformBool();
    _followDevice = await _getFollowDeviceBool();
    _brightness = isDark ? Brightness.dark : Brightness.light;
    _themeData = widget.data(brightness, _platformOverride);
    if (mounted) {
      setState(() {});
    }
  }

  /// Initializes the variables
  void _initVariables() {
    _deviceBrightness = _getDeviceBrightness();
    _brightness = widget.defaultBrightness;
    _platformOverride = false;
    _followDevice = true;
    _themeData = widget.data(brightness, _platformOverride);
  }

  @override
  void didChangePlatformBrightness() {
    _deviceBrightness = _getDeviceBrightness();
    if (followDevice) {
      setState(() {
        _themeData = widget.data(brightness, _platformOverride);
      });
    }
    super.didChangePlatformBrightness();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeData = widget.data(brightness, _platformOverride);
  }

  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.data(brightness, _platformOverride);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Sets the new brightness
  /// Rebuilds the tree
  Future<void> setBrightness(Brightness brightness) async {
    // Update state with new values
    setState(() {
      _brightness = brightness;
      _themeData = widget.data(this.brightness, _platformOverride);
    });
    // Save the brightness
    await _saveBrightness();
  }

  /// Sets the new brightness
  /// Rebuilds the tree
  Future<void> setFollowDevice(bool followOS) async {
    // Update state with new values
    setState(() {
      _followDevice = followOS;
      _themeData = widget.data(brightness, _platformOverride);
    });
    // Save
    await _saveFollowDevice();
  }

  /// Sets the new platformOverride
  /// Rebuilds the tree
  Future<void> setPlatformOverride(bool platformOverride) async {
    // Update state with new values
    setState(() {
      _themeData = widget.data(brightness, platformOverride);
      _platformOverride = platformOverride;
    });
    // Save
    await _savePlatformOverride();
  }

  /// Saves the provided brightness in `SharedPreferences`
  Future<void> _saveBrightness() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Saves whether or not the provided brightness is dark
    await prefs.setBool(_sharedPreferencesBrightnessKey,
        _brightness == Brightness.dark ? true : false);
  }

  /// Saves the provided followOS value in `SharedPreferences`
  Future<void> _saveFollowDevice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Saves whether or not the provided brightness is dark
    await prefs.setBool(_sharedPreferencesFollowDeviceKey, _followDevice);
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
  Future<bool> _getFollowDeviceBool() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sharedPreferencesFollowDeviceKey) ?? true;
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
