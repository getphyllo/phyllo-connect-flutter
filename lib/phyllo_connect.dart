import 'dart:async';

import 'package:flutter/services.dart';
import 'src/enum.dart';
import 'src/phyllo_config.dart';

export 'src/enum.dart';
export 'src/phyllo_config.dart';

/// Phyllo is a data gateway to creator economy platforms.
/// Using Phyllo, your users can grant access to their data within your own app.
/// Once granted, you can fetch details of a creator's identity, income, and their activity on platforms (like Instagram, Youtube, Substack) using our REST APIs.
///
/// Phyllo Connect is a quick and secure way to connect work platforms via Phyllo in your Flutter-based mobile apps.
/// The SDK manages work platform authentication (credential validation, multi-factor authentication, error handling, etc).
///
/// To start integration with the SDK, clone the GitHub repository (see `https://github.com/getphyllo/phyllo-connect-flutter`).
/// It has a sample application, which provides a reference implementation.
/// Please reach out at `contact@getphyllo.com` for access to your API keys and secrets.

class PhylloConnect {
  // This class is not meant to be instantiated or extended; this constructor
  PhylloConnect._();

  static PhylloConnect get instance => PhylloConnect._();

  final MethodChannel _channel = const MethodChannel('phyllo_connect');

  final EventChannel _eventChannel =
      const EventChannel('phyllo_connects/connect_callback');

  /// To get started, you will require the API keys and secrets to access the Phyllo environment.
  /// In order to obtain the credentials, you can reach out to `contact@getphyllo.com`

  /// Get [Environment] baseUrl on [PhylloEnvironment] type
  ///
  Future<String?> getPhylloEnvironmentUrl(PhylloEnvironment environment) async {
    Map<String, dynamic> args = <String, dynamic>{'type': environment.name};
    final String? envUrl =
        await _channel.invokeMethod('getPhylloEnvironmentUrl', args);
    return envUrl;
  }

  /// Before you initialize SDK, you need to first create an SDK token.
  /// The token can be configured to customize Connect flow. To see how to create a new SDK token, see the API Reference entry for sdk-tokens.
  ///
  Future<void> initialize(PhylloConfig config) async {
    await _channel.invokeMethod('initialize', config.toMap());
  }

  /// After initialization, the Phyllo Connect flow can simply be invoked on any screen.
  /// On successful account connection, you will get notified via webhook.
  /// Please read more about webhooks here (see `https://docs.getphyllo.com/docs/api-reference/ZG9jOjc4MzExNjg-phyllo-webhooks-guide`) and set them up accordingly.
  ///
  Future<void> open() async {
    await _channel.invokeMethod('open');
  }

  void onAccountConnected(Function(String, String, String) callback) {
    _eventChannel.receiveBroadcastStream('onAccountConnected').listen((event) {
      callback.call(
        event['account_id'],
        event['work_platform_id'],
        event['user_id'],
      );
    }, cancelOnError: true);
  }

  void onAccountDisconnected(Function(String, String, String) callback) {
    _eventChannel.receiveBroadcastStream('onAccountDisconnected').listen(
        (event) {
      callback.call(
        event['account_id'],
        event['work_platform_id'],
        event['user_id'],
      );
    }, cancelOnError: true);
  }

  void onToeknExpired(Function(String) callback) {
    _eventChannel.receiveBroadcastStream('onToeknExpired').listen((event) {
      callback.call(event['user_id']);
    }, cancelOnError: true);
  }

  void onExit(Function(String, String) callback) {
    _eventChannel.receiveBroadcastStream('onExit').listen((event) {
      callback.call(event['reason'], event['user_id']);
    }, cancelOnError: true);
  }
}
