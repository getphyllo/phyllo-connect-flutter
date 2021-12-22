enum PhylloEnvironment { development, sandbox, prod }

extension PhylloEnvironmentExtension on PhylloEnvironment {
  String get name {
    return toString().split('.').last;
  }
}
