import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'app_state.dart';
import 'util.dart';

part 'data.g.dart';

abstract class Day implements Built<Day, DayBuilder> {
  factory Day([void Function(DayBuilder)? updates]) = _$Day;
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
      ..lastRequested = now
      ..deletedHomework = ListBuilder();
  }

  static DateTime dateToday() {
    return DateTime(now.year, now.month, now.day);
  }

  static bool _isFuture(DateTime date) {
    return !date.isBefore(dateToday());
  }

  static String format(DateTime date) {
    final DateTime today = dateToday();
    final Duration difference = date.difference(today);
    if (difference.inDays == 0) return "Heute";
    if (difference.inDays == 1) return "Morgen";
    if (difference.inDays == -1) {
      return "Gestern";
    } else {
      final String? weekday = {
        1: "Montag",
        2: "Dienstag",
        3: "Mittwoch",
        4: "Donnerstag",
        5: "Freitag",
        6: "Samstag",
        7: "Sonntag",
      }[date.weekday];
      final String dateString = "${date.day}.${date.month}.";
      return "$weekday, $dateString";
    }
  }
}

abstract class Homework implements Built<Homework, HomeworkBuilder> {
  factory Homework([void Function(HomeworkBuilder)? updates]) = _$Homework;
  Homework._();
  static Serializer<Homework> get serializer => _$homeworkSerializer;

  bool get deleted;
  int get id;
  bool get isNew;
  bool get isChanged;
  String /*!*/ get title;
  String get subtitle;

  String? get label;

  String? get gradeFormatted;

  String? get grade;
  // It's always false for tests :(. I only saw a warning for a grade entry with
  // a 'null' grade.
  @BuiltValueField(wireName: "warning")
  bool get warningServerSaid;
  // Heuristics to still show a warning when it would make sense
  bool get warning =>
      warningServerSaid || title == "Testarbeit" || title == "Schularbeit";
  bool get checkable;
  bool get checked;
  bool get deleteable;
  // This seems to always be 'gradeGroup' as of 20/21
  HomeworkType get type;

  Homework? get previousVersion;

  DateTime? get lastNotSeen;
  DateTime get firstSeen;

  BuiltList<GradeGroupSubmission>? get gradeGroupSubmissions;

  /// Ignores client side fields like [isNew]
  bool serverEquals(Homework other) {
    return deleted == other.deleted &&
        title == other.title &&
        subtitle == other.subtitle &&
        label == other.label &&
        gradeFormatted == other.gradeFormatted &&
        grade == other.grade &&
        warningServerSaid == other.warningServerSaid &&
        type == other.type;
  }

  /// Guess whether this can be a successor of a previous [Homework]
  ///
  /// Based on:
  ///  * everything is identical, except that the [id] can be different and the
  ///    subtitles can be edited
  ///
  /// or
  ///  * This is a possible replacement, bc a grade was assigned
  bool isSuccessorOf(Homework other) {
    return _isGradeReplacementOf(other) ||
        _isIdenticalButSubtitleAmended(other);
  }

  /// Check if this is a possible replacement of a [gradeGroup] entry
  ///
  /// if the previous entry was a [gradeGroup] and this is a [grade], it is possible that a grade
  /// was assigned, so that previous entry was replaced. In this case [id] changes, so we check for
  /// [subtitle] and [label]. No check against [title], since that will also change to a generic one.
  bool _isGradeReplacementOf(Homework other) {
    return type == HomeworkType.grade &&
        other.type == HomeworkType.gradeGroup &&
        _stringsAreAmended(subtitle, other.subtitle) &&
        label == other.label;
  }

  /// Check if everything is the same, but the subtitles are similar (shortened or amended)
  ///
  /// copy of [serverEquals] modulo the subtitles comparison
  bool _isIdenticalButSubtitleAmended(Homework other) {
    return deleted == other.deleted &&
        title == other.title &&
        _stringsAreAmended(subtitle, other.subtitle) &&
        label == other.label &&
        gradeFormatted == other.gradeFormatted &&
        grade == other.grade &&
        warningServerSaid == other.warningServerSaid &&
        type == other.type;
  }

  /// If either string [a] contains subtitle [b] or vice versa
  static bool _stringsAreAmended(String a, String b) {
    return a.contains(b) || b.contains(a);
  }

  static void _initializeBuilder(HomeworkBuilder b) => b
    ..isNew = false
    ..isChanged = false
    ..deleted = false
    ..warningServerSaid = false
    ..checkable = false
    ..deleteable = false
    ..deleted = false
    ..firstSeen = now;
}

String formatGradeFromString(String? grade) {
  if (grade == null) return "keine Note eingetragen";
  final List<String> split = grade.split(".");
  assert(split.length == 2);
  final int mainGrade = int.parse(split[0]);
  final String decimals = split[1];
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
    return name;
  }
}

