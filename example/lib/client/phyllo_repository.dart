import 'dart:developer';

import 'package:phyllo_connect_example/client/http.dart';
import 'package:phyllo_connect_example/client/result.dart';
import 'package:phyllo_connect_example/constants/generate_radom_string.dart';

class PhylloRepository {
  PhylloRepository._();

  static final PhylloRepository instance = PhylloRepository._();

  final Http _http = Http();

  Future<String?> getUserId(String env) async {
    Result result = await _http.request(
      requestType: RequestType.post,
      url: '$env/v1/users',
      body: {'name': getRadomString(8), 'external_id': getRadomString(20)},
    );
    if (result is Success) {
      return result.value['id'];
    } else {
      log((result as Error).message, name: 'getUserId');
      return null;
    }
  }

  Future<String?> getSdkToken(String env, {required String userId}) async {
    Result result = await _http.request(
      requestType: RequestType.post,
      url: '$env/v1/sdk-tokens',
      body: {
        'user_id': userId,
        'products': ['IDENTITY', 'ENGAGEMENT', 'INCOME'],
      },
    );
    if (result is Success) {
      return result.value['sdk_token'];
    } else {
      log((result as Error).message, name: 'getSdkToken');
      return null;
    }
  }
}
