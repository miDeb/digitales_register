import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel = const MethodChannel('flutter_ping');

Future<String> ping(String url) async {
  final Map<String, dynamic> params = <String, dynamic>{
    'url': url,
  };
  final String result = await _channel.invokeMethod('pingURL', params);
  return result;
}