abstract class GradeGroupSubmission
    implements Built<GradeGroupSubmission, GradeGroupSubmissionBuilder> {
  factory GradeGroupSubmission(
          [void Function(GradeGroupSubmissionBuilder)? updates]) =
      _$GradeGroupSubmission;
  GradeGroupSubmission._();
  static Serializer<GradeGroupSubmission> get serializer =>
      _$gradeGroupSubmissionSerializer;

  DateTime get timestamp;
  String get file;
  String get originalName;
  String get typeName;
  @BuiltValueField(serialize: false)
  bool get downloading;
  bool get fileAvailable;
  int get id;
  int get gradeGroupId;
  int get userId;

  static void _initializeBuilder(GradeGroupSubmissionBuilder b) => b
    ..downloading = false
    ..fileAvailable = false;
}

abstract class Notification
    implements Built<Notification, NotificationBuilder> {
  factory Notification([void Function(NotificationBuilder)? updates]) =
      _$Notification;
  Notification._();
  static Serializer<Notification> get serializer => _$notificationSerializer;

  int get id;
  String get title;

  String? get subTitle;
  DateTime get timeSent;

  String? get type;

  int? get objectId;
}

abstract class Subject implements Built<Subject, SubjectBuilder> {
  factory Subject([void Function(SubjectBuilder)? updates]) = _$Subject;
  Subject._();
  static Serializer<Subject> get serializer => _$subjectSerializer;

  BuiltMap<Semester, BuiltList<GradeAll>> get gradesAll;
  BuiltMap<Semester, BuiltList<GradeDetail>> get grades;
  BuiltMap<Semester, BuiltList<Observation>> get observations;
  int? get id;
  String get name;

  List<GradeAll>? basicGrades(Semester semester) {
    if (semester == Semester.all) {
      final entries = (List.of(Semester.values)..remove(Semester.all))
          .map((s) => basicGrades(s))
          .toList();
      entries.removeWhere((e) => e == null);
      if (entries.isEmpty) return null;
      return entries
          .fold<List<GradeAll>>([], (a, b) => [...a, if (b != null) ...b])
            ..sort((a, b) => -a.date.compareTo(b.date));
    }
    if (gradesAll[semester] == null) return null;
    return gradesAll[semester]!.toList()
      ..sort((a, b) => -a.date.compareTo(b.date));
  }

  List<DetailEntry>? detailEntries(Semester semester) {
    if (semester == Semester.all) {
      final entries = (List.of(Semester.values)..remove(Semester.all))
          .map((s) => detailEntries(s))
          .toList();
      entries.removeWhere((e) => e == null);
      if (entries.isEmpty) return null;
      return entries
          .fold<List<DetailEntry>>([], (a, b) => [...a, if (b != null) ...b])
            ..sort((a, b) => -a.date.compareTo(b.date));
    }
    if (grades[semester] == null || observations[semester] == null) return null;
    return <DetailEntry>[
      ...grades[semester]!,
      ...observations[semester]!,
    ]..sort((a, b) => -a.date.compareTo(b.date));
  }

  int? average(Semester semester) {
    final grades = basicGrades(semester);
    if (grades == null) return null;
    var sum = 0;
    var n = 0;
    for (final grade in grades) {
      if (grade.cancelled || grade.grade == null) continue;
      sum += grade.grade! * grade.weightPercentage;
      n += grade.weightPercentage;
    }
    if (n == 0) return null;
    return (sum / n).round();
  }

  String averageFormatted(Semester semester) {
    final avg = average(semester);
    if (avg != null) {
      return gradeAverageFormat.format(avg / 100);
    } else {
      return "/";
    }
  }

