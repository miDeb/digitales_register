import 'package:dr/ui/grade_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('as a precise value', () {
    expect(tryParseFormattedGrade("0"), 0);
    expect(tryParseFormattedGrade("000"), 0);
    expect(tryParseFormattedGrade("10"), 10 * 100);
    expect(tryParseFormattedGrade("8,5"), 8 * 100 + 50);
    expect(tryParseFormattedGrade("08,5"), 8 * 100 + 50);
    expect(tryParseFormattedGrade("8,50"), 8 * 100 + 50);
    expect(tryParseFormattedGrade("8.50"), 8 * 100 + 50);
    expect(tryParseFormattedGrade("8.0"), 8 * 100);
    expect(tryParseFormattedGrade("8.00"), 8 * 100);
    expect(tryParseFormattedGrade("8."), null);
    expect(tryParseFormattedGrade("8.000"), null);
    expect(tryParseFormattedGrade("80.50"), null);
    expect(tryParseFormattedGrade("asdf"), null);
    expect(tryParseFormattedGrade("-10"), null);
  });
  test('as less', () {
    expect(tryParseFormattedGrade("0-"), null);
    expect(tryParseFormattedGrade("5-"), 5 * 100 - 25);
    expect(tryParseFormattedGrade("10-"), 10 * 100 - 25);
    expect(tryParseFormattedGrade("11-"), null);
    expect(tryParseFormattedGrade("8--"), null);
  });
  test('as more', () {
    expect(tryParseFormattedGrade("0+"), 0 * 100 + 25);
    expect(tryParseFormattedGrade("5+"), 5 * 100 + 25);
    expect(tryParseFormattedGrade("10+"), null);
    expect(tryParseFormattedGrade("11+"), null);
    expect(tryParseFormattedGrade("+8+"), null);
  });
  test('as between', () {
    expect(tryParseFormattedGrade("-1-0"), null);
    expect(tryParseFormattedGrade("0-1"), 0 * 100 + 50);
    expect(tryParseFormattedGrade("0/1"), 0 * 100 + 50);
    expect(tryParseFormattedGrade("10/11"), null);
    expect(tryParseFormattedGrade("10/9"), null);
    expect(tryParseFormattedGrade("9/9.5"), null);
    expect(tryParseFormattedGrade("9/10"), 9 * 100 + 50);
    expect(tryParseFormattedGrade("9-10"), 9 * 100 + 50);
  });
}
