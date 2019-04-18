import 'package:flutter_test/flutter_test.dart';
import '../lib/ui/calendar.dart';

main() {
  test('to monday; page of', () {
    print(DateTime.parse("2019-04-15"));
    expect(pageOf(mondayOf(124564)), 124564);
    final date = DateTime.utc(2019,4,15);
    expect(mondayOf(pageOf(date)), date);
  });
}