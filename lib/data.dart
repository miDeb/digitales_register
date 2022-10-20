// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//D
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:collection/collection.dart';

import 'package:dr/app_state.dart';
import 'package:dr/utc_date_time.dart';
import 'package:dr/util.dart';

part 'data.g.dart';

bool estimateShouldWarn(String name) {
  return name == "Schularbeit" ||
      name == "Testarbeit" ||
      name.contains("Prüfung");
}

abstract class Day implements Built<Day, DayBuilder> {
  factory Day([void Function(DayBuilder)? updates]) = _$Day;
  Day._();
  static Serializer<Day> get serializer => _$daySerializer;
  BuiltList<Homework> get homework;
  BuiltList<Homework> get deletedHomework;
  UtcDateTime get date;
  String get displayName => format(date);
  bool get future => _isFuture(date);
  UtcDateTime get lastRequested;

  static void _initializeBuilder(DayBuilder builder) {
    builder
      ..lastRequested = now
      ..deletedHomework = ListBuilder();
  }

  static UtcDateTime dateToday() {
    return UtcDateTime(now.year, now.month, now.day);
  }

  static bool _isFuture(UtcDateTime date) {
    return !date.isBefore(dateToday());
  }

  static String format(UtcDateTime date) {
    final UtcDateTime today = dateToday();
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
  String get title;
  String get subtitle;

  String? get label;

  String? get gradeFormatted;

  String? get grade;
  // It's always false for tests :(. I only saw a warning for a grade entry with
  // a 'null' grade.
  @BuiltValueField(wireName: "warning")
  bool get warningServerSaid;
  // Heuristics to still show a warning when it would make sense
  bool get warning => warningServerSaid || estimateShouldWarn(title);
  bool get checkable;
  bool get checked;
  bool get deleteable;
  // This seems to always be 'gradeGroup' as of 20/21
  HomeworkType get type;

  Homework? get previousVersion;

  UtcDateTime? get lastNotSeen;
  UtcDateTime get firstSeen;

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

  UtcDateTime get timestamp;
  String get file;
  String get originalName;
  String get typeName;
  @BuiltValueField(serialize: false)
  bool get downloading;
  bool get fileAvailable;
  int get id;
  int get gradeGroupId;
  int get userId;

  String get uniqueName => "hw_${id}_${gradeGroupId}_$originalName";

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
  UtcDateTime get timeSent;

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
  BuiltMap<Semester, UtcDateTime>? get lastFetchedBasic;
  BuiltMap<Semester, UtcDateTime>? get lastFetchedDetailed;

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
        throw Exception(
          "A new subtype of DetailEntry was introduced without updating sortByType",
        );
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
  UtcDateTime get date;
  bool get cancelled;
}

abstract class DetailEntry implements _Entry {}

abstract class Observation
    implements DetailEntry, Built<Observation, ObservationBuilder> {
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
  UtcDateTime get date;
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
  // The grade from 0 to 5.
  int get grade;
}

abstract class AbsenceGroup
    implements Built<AbsenceGroup, AbsenceGroupBuilder> {
  String? get reason;
  String? get note;

  String? get reasonSignature;

  UtcDateTime? get reasonTimestamp;
  AbsenceJustified get justified;
  int get hours;
  int get minutes;
  BuiltList<Absence> get absences;
  factory AbsenceGroup([Function(AbsenceGroupBuilder b)? updates]) =
      _$AbsenceGroup;
  AbsenceGroup._();
  static Serializer<AbsenceGroup> get serializer => _$absenceGroupSerializer;
}

abstract class FutureAbsence
    implements Built<FutureAbsence, FutureAbsenceBuilder> {
  AbsenceJustified get justified;
  String? get reason;
  String? get note;

  String? get reasonSignature;
  DateTime? get reasonTimestamp;

  DateTime get startDate;
  DateTime get endDate;

  int get startHour;
  int get endHour;

  factory FutureAbsence([void Function(FutureAbsenceBuilder) updates]) =
      _$FutureAbsence;
  FutureAbsence._();
  static Serializer<FutureAbsence> get serializer => _$futureAbsenceSerializer;
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
  UtcDateTime get date;
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
  UtcDateTime get date;
  BuiltList<CalendarHour> get hours;
  int get fromHour => hours.firstOrNull?.fromHour ?? 0;
  int get toHour => hours.lastOrNull?.toHour ?? 0;

  UtcDateTime? get lastFetched;

  static Serializer<CalendarDay> get serializer => _$calendarDaySerializer;
  factory CalendarDay([Function(CalendarDayBuilder b)? updates]) =
      _$CalendarDay;
  CalendarDay._();
}

abstract class CalendarHour
    implements Built<CalendarHour, CalendarHourBuilder> {
  int get fromHour;
  int get toHour;
  BuiltList<TimeSpan> get timeSpans;
  BuiltList<String> get rooms;

  String get subject;
  BuiltList<HomeworkExam> get homeworkExams;
  BuiltList<LessonContent> get lessonContents;
  int get length => toHour - fromHour + 1;
  bool get warning => homeworkExams.any((it) => it.warning);

  BuiltList<Teacher> get teachers;

  static void _initializeBuilder(CalendarHourBuilder b) => b
    ..teachers = ListBuilder()
    ..timeSpans = ListBuilder();

  static Serializer<CalendarHour> get serializer => _$calendarHourSerializer;
  factory CalendarHour([Function(CalendarHourBuilder b)? updates]) =
      _$CalendarHour;
  CalendarHour._();
}

abstract class TimeSpan implements Built<TimeSpan, TimeSpanBuilder> {
  factory TimeSpan([Function(TimeSpanBuilder b)? updates]) = _$TimeSpan;
  TimeSpan._();
  static Serializer<TimeSpan> get serializer => _$timeSpanSerializer;

