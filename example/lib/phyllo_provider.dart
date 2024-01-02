// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phyllo_connect/phyllo_connect.dart';
import 'package:phyllo_connect_example/client/phyllo_repository.dart';
import 'package:phyllo_connect_example/constants/configs.dart';

abstract class DefaultChangeNotifier extends ChangeNotifier {
  bool _loading = false;

  void setLoading(bool state) {
    _loading = state;
    notify();
  }

  void notify() {
    notifyListeners();
  }

  bool get isLoading => _loading;
}

class PhylloProvider extends DefaultChangeNotifier {
  bool _isExistingUser = false;
  static const String clientDisplayName = 'Phyllo Test';
  static String? _token;
  static String? _userId;

  final PhylloConnect _phylloConnect = PhylloConnect.instance;
  final PhylloRepository _phylloRepository = PhylloRepository.instance;
  //
  void launchSdk(String workPlatformId) async {
    try {
      setLoading(true);

      String? env = await getPhylloEnvironmentUrl(Configs.environment);

      if (env != null) {
        if (_isExistingUser) {
          _token = await getSdkToken(env, userId!);
          if (_token != null) {
            _launchSdk(workPlatformId);
          }
        } else {
          // Get UserId
          _userId = await getUserId(env);
          if (_userId != null) {
            // Get Token
            _token = await getSdkToken(env, _userId!);
            if (_token != null) {
              _launchSdk(workPlatformId);
            }
          }
        }
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> _launchSdk(String workPlatformId) async {
    Map<String, dynamic> config = {
      'clientDisplayName': clientDisplayName,
      'environment': Configs.environment.name,
      'userId': _userId!,
      'token': _token!,
      'workPlatformId': workPlatformId
    };

   await _phylloConnect.initialize(config);
    _phylloConnect.open();

    _phylloConnect.onConnectCallback(
      onAccountConnected: (account_id, work_platform_id, user_id) {
        log('onAccountConnected: $account_id, $work_platform_id, $user_id');
      },
      onAccountDisconnected: (account_id, work_platform_id, user_id) {
        log('onAccountDisconnected: $account_id, $work_platform_id, $user_id');
      },
      onTokenExpired: (user_id) {
        log('onTokenExpired: $user_id');
      },
      onExit: (reason, user_id) {
        log('onExit: $reason, $user_id');
      },
      // [Optional callback] onConnectionFailure : User can now add a new callback connectionFailure for tracking the reason of accounts not getting connected.
      onConnectionFailure: (reason, work_platform_id, user_id) {
        log('onConnectionFailure: $reason, $work_platform_id, $user_id');
      },
    );

    //get supported version details
    log('version: ${_phylloConnect.version()}');

  }

  Future<String?> getPhylloEnvironmentUrl(PhylloEnvironment environment) async {
    try {
      String? env = await _phylloConnect.getPhylloEnvironmentUrl(environment);
      return env!;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> getUserId(String envUrl) async {
    try {
      setLoading(true);
      String? userId = await _phylloRepository.getUserId(envUrl);
      return userId;
    } finally {
      setLoading(false);
    }
  }

  Future<String?> getSdkToken(String envUrl, String userId) async {
    try {
      setLoading(true);
      String? token =
          await _phylloRepository.getSdkToken(envUrl, userId: userId);
      return token;
    } finally {
      setLoading(false);
    }
  }

  void isExistingUserStatusChanged(bool? value) {
    _isExistingUser = value!;
    notify();
  }

  bool get isExistingUser => _isExistingUser;

  String? get userId => _userId;
}
