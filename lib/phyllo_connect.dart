import 'dart:async';

import 'package:flutter/services.dart';
import 'src/enum.dart';
import 'src/phyllo_config.dart';

export 'src/enum.dart';
export 'src/phyllo_config.dart';

class PhylloConnect {
  PhylloConnect._();

  static const MethodChannel _channel = MethodChannel('phyllo_connect');

  /// Get Environment baseUrl on [PhylloEnvironment] type
  static Future<String?> getPhylloEnvironmentUrl(PhylloEnvironment environment) async {
    Map<String, dynamic> args = {'type': environment.name};
    final String? envUrl =
        await _channel.invokeMethod('getPhylloEnvironmentUrl', args);
    return envUrl;
  }

  /// Launch PhylloConnect SDK with [PhylloConfig] arguments
  static Future<void> initPhylloConnect(PhylloConfig config) async {
    await _channel.invokeMethod('initPhylloConnect', config.toArgs());
  }
}
