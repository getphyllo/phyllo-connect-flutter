part of 'configs.dart';

enum PhylloEnvironment { development, sandbox, prod }

enum RequestType { post, get }

extension PhylloEnvironmentExtension on PhylloEnvironment {
  String get name {
    return toString().split('.').last;
  }
}
