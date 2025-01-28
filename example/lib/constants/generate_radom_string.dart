import 'dart:math';

String getRadomString(int length, {bool isNumberic = false}) {
  String chars = isNumberic
      ? '0123456789'
      : 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random rnd = Random();

  return String.fromCharCodes(
    Iterable.generate(length, (_) {
      return chars.codeUnitAt(rnd.nextInt(chars.length));
    }),
  );
}
