import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'app_state.dart';
import 'util.dart';

part 'data.g.dart';

abstract class Day implements Built<Day, DayBuilder> {
  factory Day([void Function(DayBuilder) updates]) = _$Day;
  Day._();
  static Serializer<Day> get serializer => _$daySerializer;
  BuiltList<Homework> get homework;
  BuiltList<Homework> get deletedHomework;
  DateTime get date;
  String get displayName => format(date);
  bool get future => _isFuture(date);
  DateTime get lastRequested;

  static void _initializeBuilder(DayBuilder builder) {
    builder
      ..lastRequested = DateTime.now()
      ..deletedHomework = ListBuilder([]);
  }

  static DateTime dateToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static bool _isFuture(DateTime date) {
    return !date.isBefore(dateToday());
  }

  static String format(DateTime date) {
    DateTime today = dateToday();
    Duration difference = date.difference(today);
    if (difference.inDays == 0) return "Heute";
    if (difference.inDays == 1) return "Morgen";
    if (difference.inDays == -1)
      return "Gestern";
    else {
      String weekday = {
        1: "Montag",
        2: "Dienstag",
        3: "Mittwoch",
        4: "Donnerstag",
        5: "Freitag",
        6: "Samstag",
        7: "Sonntag",
      }[date.weekday];
      String dateString = "${date.day}.${date.month}.";
      return "$weekday, $dateString";
    }
  }
}

abstract class Homework implements Built<Homework, HomeworkBuilder> {
  Homework._();
  factory Homework([void Function(HomeworkBuilder) updates]) = _$Homework;
  static Serializer<Homework> get serializer => _$homeworkSerializer;

  bool get deleted;
  int get id;
  bool get isNew;
  bool get isChanged;
  String get title;
  String get subtitle;
  @nullable
  String get label;
  @nullable
  String get gradeFormatted;
  @nullable
  String get grade;
  bool get warning;
  bool get checkable;
  bool get checked;
  bool get deleteable;
  HomeworkType get type;
  @nullable
  Homework get previousVersion;
  @nullable
  DateTime get lastNotSeen;
  DateTime get firstSeen;

  /// Ignores client side fields like [isNew]
  bool serverEquals(Homework other) {
    return deleted == other.deleted &&
        title == other.title &&
        subtitle == other.subtitle &&
        label == other.label &&
        gradeFormatted == other.gradeFormatted &&
        grade == other.grade &&
        warning == other.warning &&
        type == other.type;
  }

  /// Guess whether this can be a successor of a previous [Homework]
  ///
  /// Based on:
  ///  * everything is identical (maybe except [id])
  /// or
  ///  * This is a possible replacement, bc a grade was assigned
  bool isSuccessorOf(Homework other) {
    return _isGradeReplacementOf(other) ||
        serverEquals(other) ||
        _isIdenticalButSubtitleAmended(other);
  }

  /// Check if this is a possible replacement of a [gradeGroup] entry
  ///
  /// if the previous entry was a [gradeGroup] and this is a [grade], it is possible that a grade
  /// was assigned, so that previous entry was replaced. In this case [id] changes, so we check for
  /// [subtitle] and [label]. No check against [title], since that will also change to a generic one.
  bool _isGradeReplacementOf(Homework other) {
    return this.type == HomeworkType.grade &&
        other.type == HomeworkType.gradeGroup &&
        _subtitlesAreAmended(this.subtitle, other.subtitle) &&
        this.label == other.label;
  }

  /// Check if everything is the same, but the subtitles are similar (shortened or amended)
  ///
  /// copy of [serverEquals] modulo the subtitles comparison
  bool _isIdenticalButSubtitleAmended(Homework other) {
    return deleted == other.deleted &&
        title == other.title &&
        _subtitlesAreAmended(this.subtitle, other.subtitle) &&
        label == other.label &&
        gradeFormatted == other.gradeFormatted &&
        grade == other.grade &&
        warning == other.warning &&
        type == other.type;
  }

  /// If either subtitle [a] contains subtitle [b] or vice versa
  static bool _subtitlesAreAmended(String a, String b) {
    return a.contains(b) || b.contains(a);
  }

  static void _initializeBuilder(HomeworkBuilder b) => b
    ..isNew = false
    ..isChanged = false
    ..deleted = false
    ..warning = false
    ..checkable = false
    ..deleteable = false
    ..deleted = false
    ..firstSeen = DateTime.now();
}

String formatGrade(String grade) {
  if (grade == null) return "keine Note eingetragen";
  List<String> split = grade.split(".");
  assert(split.length == 2);
  int mainGrade = int.parse(split[0]);
  String decimals = split[1];
  switch (decimals) {
    case "00":
      return "$mainGrade";
    case "25":
      return "$mainGrade+";
    case "50":
      return "$mainGrade/${mainGrade + 1}";
    case "75":
      return "${mainGrade + 1}-";
  }
  return grade;
}

