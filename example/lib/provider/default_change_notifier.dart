import 'package:flutter/material.dart';

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
