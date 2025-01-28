import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'phyllo_connect_method_channel.dart';

abstract class PhylloConnectPlatform extends PlatformInterface {
  /// Constructs a PhylloConnectPlatform.
  PhylloConnectPlatform() : super(token: _token);

  static final Object _token = Object();

  static PhylloConnectPlatform _instance = MethodChannelPhylloConnect();

  /// The default instance of [PhylloConnectPlatform] to use.
  ///
  /// Defaults to [MethodChannelPhylloConnect].
  static PhylloConnectPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PhylloConnectPlatform] when
  /// they register themselves.
  static set instance(PhylloConnectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
