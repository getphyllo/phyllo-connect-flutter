import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:phyllo_connect/phyllo_connect.dart';
import 'package:http/http.dart';
import 'package:phyllo_connect/src/client/result.dart';

class Http {
  final Client _client;

  Http() : _client = Client();

  Future<Result> request({
    required RequestType? requestType,
    required String url,
    dynamic body,
    required PhylloArgs args,
  }) async {
    Uri uri = Uri.parse(url);

    // Basic auth
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('${args.clientId}:${args.clientSecret}'))}';

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

          log('${response.statusCode} ${response.request} ${response.body}',
              name: 'PhylloConnect');

          if (response.statusCode == 200 || response.statusCode == 201) {
            Result result = Result.success(json.decode(response.body));
            return result;
          } else {
            return Result.error(_exception);
          }

        // Send a GET request with the given parameter.
        case RequestType.get:
          final Response response = await _client.get(uri, headers: headers);

          log('${response.statusCode} ${response.request} ${response.body}',
              name: 'PhylloConnect');

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
