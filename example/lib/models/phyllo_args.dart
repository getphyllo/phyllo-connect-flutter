import 'package:phyllo_connect/phyllo_connect.dart';

class PhylloArgs {
  String appName;
  String? platformId;
  String clientId;
  String clientSecret;
  PhylloEnvironment environment;

  PhylloArgs({
    required this.appName,
    required this.environment,
    required this.clientId,
    required this.clientSecret,
    this.platformId = '',
  });

  @override
  String toString() {
    return 'PhylloArgs{appName: $appName, platformId: $platformId, clientId: $clientId, clientSecret: $clientSecret, environment: $environment}';
  }
}
