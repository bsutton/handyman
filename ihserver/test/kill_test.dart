import 'package:test/test.dart';

import '../tool/deploy.dart';

void main() {
  test('kill process', () {
    killProcess('ihlaunch.sh');
    killProcess('dart:ihlaunch');
    killProcess('dart:ihserver.d');
  });
}
