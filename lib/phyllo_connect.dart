import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:phyllo_connect/src/verison_constants.dart';
import 'src/enum.dart';

export 'src/enum.dart';

typedef AccountConnectedCallback = void Function(String?, String?, String?);

typedef AccountDisconnectedCallback = void Function(String?, String?, String?);

typedef TokenExpiredCallback = void Function(String?);

typedef ExitCallback = void Function(String?, String?);

typedef ConnectionFailureCallback = void Function(String?, String?, String?);

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

  final MethodChannel _channel = const MethodChannel('phyllo_connect')
    ..setMethodCallHandler(_nativeCallHandler);

  static AccountConnectedCallback? _onAccountConnected;
  static AccountDisconnectedCallback? _onAccountDisconnected;
  static TokenExpiredCallback? _onTokenExpired;
  static ExitCallback? _onExit;
  static ConnectionFailureCallback? _onConnectionFailure;

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
  Future<void> initialize(Map<String, dynamic> config) async {
    return await _channel.invokeMethod('initialize', config);
  }

  /// After initialization, the Phyllo Connect flow can simply be invoked on any screen.
  /// On successful account connection, you will get notified via webhook.
  /// Please read more about webhooks here (see `https://docs.getphyllo.com/docs/api-reference/ZG9jOjc4MzExNjg-phyllo-webhooks-guide`) and set them up accordingly.
  ///
  Future<void> open() async {
    await _channel.invokeMethod('open');
  }

  Map<String, String> version() {
    return <String, String>{
      'connect_flutter_sdk_version': VersionConstants.flutterSdkVersion,
      'connect_android_sdk_version': VersionConstants.androidSdkVersion,
      'min_supported_android_version':
          VersionConstants.minSupportedAndroidVersion,
      'max_supported_android_version':
          VersionConstants.maxSupportedAndroidVersion,
      'connect_ios_sdk_version': VersionConstants.iosSdkVersion,
      'min_supported_ios_version': VersionConstants.minSupportedIosVersion,
      'max_supported_ios_version': VersionConstants.maxSupportedIosVersion,
    };
  }

  void onConnectCallback({
    /// `onAccountConnected` is called when the user has successfully connected to the platform.
    ///
    required AccountConnectedCallback onAccountConnected,

    /// `onAccountDisconnected` is called when the user has disconnected from the platform.
    ///
    required AccountDisconnectedCallback onAccountDisconnected,

    /// `onTokenExpired` is called when the token has expired.
    ///
    required TokenExpiredCallback onTokenExpired,

    /// `onExit` is called when the user has exited the Phyllo Connect flow.
    ///
    required ExitCallback onExit,

    /// [Optional] `onConnectionFailure` : User can now add a new callback connectionFailure for tracking the reason of accounts not getting connected
    ///
    ConnectionFailureCallback? onConnectionFailure,
  }) {
    _onAccountConnected = onAccountConnected;
    _onAccountDisconnected = onAccountDisconnected;
    _onTokenExpired = onTokenExpired;
    _onExit = onExit;
    _onConnectionFailure = onConnectionFailure;
  }

  static Future<dynamic> _nativeCallHandler(MethodCall call) async {
    try {
      Map<String, dynamic> arguments =
          Map<String, dynamic>.from(call.arguments);
      switch (call.method) {
        case 'onAccountConnected':
          if (_onAccountConnected != null) {
            _onAccountConnected!(
              arguments['account_id'],
              arguments['work_platform_id'],
              arguments['user_id'],
            );
          }

          break;
        case 'onAccountDisconnected':
          if (_onAccountDisconnected != null) {
            _onAccountDisconnected!(
              arguments['account_id'],
              arguments['work_platform_id'],
              arguments['user_id'],
            );
          }
          break;
        case 'onTokenExpired':
          if (_onTokenExpired != null) {
            _onTokenExpired!(arguments['user_id']);
          }

          break;
        case 'onExit':
          if (_onExit != null) {
            _onExit!(arguments['reason'], arguments['user_id']);
          }
          break;
        case 'onConnectionFailure':
          if (_onConnectionFailure != null) {
            _onConnectionFailure!(
              arguments['reason'],
              arguments['work_platform_id'],
              arguments['user_id'],
            );
          }
          break;
        default:
          throw Exception('unknown method called from native');
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
    return false;
  }
}