  static Map<String, List<DetailEntry>> sortByType(List<DetailEntry> entries) {
    final m = <String, List<DetailEntry>>{};
    for (final entry in entries) {
      String type;
      if (entry is Observation) {
        type = "Beobachtung";
      } else if (entry is GradeDetail) {
        type = entry.type;
      } else {
        // can't happen as long as there are no other subtypes of DetailEntry
        throw Error();
      }
      if (m.containsKey(type)) {
        m[type]!.add(entry);
      } else {
        m[type] = [entry];
      }
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
  factory Observation([void Function(ObservationBuilder)? updates]) =
      _$Observation;
  Observation._();
  static Serializer<Observation> get serializer => _$observationSerializer;

  String get typeName;
  String get created;
  String get note;
}

abstract class _BasicGrade implements _Entry {
  int? get grade;
  int get weightPercentage;
  @override
  DateTime get date;
  String get type;
}

abstract class GradeAll
    implements _BasicGrade, Built<GradeAll, GradeAllBuilder> {
  factory GradeAll([void Function(GradeAllBuilder)? updates]) = _$GradeAll;
  GradeAll._();
  static Serializer<GradeAll> get serializer => _$gradeAllSerializer;
}

String formatGradeFromInt(int? grade) {
  if (grade == null) {
    return "";
  }
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

abstract class GradeDetail
    implements
        _BasicGrade,
        DetailEntry,
        Built<GradeDetail, GradeDetailBuilder> {
  factory GradeDetail([void Function(GradeDetailBuilder)? updates]) =
      _$GradeDetail;
  GradeDetail._();
  static Serializer<GradeDetail> get serializer => _$gradeDetailSerializer;

  String get gradeFormatted => formatGradeFromInt(grade);

  int get id;
  BuiltList<Competence> get competences;
  String get name;
  String get created;

  String? get cancelledDescription;

  /// This is presented as "comment" in the ui, however I wanted to be conistent
  /// with the api naming here.

  String? get description;
}

abstract class Competence implements Built<Competence, CompetenceBuilder> {
  factory Competence([void Function(CompetenceBuilder)? updates]) =
      _$Competence;
  Competence._();
  static Serializer<Competence> get serializer => _$competenceSerializer;

  String get typeName;
  // $grade of 5
  int get grade;
}

abstract class AbsenceGroup
    implements Built<AbsenceGroup, AbsenceGroupBuilder> {
  String? get reason;

  String? get reasonSignature;

  DateTime? get reasonTimestamp;
  AbsenceJustified get justified;
  int get hours;
  int get minutes;
  BuiltList<Absence> get absences;
  factory AbsenceGroup([Function(AbsenceGroupBuilder b)? updates]) =
      _$AbsenceGroup;
  AbsenceGroup._();
  static Serializer<AbsenceGroup> get serializer => _$absenceGroupSerializer;
}

abstract class AbsenceStatistic
    implements Built<AbsenceStatistic, AbsenceStatisticBuilder> {
  factory AbsenceStatistic([Function(AbsenceStatisticBuilder b)? updates]) =
      _$AbsenceStatistic;
  AbsenceStatistic._();
  static Serializer<AbsenceStatistic> get serializer =>
      _$absenceStatisticSerializer;

  int? get counter;
  int? get counterForSchool;
  int? get delayed;
  int? get justified;
  int? get notJustified;
  String? get percentage;
}

abstract class Absence implements Built<Absence, AbsenceBuilder> {
  /// Full hour = 50 min,
  /// seems not to be used when
  /// [minutesCameTooLate] or [minutesLeftTooEarly] is not 0
  int get minutes;
  int get minutesCameTooLate;
  int get minutesLeftTooEarly;
  DateTime /*!*/ get date;
  int get hour;
  factory Absence([Function(AbsenceBuilder b)? updates]) = _$Absence;
  Absence._();
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
    if (i == 4) {
      return forSchool;
    } else {
      return notYetJustified;
    }
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
  factory CalendarDay([Function(CalendarDayBuilder b)? updates]) =
      _$CalendarDay;
  CalendarDay._();
}

abstract class CalendarHour
    implements Built<CalendarHour, CalendarHourBuilder> {
  int get fromHour;
  int get toHour;
  BuiltList<String> get rooms;

  String? get description;
  String get subject;
  BuiltList<HomeworkExam> get homeworkExams;
  int get lenght => toHour - fromHour + 1;
  bool get hasDescription => !description.isNullOrEmpty;
  bool get warning => homeworkExams.any((it) => it.warning);

  BuiltList<Teacher> get teachers;

  static void _initializeBuilder(CalendarHourBuilder b) =>
      b..teachers = ListBuilder();

  static Serializer<CalendarHour> get serializer => _$calendarHourSerializer;
  factory CalendarHour([Function(CalendarHourBuilder b)? updates]) =
      _$CalendarHour;
  CalendarHour._();
}

abstract class Teacher implements Built<Teacher, TeacherBuilder> {
  String get firstName;
  String get lastName;
  static Serializer<Teacher> get serializer => _$teacherSerializer;
  factory Teacher([Function(TeacherBuilder b)? updates]) = _$Teacher;
  Teacher._();
}

abstract class HomeworkExam
    implements Built<HomeworkExam, HomeworkExamBuilder> {
  int get id;
  String get name;
  bool get homework;
  bool get online;
  DateTime get deadline;
  bool get hasGrades;
  bool get hasGradeGroupSubmissions;
  int get typeId;
  String get typeName;
  bool get warning => typeName == "Testarbeit" || typeName == "Schularbeit";
  static Serializer<HomeworkExam> get serializer => _$homeworkExamSerializer;
  factory HomeworkExam([Function(HomeworkExamBuilder b)? updates]) =
      _$HomeworkExam;
  HomeworkExam._();
}

abstract class Message implements Built<Message, MessageBuilder> {
  String get subject;
  String get text;
  DateTime get timeSent;

  DateTime? get timeRead;
  String get recipientString;
  String /*!*/ get fromName;

  String? get fileName;

  String? get fileOriginalName;
  int get id;
  bool get fileAvailable;
  @BuiltValueField(serialize: false)
  bool get downloading;

  bool get isNew => timeRead == null;

  static Serializer<Message> get serializer => _$messageSerializer;
  factory Message([Function(MessageBuilder b)? updates]) = _$Message;
  Message._();
  static void _initializeBuilder(MessageBuilder b) {
    b
      ..downloading = false
      ..fileAvailable = false;
  }
}
