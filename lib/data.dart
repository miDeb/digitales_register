import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

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
  @BuiltValueField(compare: false)
  bool get checked;
  bool get deleteable;
  HomeworkType get type;
  @BuiltValueField(compare: false)
  @nullable
  Homework get previousVersion;
  @BuiltValueField(compare: false)
  @nullable
  DateTime get lastNotSeen;
  @BuiltValueField(compare: false)
  DateTime get firstSeen;

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

class Notification {
  final int id;
  final String title, subTitle;
  final DateTime timeSent;
  Notification.parse(Map data)
      : id = data["id"],
        title = data["title"],
        subTitle = data["subTitle"],
        timeSent = DateTime.parse(data["timeSent"]);
  Notification({
    this.id,
    this.timeSent,
    this.title,
    this.subTitle,
  });
  toJson() {
    return {
      "id": id,
      "title": title,
      "subTitle": subTitle,
      "timeSent": timeSent.toIso8601String(),
    };
  }
}

abstract class AllSemesterSubject
    implements Built<AllSemesterSubject, AllSemesterSubjectBuilder>, Subject {
  BuiltMap<int, SingleSemesterSubject> get subjects;
  List<Grade> get grades {
    return subjects.values.fold([], (list, s) => list..addAll(s.grades));
  }

  List<GradeEntry> get entries {
    return subjects.values.fold([], (list, s) => list..addAll(s.entries));
  }

  List<Observation> get _observations {
    return subjects.values
        .fold([], (list, s) => list..addAll(s._observations ?? []));
  }

  TypeSortedEntries get typeSortedEntries {
    return TypeSortedEntries.from(grades, _observations);
  }

  int get id {
    return subjects.values.first.id;
  }

  String get name {
    return subjects.values.first.name;
  }

  int get average {
    return SingleSemesterSubject.calculateAverage(grades);
  }

  String get averageFormatted {
    return average != null ? (average / 100).toStringAsFixed(2) : "/";
  }

  bool get hasSpecificGrades {
    return !subjects.values.any((s) => !s.hasSpecificGrades);
  }

  AllSemesterSubject._();
  factory AllSemesterSubject([updates(AllSemesterSubjectBuilder b)]) =
      _$AllSemesterSubject;
  static Serializer<AllSemesterSubject> get serializer =>
      _$allSemesterSubjectSerializer;
}

abstract class Subject {
  List<Grade> get grades;
  List<GradeEntry> get entries;
  TypeSortedEntries get typeSortedEntries;
  int get id;
  String get name;
  int get average;
  String get averageFormatted;
  bool get hasSpecificGrades;
}

class SingleSemesterSubject implements Subject {
  final List<Grade> grades;
  List<Observation> _observations;
  List<GradeEntry> entries;
  TypeSortedEntries typeSortedEntries;
  final int id;
  final String name;
  int average;
  String averageFormatted;

  bool hasSpecificGrades = false;

  void replaceWithSpecificData(Map map, int semester) {
    final specificGrades =
        map["grades"].map((g) => Grade.parse(g, isSpecific: true));
    _observations =
        List.of(map["observations"]).map((g) => Observation.parse(g)).toList();
    grades.removeWhere((grade) =>
        !grade.specific || specificGrades.any((g) => grade.id == g.id));
    grades
      ..addAll(Iterable.castFrom<dynamic, Grade>(specificGrades))
      ..sort((first, second) => -first.date.compareTo(second.date));

    entries = [...grades, ..._observations]
      ..sort((first, second) => -first.date.compareTo(second.date));

    hasSpecificGrades = true;
    typeSortedEntries = TypeSortedEntries.from(grades, _observations);
  }

  SingleSemesterSubject.parse(Map json)
      : grades = (json["grades"] as List)
            .map((rawGrade) => Grade.parse(rawGrade))
            .toList()
              ..sort((first, second) => -first.date.compareTo(second.date)),
        _observations = (json["observations"] as List)
            ?.map((g) => Observation.parse(g))
            ?.toList(),
        id = json["subject"]["id"],
        name = json["subject"]["name"] {
    average = calculateAverage(grades);
    if (average != null)
      averageFormatted = (average / 100).toStringAsFixed(2);
    else
      averageFormatted = "/";

    entries = [...grades, ...?_observations]
      ..sort((first, second) => -first.date.compareTo(second.date));

    typeSortedEntries = TypeSortedEntries.from(grades, _observations);
    hasSpecificGrades = grades.every((g) => g.specific);
  }

