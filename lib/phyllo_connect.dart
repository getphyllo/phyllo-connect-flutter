import 'dart:async';

import 'package:flutter/services.dart';
import 'src/enum.dart';
import 'src/phyllo_config.dart';

export 'src/enum.dart';
export 'src/phyllo_config.dart';

class PhylloConnect {
  PhylloConnect._();

  static const MethodChannel _channel = MethodChannel('phyllo_connect');

  /// Get [Environment] baseUrl on [PhylloEnvironment] type
  ///
  static Future<String?> getPhylloEnvironmentUrl(
      PhylloEnvironment environment) async {
    Map<String, dynamic> args = {'type': environment.name};
    final String? envUrl =
        await _channel.invokeMethod('getPhylloEnvironmentUrl', args);
    return envUrl;
  }

  /// Initialize [PhylloConnect] SDK with [PhylloConfig] arguments
  ///
  static Future<void> initialize(PhylloConfig config) async {
    await _channel.invokeMethod('initialize', config.toArgs());
  }

  /// Open [PhylloConnect] SDK
  ///
  static Future<void> open() async {
    await _channel.invokeMethod('open');
  }

  /// [PhylloConnect] ConnectCallback
  ///
  static void onPhylloConnectCallback({
    Function(String, String, String)? onAccountConnected,
    Function(String, String, String)? onAccountDisconnected,
    Function(String)? onTokenExpried,
    Function(String, String)? onExit,
  }) async {
    _channel.setMethodCallHandler((methodCall) async {
      switch (methodCall.method) {
        case 'onAccountConnected':
          Map<String, dynamic> arguments = methodCall.arguments;
          onAccountConnected?.call(
            arguments['accountId'],
            arguments['platformId'],
            arguments['userId'],
          );
          break;
        case 'onAccountDisconnected':
          Map<String, dynamic> arguments = methodCall.arguments;
          onAccountDisconnected?.call(
            arguments['accountId'],
            arguments['platformId'],
            arguments['userId'],
          );
          break;
        case 'onTokenExpired':
          String argument = methodCall.arguments;
          onTokenExpried?.call(argument);
          break;
        case 'onExit':
          Map<String, dynamic> arguments = methodCall.arguments;
          onExit?.call(arguments['reason'], arguments['userId']);
          break;
        default:
      }
    });
  }
}
