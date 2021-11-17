class UtcDateTime extends DateTime {
  UtcDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : super.utc(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );

  factory UtcDateTime.parse(String date) {
    final normalDate = DateTime.parse(date);
    return UtcDateTime.makeUtc(normalDate);
  }

  static UtcDateTime? tryParse(String date) {
    final normalDate = DateTime.tryParse(date);
    if (normalDate == null) {
      return null;
    }
    return UtcDateTime.makeUtc(normalDate);
  }

  factory UtcDateTime.makeUtc(DateTime date) {
    return UtcDateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }
  factory UtcDateTime.now() {
    return UtcDateTime.makeUtc(DateTime.now());
  }

  @override
  UtcDateTime subtract(Duration duration) {
    return super.subtract(duration).makeUtc();
  }

  @override
  UtcDateTime add(Duration duration) {
    return super.add(duration).makeUtc();
  }
}

extension MakeUtc on DateTime {
  UtcDateTime makeUtc() {
    return UtcDateTime.makeUtc(this);
  }
}
