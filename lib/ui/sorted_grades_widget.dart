import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../container/sorted_grades_container.dart';
import '../data.dart';

class SortedGradesWidget extends StatelessWidget {
  final SortedGradesViewModel vm;

  const SortedGradesWidget({Key key, @required this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          title: Text("Noten nach Art sortieren"),
          onChanged: vm.sortByTypeCallback,
          value: vm.sortByType,
        ),
        SwitchListTile(
          title: Text("Gelöschte Noten anzeigen"),
          onChanged: vm.showCancelledCallback,
          value: vm.showCancelled,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: vm.subjects
              .map((s) => SubjectWidget(
                    subject: vm.semester == null ? s : s.subjects[vm.semester],
                    sortByType: vm.sortByType,
                    viewSubjectDetail: () => vm.viewSubjectDetail(s),
                    noAvgForAllSemester: vm.noAvgForAllSemester,
                    showCancelled: vm.showCancelled,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class SubjectWidget extends StatefulWidget {
  final bool sortByType, noAvgForAllSemester, showCancelled;
  final Subject subject;
  final VoidCallback viewSubjectDetail;

  const SubjectWidget(
      {Key key,
      this.sortByType,
      this.subject,
      this.viewSubjectDetail,
      this.noAvgForAllSemester,
      this.showCancelled})
      : super(key: key);

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  bool closed = true;
  @override
  void didUpdateWidget(SubjectWidget oldWidget) {
    closed = true;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: ObjectKey(widget.subject),
      title: Text(widget.subject.name),
      leading:
          widget.subject is AllSemesterSubject && widget.noAvgForAllSemester
              ? null
              : Text.rich(
                  TextSpan(
                    text: 'Ø ',
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.subject.averageFormatted,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
      children: widget.subject.hasSpecificGrades
          ? widget.sortByType
              ? widget.subject.typeSortedGrades.data.entries
                  .map(
                    (entry) => GradeTypeWidget(
                          typeName: entry.key,
                          grades: entry.value
                              .where(
                                  (g) => widget.showCancelled || !g.cancelled)
                              .toList(),
                        ),
                  )
                  .toList()
              : widget.subject.grades
                  .where((g) => widget.showCancelled || !g.cancelled)
                  .map((g) => GradeWidget(grade: g))
                  .toList()
          : [
              LinearProgressIndicator(),
            ],
      onExpansionChanged: (expansion) {
        closed = !expansion;
        if (expansion) {
          widget.viewSubjectDetail();
        }
      },
      initiallyExpanded: !closed,
    );
  }
}

class GradeWidget extends StatelessWidget {
  final Grade grade;
  static final lineThrough =
      const TextStyle(decoration: TextDecoration.lineThrough);

  const GradeWidget({Key key, this.grade}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
                ListTile(
                  title: Text(
                    grade.name,
                    style: grade.cancelled ? lineThrough : null,
                  ),
                  subtitle: Text(
                    "${DateFormat("dd/MM/yy").format(grade.date)}:\n${grade.type} - ${grade.weightPercentage} %",
                    style: grade.cancelled ? lineThrough : null,
                  ),
                  trailing: Text(
                    grade.gradeFormatted,
                    style: grade.cancelled ? lineThrough : null,
                  ),
                  isThreeLine: true,
                ),
                Wrap(
                  children: <Widget>[],
                )
              ] +
              grade.competences
                  ?.map((c) => CompetenceWidget(
                        competence: c,
                        cancelled: grade.cancelled,
                      ))
                  ?.toList() ??
          [],
    );
  }
}

class CompetenceWidget extends StatelessWidget {
  final Competence competence;
  final bool cancelled;

  const CompetenceWidget({Key key, this.competence, this.cancelled})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 32, bottom: 16, right: 8),
      child: Wrap(
        children: <Widget>[
          Text(
            competence.typeName,
            style: cancelled ? GradeWidget.lineThrough : null,
          ),
          Row(
            children: List.generate(
              5,
              (n) => Star(
                    filled: n < competence.grade,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class Star extends StatelessWidget {
  final bool filled;

  const Star({Key key, this.filled}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Icon(filled ? Icons.star : Icons.star_border);
  }
}

class GradeTypeWidget extends StatelessWidget {
  final String typeName;
  final List<Grade> grades;

  const GradeTypeWidget({Key key, this.typeName, this.grades})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final displayGrades = grades.map((g) => GradeWidget(grade: g)).toList();
    return displayGrades.isEmpty
        ? SizedBox()
        : ExpansionTile(
            title: Text(typeName),
            children: grades.map((g) => GradeWidget(grade: g)).toList(),
            initiallyExpanded: true,
          );
  }
}
