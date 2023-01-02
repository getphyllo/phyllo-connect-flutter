# phyllo_connect

[![pub package](https://img.shields.io/pub/v/phyllo_connect.svg)](https://pub.dev/packages/phyllo_connect)

Phyllo Connect is a quick and secure way to connect work platforms via Phyllo in your app.
Supports:
iOS, Android.

## Usage

To use this plugin, add `phyllo_connect` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

Replace your

```dart
import 'package:phyllo_connect/phyllo_connect.dart';

class Configs {
  Configs._();

  static const String clientId = '<client id here>';

  static const String clientSecret = '<client secret here>';

  static const PhylloEnvironment env = PhylloEnvironment.sanbox; //set phyllo environment
}
```

-> Lib -> phyllo_provider.dart

```dart

import 'package:flutter/material.dart';
import 'package:phyllo_connect/phyllo_connect.dart';
import 'package:phyllo_connect_example/client/phyllo_repository.dart';
import 'package:phyllo_connect_example/constants/configs.dart';

final PhylloConnect _phylloConnect = PhylloConnect.instance;
//Too Lunch the sdk here it will method
void _launchSdk(String workPlatformId) {

  Map<String, dynamic> config = {
      'clientDisplayName': clientDisplayName,
      'environment': Configs.environment.name,
      'userId': _userId!,
      'token': _token!,
      'workPlatformId': workPlatformId
    };

    _phylloConnect.initialize(config);
    _phylloConnect.open();
    
    //Call Back from Android/iOS SDK
    _phylloConnect.onConnectCallback(
        onAccountConnected: (account_id, work_platform_id, user_id) {
      log('onAccountConnected: $account_id, $work_platform_id, $user_id');
    }, onAccountDisconnected: (account_id, work_platform_id, user_id) {
      log('onAccountDisconnected: $account_id, $work_platform_id, $user_id');
    }, onTokenExpired: (user_id) {
      log('onTokenExpired: $user_id');
    }, onExit: (reason, user_id) {
      log('onExit: $reason, $user_id');
    },
     // [Optional callback] onConnectionFailure : User can now add a new callback connectionFailure for tracking the reason of accounts not getting connected.
        onConnectionFailure: (reason, work_platform_id, user_id) {
      log('onConnectionFailure: $reason, $work_platform_id, $user_id');
    );

    log('version: ${_phylloConnect.version()}');
    
  }

```