  UtcDateTime get from;

  UtcDateTime get to;
}

abstract class Teacher implements Built<Teacher, TeacherBuilder> {
  String get firstName;
  String get lastName;
  String get fullName => "$firstName $lastName";
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
  UtcDateTime get deadline;
  bool get hasGrades;
  bool get hasGradeGroupSubmissions;
  int get typeId;
  String get typeName;
  bool get warning => estimateShouldWarn(typeName);
  static Serializer<HomeworkExam> get serializer => _$homeworkExamSerializer;
  factory HomeworkExam([Function(HomeworkExamBuilder b)? updates]) =
      _$HomeworkExam;
  HomeworkExam._();
}

abstract class LessonContent
    implements Built<LessonContent, LessonContentBuilder> {
  String get name;
  String get typeName;
  BuiltList<LessonContentSubmission> get submissions;

  static Serializer<LessonContent> get serializer => _$lessonContentSerializer;
  factory LessonContent([void Function(LessonContentBuilder) updates]) =
      _$LessonContent;
  LessonContent._();
}

abstract class LessonContentSubmission
    implements Built<LessonContentSubmission, LessonContentSubmissionBuilder> {
  String get originalName;
  String get type;
  String get id;
  String get lessonContentId;
  UtcDateTime get date;

  @BuiltValueField(serialize: false)
  bool get downloading;
  bool get fileAvailable;

  String get uniqueName => "cal_${lessonContentId}_${id}_$originalName";

  static Serializer<LessonContentSubmission> get serializer =>
      _$lessonContentSubmissionSerializer;
  factory LessonContentSubmission(
          [void Function(LessonContentSubmissionBuilder) updates]) =
      _$LessonContentSubmission;
  LessonContentSubmission._();

  static void _initializeBuilder(LessonContentSubmissionBuilder b) => b
    ..fileAvailable = false
    ..downloading = false;
}

abstract class Message implements Built<Message, MessageBuilder> {
  String get subject;
  String get text;
  UtcDateTime get timeSent;

  UtcDateTime? get timeRead;
  String get recipientString;
  String get fromName;

  int get id;
  BuiltList<MessageAttachmentFile> get attachments;

  bool get isNew => timeRead == null;

  static Serializer<Message> get serializer => _$messageSerializer;
  factory Message([Function(MessageBuilder b)? updates]) = _$Message;
  Message._();

  static void _initializeBuilder(MessageBuilder b) =>
      b..attachments = ListBuilder<MessageAttachmentFile>();
}

abstract class MessageAttachmentFile
    implements Built<MessageAttachmentFile, MessageAttachmentFileBuilder> {
  String get originalName;
  String get file;
  int get messageId;
  int get id;

  @BuiltValueField(serialize: false)
  bool get downloading;
  bool get fileAvailable;

  String get uniqueName => "msg_${messageId}_${id}_$originalName";

  factory MessageAttachmentFile(
          [Function(MessageAttachmentFileBuilder b)? updates]) =
      _$MessageAttachmentFile;
  MessageAttachmentFile._();
  static Serializer<MessageAttachmentFile> get serializer =>
      _$messageAttachmentFileSerializer;

  static void _initializeBuilder(MessageAttachmentFileBuilder b) => b
    ..fileAvailable = false
    ..downloading = false;
}