class HomeworkType extends EnumClass {
  static const HomeworkType lessonHomework = _$a,
      gradeGroup = _$b,
      grade = _$c,
      unknown = _$d,
      observation = _$e,
      homework = _$f;

  const HomeworkType._(String name) : super(name);
  static BuiltSet<HomeworkType> get values => _$values2;
  static HomeworkType valueOf(String name) => _$valueOf2(name);
  static Serializer<HomeworkType> get serializer => _$homeworkTypeSerializer;
  @override
  String toString() {
    return this.name;
  }
}

abstract class Notification
    implements Built<Notification, NotificationBuilder> {
  Notification._();
  factory Notification([void Function(NotificationBuilder) updates]) =
      _$Notification;
  static Serializer<Notification> get serializer => _$notificationSerializer;

  int get id;
  String get title;
  @nullable
  String get subTitle;
  DateTime get timeSent;
}

abstract class Subject implements Built<Subject, SubjectBuilder> {
  Subject._();
  factory Subject([void Function(SubjectBuilder) updates]) = _$Subject;
  static Serializer<Subject> get serializer => _$subjectSerializer;

  BuiltMap<Semester, BuiltList<GradeAll>> get gradesAll;
  BuiltMap<Semester, BuiltList<GradeDetail>> get grades;
  BuiltMap<Semester, BuiltList<Observation>> get observations;
  int get id;
  String get name;

  List<DetailEntry> detailEntries(Semester semester) {
    if (semester == Semester.all) {
      final entries = (List.of(Semester.values)..remove(Semester.all))
          .map((s) => detailEntries(s))
          .toList();
      entries.removeWhere((e) => e == null);
      if (entries.isEmpty) return null;
      return entries.fold([], (a, b) => [...a, ...b]);
    }
    if (grades[semester] == null || observations[semester] == null) return null;
    return <DetailEntry>[
      ...grades[semester],
      ...observations[semester],
    ]..sort((a, b) => -a.date.compareTo(b.date));
  }

  int average(Semester semester) {
    assert(semester != Semester.all);
    final grades = gradesAll[semester];
    if (grades == null) return null;
    var sum = 0;
    var n = 0;
    for (var grade in grades) {
      if (grade.cancelled || grade.grade == null) continue;
      sum += grade.grade * grade.weightPercentage;
      n += grade.weightPercentage;
    }
    if (n == 0) return null;
    return (sum / n).round();
  }

  String averageFormatted(Semester semester) {
    final avg = average(semester);
    if (avg != null) {
      return gradeAverageFormat.format(avg / 100);
    } else
      return "/";
  }

  static Map<String, List<DetailEntry>> sortByType(List<DetailEntry> entries) {
    final m = Map<String, List<DetailEntry>>();
    for (final entry in entries) {
      String type;
      if (entry is Observation) {
        type = "Beobachtung";
      } else if (entry is GradeDetail) {
        type = entry.type;
      }
      if (m.containsKey(type))
        m[type].add(entry);
      else
        m[type] = [entry];
    }
    return m;
  }
}

abstract class _Entry {
  DateTime get date;
  bool get cancelled;
}

abstract class DetailEntry implements _Entry {}

abstract class Observation
    implements _Entry, DetailEntry, Built<Observation, ObservationBuilder> {
  Observation._();
  factory Observation([void Function(ObservationBuilder) updates]) =
      _$Observation;
  static Serializer<Observation> get serializer => _$observationSerializer;

  String get typeName;
  String get created;
  String get note;
}

abstract class _BasicGrade implements _Entry {
  int get grade;
  int get weightPercentage;
  DateTime get date;
  String get type;
}

abstract class GradeAll
    implements _BasicGrade, Built<GradeAll, GradeAllBuilder> {
  GradeAll._();
  factory GradeAll([void Function(GradeAllBuilder) updates]) = _$GradeAll;
  static Serializer<GradeAll> get serializer => _$gradeAllSerializer;
}

abstract class GradeDetail
    implements
        _BasicGrade,
        DetailEntry,
        Built<GradeDetail, GradeDetailBuilder> {
  GradeDetail._();
  factory GradeDetail([void Function(GradeDetailBuilder) updates]) =
      _$GradeDetail;
  static Serializer<GradeDetail> get serializer => _$gradeDetailSerializer;

  String get gradeFormatted => _formatGrade(grade);

  static String _formatGrade(int grade) {
    final mainGrade = grade ~/ 100;
    final decimals = grade % 100;
    switch (decimals) {
      case 0:
        return "$mainGrade";
      case 25:
        return "$mainGrade+";
      case 50:
        return "$mainGrade/${mainGrade + 1}";
      case 75:
        return "${mainGrade + 1}-";
      default:
        return gradeAverageFormat.format(grade / 100);
    }
  }

  int get id;
  BuiltList<Competence> get competences;
  String get name;
  String get created;
}