  toJson() {
    return {
      "grades": grades.map((g) => g.toJson()).toList(),
      "observations": _observations?.map((o) => o.toJson())?.toList(),
      "subject": {
        "id": id,
        "name": name,
      }
    };
  }

  static int calculateAverage(List<Grade> grades) {
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
}

class TypeSortedEntries {
  Map<String, List<GradeEntry>> data = {};
  TypeSortedEntries.from(List<Grade> grades, List<Observation> observations) {
    for (var grade in grades) {
      data.putIfAbsent(grade.type, () => []);
      data[grade.type].add(grade);
    }
    if (observations != null)
      for (var observation in observations) {
        data.putIfAbsent(observation.typeName, () => []);
        data[observation.typeName].add(observation);
      }

    for (var type in data.values) {
      type.sort((first, second) => -first.date.compareTo(second.date));
    }
  }
}

class GradeEntry {
  DateTime date;
  bool cancelled;
}

class Observation extends GradeEntry {
  final String typeName;
  final bool cancelled;
  final String created;
  final String note;
  final DateTime date;

  Observation.parse(Map json)
      : typeName = json["typeName"],
        cancelled = json["cancelled"] != 0,
        created = json["created"],
        note = json["note"],
        date = DateTime.parse(json["date"]);

  toJson() {
    return {
      "typeName": typeName,
      "cancelled": cancelled ? 1 : 0,
      "created": created,
      "note": note,
      "date": date.toIso8601String(),
    };
  }
}

class Grade extends GradeEntry {
  final int grade;
  final String gradeFormatted;
  final DateTime date;
  final int weightPercentage;
  final bool cancelled;
  // ! name for all_subjects: type, name for subject_detail: typeName !
  final String type;
  final bool specific;
  static bool _isSpecific(json, bool _specific) {
    return _specific ?? json["specific"] ?? false;
  }

  final int id;
  Grade.parse(Map json, {bool isSpecific})
      : grade = json["grade"]
//.toString()
            ?.split(".")
            ?.map((string) => int.parse(string))
            ?.fold(0, (prev, current) {
          return prev == 0 ? current * 100 : prev + current;
        }),
        gradeFormatted = formatGrade(json["grade"]),
        date = DateTime.parse(json["date"]),
        weightPercentage = json["weight"],
        cancelled = json["cancelled"] != 0,
        type = _isSpecific(json, isSpecific) ? json["typeName"] : json["type"],
        created = _isSpecific(json, isSpecific) ? json["created"] : null,
        competences = _isSpecific(json, isSpecific)
            ? (json["competences"] as List)
                .map((c) => Competence.from(c))
                .toList()
            : null,
        name = _isSpecific(json, isSpecific) ? json["name"] : null,
        id = _isSpecific(json, isSpecific) ? json["id"] : null,
        specific = _isSpecific(json, isSpecific);

  toJson() {
    return {
      "grade": grade == null
          ? null
          : "${grade ~/ 100}.${(grade % 100).toString().padLeft(2, "0")}",
      "date": date.toIso8601String(),
      "cancelled": cancelled ? 1 : 0,
      "specific": specific,
      "weight": weightPercentage,
      "created": created,
      "competences": competences?.map((c) => c.toJson())?.toList(),
      "name": name,
      "id": id,
      (specific ? "typeName" : "type"): type,
    };
  }

  final List<Competence> competences;
  final String name;
  final String created;
}

class Competence {
  final String typeName;
  // $grade of 5
  final int grade;
  Competence.from(Map map)
      : typeName = map["typeName"],
        grade = double.parse(map["grade"].toString()).toInt();
  toJson() {
    return {
      "typeName": typeName,
      "grade": grade.toDouble().toString(),
    };
  }
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

  // Legacy field "teachers" was just a List of Strings, formatted firstName lastName
  // and has been replaced, but the wireName had to be changed
  @BuiltValueField(wireName: "teachersNew")
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
