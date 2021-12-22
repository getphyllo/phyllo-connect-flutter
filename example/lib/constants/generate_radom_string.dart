import 'dart:math';

String getRadomString(int length, {bool isNumberic = false}) {
  String _chars = isNumberic
      ? '0123456789'
      : 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  return String.fromCharCodes(
    Iterable.generate(length, (_) {
      return _chars.codeUnitAt(_rnd.nextInt(_chars.length));
    }),
  );
}
