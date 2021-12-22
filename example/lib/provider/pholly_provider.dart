import 'package:flutter/material.dart';
import 'package:phyllo_connect/phyllo_connect.dart';
import 'package:phyllo_connect_example/client/phyllo_repository.dart';
import 'package:phyllo_connect_example/models/phyllo_args.dart';
import 'package:phyllo_connect_example/provider/default_change_notifier.dart';

class PhylloProvider extends DefaultChangeNotifier {
  //
  final PhylloRepository _phylloRepository = PhylloRepository.instance;
  //
  void launchPhylloConnectSdk(PhylloArgs args) async {
    try {
      setLoading(true);

      String? phylloEnvUrl = await getPhylloEnvironmentUrl(args.environment);

      if (phylloEnvUrl != null) {
        // Get UserId
        String? userId = await _phylloRepository.getUserId(phylloEnvUrl, args);

        if (userId != null) {
          // Get Sdk Token
          String? sdkToken = await _phylloRepository
              .getSdkToken(phylloEnvUrl, args, userId: userId);

          if (sdkToken != null) {
            PhylloConfig config = PhylloConfig(
              appName: args.appName,
              platformId: args.platformId,
              userId: userId,
              sdkToken: 'Bearer $sdkToken',
              environment: args.environment,
            );

            PhylloConnect.launchPhylloConnectSdk(config);
          }
        }
      }
    } finally {
      setLoading(false);
    }
  }

  Future<String?> getPhylloEnvironmentUrl(PhylloEnvironment environment) async {
    try {
      String? env = await PhylloConnect.getPhylloEnvironmentUrl(environment);
      return env!;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
