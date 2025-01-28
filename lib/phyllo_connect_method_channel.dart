import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'phyllo_connect_platform_interface.dart';

/// An implementation of [PhylloConnectPlatform] that uses method channels.
class MethodChannelPhylloConnect extends PhylloConnectPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('phyllo_connect');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
