import 'enum.dart';

class PhylloConfig {
  final String appName;
  final String userId;
  final String sdkToken;
  final String? platformId;
  final PhylloEnvironment environment;

  PhylloConfig({
    required this.appName,
    required this.userId,
    required this.sdkToken,
    this.platformId = '',
    required this.environment,
  });

  Map<String, dynamic> toArgs() {
    return {
      'appName': appName,
      'userId': userId,
      'sdkToken': sdkToken,
      'platformId': platformId,
      'environment': environment.name,
    };
  }

  @override
  String toString() {
    return 'PhylloConfig{appName: $appName, userId: $userId, sdkToken: $sdkToken, platformId: $platformId, environment: $environment}';
  }
}
