// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:dr/ui/calendar.dart';
import 'package:dr/utc_date_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('to monday; page of', () {
    expect(pageOf(mondayOf(124564)), 124564);
    final date = UtcDateTime(2019, 4, 15);
    expect(mondayOf(pageOf(date)), date);
  });
}
