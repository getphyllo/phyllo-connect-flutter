// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phyllo_connect/phyllo_connect.dart';
import 'package:phyllo_connect_example/client/phyllo_repository.dart';
import 'package:phyllo_connect_example/constants/environment.dart';

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
  Environment _phylloEnvironment = Environment.sandbox;

  final PhylloConnect _phylloConnect = PhylloConnect.instance;
  final PhylloRepository _phylloRepository = PhylloRepository.instance;
  //
  void launchSdk(String workPlatformId) async {
    try {
      setLoading(true);

      String? env =
          await getPhylloEnvironmentUrl(_phylloEnvironment.environment);

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

  void _launchSdk(String workPlatformId) {
    PhylloConfig config = PhylloConfig(
      clientDisplayName: clientDisplayName,
      environment: _phylloEnvironment.environment,
      userId: _userId!,
      token: _token!,
      workPlatformId: workPlatformId,
    );
    _phylloConnect.initialize(config);
    _phylloConnect.open();

    _phylloConnect.onConnectCallback(
      onAccountConnected: (account_id, work_platform_id, user_id) {
        _showToast(
            'onAccountConnected: $account_id, $work_platform_id, $user_id');
      },
      onAccountDisconnected: (account_id, work_platform_id, user_id) {
        _showToast(
            'onAccountDisconnected: $account_id, $work_platform_id, $user_id');
      },
      onTokenExpired: (user_id) {
        _showToast('onTokenExpired: $user_id');
      },
      onExit: (reason, user_id) {
        _showToast('onExit: $reason, $user_id');
      },
      // [Optional callback] onConnectionFailure : User can now add a new callback connectionFailure for tracking the reason of accounts not getting connected.
      onConnectionFailure: (reason, user_id, work_platform_id) {
        _showToast(
            'onConnectionFailure: $reason, $user_id , $work_platform_id');
      },
    );
  }

  void _showToast(String msg) async {
    log(msg);

    await Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 16,
      textColor: Colors.white,
      backgroundColor: Colors.black,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
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
      String? userId = await _phylloRepository.getUserId(envUrl,
          environment: _phylloEnvironment);
      return userId;
    } finally {
      setLoading(false);
    }
  }

  Future<String?> getSdkToken(String envUrl, String userId) async {
    try {
      setLoading(true);
      String? token = await _phylloRepository.getSdkToken(envUrl,
          userId: userId, environment: _phylloEnvironment);
      return token;
    } finally {
      setLoading(false);
    }
  }

  void isExistingUserStatusChanged(bool? value) {
    _isExistingUser = value!;
    notify();
  }

  void onChangedEnvironment(Environment? value) {
    if (value != null) {
      if (_phylloEnvironment.environment != value.environment) {
        _phylloEnvironment = value;
        _showToast(
            'Environment changed to ${value.environment.name.toUpperCase()}');
        _phylloEnvironment = value;
        _isExistingUser = false;
        _token = null;
        _userId = null;
        notify();
      }
    }
  }

  bool get isExistingUser => _isExistingUser;

  String? get userId => _userId;

  Environment get phylloEnvironment => _phylloEnvironment;
}
