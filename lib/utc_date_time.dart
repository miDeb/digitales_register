class UtcDateTime extends DateTime {
  UtcDateTime(
    super.year, [
    super.month,
    super.day,
    super.hour,
    super.minute,
    super.second,
    super.millisecond,
    super.microsecond,
  ]) : super.utc();

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

  UtcDateTime stripTime() {
    return UtcDateTime(
      year,
      month,
      day,
    );
  }
}

extension MakeUtc on DateTime {
  UtcDateTime makeUtc() {
    return UtcDateTime.makeUtc(this);
  }
}
