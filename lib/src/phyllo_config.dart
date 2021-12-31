import 'enum.dart';

class PhylloConfig {
  final PhylloEnvironment environment;
  final String clientDisplayName;
  final String userId;
  final String token;
  final String? workPlatformId;

  PhylloConfig({
    required this.environment,
    required this.clientDisplayName,
    required this.userId,
    required this.token,
    this.workPlatformId,
  });

  Map<String, dynamic> toArgs() {
    return {
      'clientDisplayName': clientDisplayName,
      'userId': userId,
      'token': token,
      'workPlatformId': workPlatformId,
      'environment': environment.name,
    };
  }

  @override
  String toString() {
    return 'PhylloConfig {environment: $environment, clientDisplayName: $clientDisplayName, userId: $userId, token: $token, workPlatformId: $workPlatformId}';
  }
}
