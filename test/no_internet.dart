import 'package:dr/wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('no internet detection', () async {
    print(await Wrapper().noInternet);
  });
}