abstract class Competence implements Built<Competence, CompetenceBuilder> {
  Competence._();
  factory Competence([void Function(CompetenceBuilder) updates]) = _$Competence;
  static Serializer<Competence> get serializer => _$competenceSerializer;

  String get typeName;
  // $grade of 5
  int get grade;
}

abstract class AbsenceGroup
    implements Built<AbsenceGroup, AbsenceGroupBuilder> {
  @nullable
  String get reason;
  @nullable
  String get reasonSignature;
  @nullable
  DateTime get reasonTimestamp;
  AbsenceJustified get justified;
  int get hours;
  int get minutes;
  BuiltList<Absence> get absences;
  AbsenceGroup._();
  factory AbsenceGroup([updates(AbsenceGroupBuilder b)]) = _$AbsenceGroup;
  static Serializer<AbsenceGroup> get serializer => _$absenceGroupSerializer;
}

abstract class AbsenceStatistic
    implements Built<AbsenceStatistic, AbsenceStatisticBuilder> {
  AbsenceStatistic._();
  static Serializer<AbsenceStatistic> get serializer =>
      _$absenceStatisticSerializer;
  factory AbsenceStatistic([updates(AbsenceStatisticBuilder b)]) =
      _$AbsenceStatistic;

  int get counter;
  int get counterForSchool;
  int get delayed;
  int get justified;
  int get notJustified;
  String get percentage;
}

abstract class Absence implements Built<Absence, AbsenceBuilder> {
  /// Full hour = 50 min,
  /// seems not to be used when
  /// [minutesCameTooLate] or [minutesLeftTooEarly] is not 0
  int get minutes;
  int get minutesCameTooLate;
  int get minutesLeftTooEarly;
  DateTime get date;
  int get hour;
  Absence._();
  factory Absence([updates(AbsenceBuilder b)]) = _$Absence;
  static Serializer<Absence> get serializer => _$absenceSerializer;
}

class AbsenceJustified extends EnumClass {
  static Serializer<AbsenceJustified> get serializer =>
      _$absenceJustifiedSerializer;
  static const AbsenceJustified justified = _$justified;
  static const AbsenceJustified notJustified = _$notJustified;
  static const AbsenceJustified forSchool = _$forSchool;
  static const AbsenceJustified notYetJustified = _$notYetJustified;

  static AbsenceJustified fromInt(int i) {
    if (i == 2) return justified;
    if (i == 3) return notJustified;
    if (i == 4)
      return forSchool;
    else
      return notYetJustified;
  }

  const AbsenceJustified._(String name) : super(name);
  static BuiltSet<AbsenceJustified> get values => _$values;
  static AbsenceJustified valueOf(String name) => _$valueOf(name);
}

abstract class CalendarDay implements Built<CalendarDay, CalendarDayBuilder> {
  DateTime get date;
  BuiltList<CalendarHour> get hours;
  int get lenght => hours.fold(0, (a, b) => a + b.lenght);

  static Serializer<CalendarDay> get serializer => _$calendarDaySerializer;
  CalendarDay._();
  factory CalendarDay([updates(CalendarDayBuilder b)]) = _$CalendarDay;
}

abstract class CalendarHour
    implements Built<CalendarHour, CalendarHourBuilder> {
  int get fromHour;
  int get toHour;
  BuiltList<String> get rooms;
  @nullable
  String get description;
  String get subject;
  @nullable
  String get exam;
  int get lenght => toHour - fromHour + 1;
  @nullable
  String get homework;
  bool get hasExam => !isNullOrEmpty(exam);
  bool get hasHomework => !isNullOrEmpty(homework);
  bool get hasDescription => !isNullOrEmpty(description);

  BuiltList<Teacher> get teachers;

  static void _initializeBuilder(CalendarHourBuilder b) =>
      b..teachers = ListBuilder([]);

  static Serializer<CalendarHour> get serializer => _$calendarHourSerializer;
  CalendarHour._();
  factory CalendarHour([updates(CalendarHourBuilder b)]) = _$CalendarHour;
}

abstract class Teacher implements Built<Teacher, TeacherBuilder> {
  String get firstName;
  String get lastName;
  static Serializer<Teacher> get serializer => _$teacherSerializer;
  Teacher._();
  factory Teacher([updates(TeacherBuilder b)]) = _$Teacher;
}
