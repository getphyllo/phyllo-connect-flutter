import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:phyllo_connect_example/client/result.dart';
import 'package:phyllo_connect_example/constants/configs.dart';

enum RequestType { post, get }

class Http {
  final Client _client;

  Http() : _client = Client();

  Future<Result> request({
    required RequestType? requestType,
    required String url,
    dynamic body,
  }) async {
    Uri uri = Uri.parse(url);

    // Basic auth
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('${Configs.clientId}:${Configs.clientSecret}'))}';

    log('$url ==> $body', name: 'REQUEST');

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': basicAuth,
      };

      switch (requestType) {

        // Send a POST request with the given parameter.
        case RequestType.post:
          final Response response = await _client.post(uri,
              body: json.encode(body), headers: headers);

          if (response.statusCode == 200 || response.statusCode == 201) {
            Result result = Result.success(json.decode(response.body));
            return result;
          } else {
            return Result.error(_exception);
          }

        // Send a GET request with the given parameter.
        case RequestType.get:
          final Response response = await _client.get(uri, headers: headers);

          if (response.statusCode == 200 || response.statusCode == 201) {
            Result result = Result.success(json.decode(response.body));
            return result;
          } else {
            return Result.error(_exception);
          }

        default:
          return Result.error(_requestTypeNotFoundException);
      }
    } on SocketException {
      return Result.error(_socketException);
    } on FormatException {
      return Result.error(_formatException);
    } on HttpException {
      return Result.error(_httpException);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // Exception messages
  final String _exception =
      'Something went wrong! Please try again in a moment!';

  final String _socketException =
      'Unable to reach the internet! Please try again in a moment.';

  final String _formatException = 'Invalid Request';

  final String _httpException =
      'Invalid data received from the server! Please try again in a moment.';

  final String _requestTypeNotFoundException =
      'The HTTP request mentioned is not found';
}
