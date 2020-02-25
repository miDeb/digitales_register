import 'package:flutter_test/flutter_test.dart';
import '../lib/ui/calendar.dart';

main() {
  test('to monday; page of', () {
    expect(pageOf(mondayOf(124564)), 124564);
    final date = DateTime.utc(2019, 4, 15);
    expect(mondayOf(pageOf(date)), date);
  });
}
