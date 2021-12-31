# phyllo_connect

[![pub package](https://img.shields.io/pub/v/phyllo_connect.svg)](https://pub.dev/packages/phyllo_connect)

Phyllo Connect is a quick and secure way to connect work platforms via Phyllo in your app. 
Supports:
iOS, Android.

## Usage

To use this plugin, add `phyllo_connect` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example
Replace your 

``` dart
import 'package:phyllo_connect/phyllo_connect.dart';

class Configs {
  Configs._();

  static const String clientId = '<client id here>';

  static const String clientSecret = '<client secret here>';

  static const PhylloEnvironment env = PhylloEnvironment.development; //set phyllo environment
}
```