import 'package:phyllo_connect/phyllo_connect.dart';
import 'package:phyllo_connect_example/constants/configs.dart';

class Environment {
  final PhylloEnvironment environment;
  final String clientId;
  final String clientSecret;

  const Environment._({
    required this.environment,
    required this.clientId,
    required this.clientSecret,
  });

  static const Environment development = Environment._(
    environment: PhylloEnvironment.development,
    clientId: '<client id here>',
    clientSecret: '<client secret here>',
  );

  static const Environment sandbox = Environment._(
    environment: PhylloEnvironment.sandbox,
    clientId: Configs.clientId,
    clientSecret: Configs.clientSecret,
  );

  static const Environment production = Environment._(
    environment: PhylloEnvironment.production,
    clientId: '<client id here>',
    clientSecret: '<client secret here>',
  );

  static List<Environment> get values => [development, sandbox, production];
}
