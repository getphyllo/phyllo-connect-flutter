import 'dart:async';

import 'package:flutter/services.dart';
import 'package:phyllo_connect/src/configs/configs.dart';
import 'package:phyllo_connect/src/models/phyllo_config.dart';

import 'src/client/phyllo_repository.dart';
import 'src/models/phyllo_args.dart';

export 'src/configs/configs.dart';

export 'src/models/phyllo_args.dart';

class PhylloConnect {
  PhylloConnect._(this._args);

  final PhylloArgs? _args;

  final MethodChannel _channel = const MethodChannel('phyllo_connect');

  final PhylloRepository _phylloRepository = PhylloRepository.instance;

  /// Get [PhylloConnect] Instance
  static PhylloConnect getInstance(PhylloArgs? args) {
    return PhylloConnect._(args);
  }

  Future<void> launchPhylloConnectSdk() async {
    if (_args != null) {
      String? phylloEnvUrl = await _getPhylloEnvironmentUrl(_args!.environment);

        // Get UserId
      String? userId = await _phylloRepository.getUserId(phylloEnvUrl!, _args!);
        if (userId != null) {
          // Get Sdk Token
        String? sdkToken = await _phylloRepository.getSdkToken(phylloEnvUrl, _args! userId: userId);
          if (sdkToken != null) {
            PhylloConfig config = PhylloConfig(
              appName: _args!.appName,
              platformId: _args!.platformId,
              userId: userId,
              sdkToken: sdkToken,
              environment: _args!.environment,
            );
            _launchPhylloConnectSdk(config);
          }
        }
    } else {
      throw Exception('PhylloConnect is not initialized');
    }
  }

  /// Get Environment baseUrl on [PhylloEnvironment] type
  Future<String?> _getPhylloEnvironmentUrl(PhylloEnvironment env) async {
    Map<String, dynamic> args = {'type': env.name};
    final String? envUrl =
    await _channel.invokeMethod('getPhylloEnvironmentUrl', args);
    return envUrl;
  }

  /// Launch PhylloConnect SDK with [PhylloConfig] arguments
   Future<void> _launchPhylloConnectSdk(PhylloConfig config) async {
    await _channel.invokeMethod('launchPhylloConnectSdk', config.toArgs());
  }
}
