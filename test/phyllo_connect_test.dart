import 'package:flutter_test/flutter_test.dart';
import 'package:phyllo_connect/phyllo_connect.dart';
import 'package:phyllo_connect/phyllo_connect_platform_interface.dart';
import 'package:phyllo_connect/phyllo_connect_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPhylloConnectPlatform
    with MockPlatformInterfaceMixin
    implements PhylloConnectPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PhylloConnectPlatform initialPlatform = PhylloConnectPlatform.instance;

  test('$MethodChannelPhylloConnect is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPhylloConnect>());
  });

  test('getPlatformVersion', () async {
    PhylloConnect phylloConnectPlugin = PhylloConnect();
    MockPhylloConnectPlatform fakePlatform = MockPhylloConnectPlatform();
    PhylloConnectPlatform.instance = fakePlatform;

    expect(await phylloConnectPlugin.getPlatformVersion(), '42');
  });
}
