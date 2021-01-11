import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_state.dart';
import '../container/sorted_grades_container.dart';
import '../data.dart';
import '../util.dart';

typedef ViewSubjectDetailCallback = void Function(Subject s);
typedef SetBoolCallback = void Function(bool byType);

class SortedGradesWidget extends StatelessWidget {
  final SortedGradesViewModel vm;
  final ViewSubjectDetailCallback viewSubjectDetail;
  final SetBoolCallback sortByTypeCallback, showCancelledCallback;

  const SortedGradesWidget({
    Key key,
    @required this.vm,
    this.viewSubjectDetail,
    this.sortByTypeCallback,
    this.showCancelledCallback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile.adaptive(
          title: Text("Noten nach Art sortieren"),
          onChanged: sortByTypeCallback,
          value: vm.sortByType,
        ),
        SwitchListTile.adaptive(
          title: Text("Gelöschte Noten anzeigen"),
          onChanged: showCancelledCallback,
          value: vm.showCancelled,
        ),
        Divider(
          height: 0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: vm.subjects
              .map(
                (s) => SubjectWidget(
                  subject: s,
                  sortByType: vm.sortByType,
                  viewSubjectDetail: () => viewSubjectDetail(s),
                  showCancelled: vm.showCancelled,
                  semester: vm.semester,
                  noInternet: vm.noInternet,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class SubjectWidget extends StatefulWidget {
  final bool sortByType, showCancelled, noInternet;
  final Subject subject;
  final Semester semester;
  final VoidCallback viewSubjectDetail;

  const SubjectWidget({
    Key key,
    this.sortByType,
    this.subject,
    this.viewSubjectDetail,
    this.showCancelled,
    this.semester,
    this.noInternet,
  }) : super(key: key);

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  bool closed = true;
  @override
  void didUpdateWidget(SubjectWidget oldWidget) {
    if (oldWidget.semester != widget.semester) closed = true;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.subject.detailEntries(widget.semester);
    return AbsorbPointer(
      absorbing: widget.noInternet && entries == null,
      child: ExpansionTile(
        key: ObjectKey(widget.subject),
        title: Text(widget.subject.name),
        leading: widget.semester != Semester.all
            ? Text.rich(
                TextSpan(
                  text: 'Ø ',
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.subject.averageFormatted(widget.semester),
                    ),
                  ],
                ),
              )
            : null,
        trailing: widget.noInternet && entries == null ? SizedBox() : null,
        children: entries != null
            ? widget.sortByType
                ? Subject.sortByType(entries)
                    .entries
                    .map(
                      (entry) => GradeTypeWidget(
                        typeName: entry.key,
                        entries: entry.value
                            .where((g) => widget.showCancelled || !g.cancelled)
                            .toList(),
                      ),
                    )
                    .toList()
                : entries
                    .where((g) => widget.showCancelled || !g.cancelled)
                    .map(
                      (g) => g is GradeDetail
                          ? GradeWidget(grade: g)
                          : ObservationWidget(
                              observation: g,
                            ),
                    )
                    .toList()
            : widget.noInternet
                ? []
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
      ),
    );
  }
}

const lineThrough = TextStyle(decoration: TextDecoration.lineThrough);

class GradeWidget extends StatelessWidget {
  final GradeDetail grade;

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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!grade.description.isNullOrEmpty)
                Text(
                  grade.description,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              Text(
                "${DateFormat("dd.MM.yy").format(grade.date)}: ${grade.type} - ${grade.weightPercentage}%",
                style: grade.cancelled ? lineThrough : null,
              ),
              Text(
                grade.created,
                style: Theme.of(context).textTheme.caption,
              ),
              if (!grade.cancelledDescription.isNullOrEmpty)
                Text(
                  grade.cancelledDescription,
                  style: Theme.of(context).textTheme.caption,
                ),
            ],
          ),
          trailing: Text(
            grade.gradeFormatted,
            style: grade.cancelled ? lineThrough : null,
          ),
          isThreeLine: true,
        ),
        if (grade.competences?.isNotEmpty == true)
          for (final c in grade.competences)
            CompetenceWidget(
              competence: c,
              cancelled: grade.cancelled,
            ),
      ],
    );
  }
}

class ObservationWidget extends StatelessWidget {
  final Observation observation;

  const ObservationWidget({Key key, this.observation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        observation.typeName,
        style: observation.cancelled ? lineThrough : null,
      ),
      subtitle: Text(
        "${DateFormat("dd/MM/yy").format(observation.date)}${observation.note.isNullOrEmpty ? "" : ":\n${observation.note}"}",
        style: observation.cancelled ? lineThrough : null,
      ),
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
            style: cancelled ? lineThrough : null,
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
  final List<DetailEntry> entries;

  const GradeTypeWidget({Key key, this.typeName, this.entries})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final displayGrades = entries
        .map(
          (g) => g is GradeDetail
              ? GradeWidget(grade: g)
              : ObservationWidget(
                  observation: g,
                ),
        )
        .toList();
    return displayGrades.isEmpty
        ? SizedBox()
        : ExpansionTile(
            title: Text(typeName),
            children: displayGrades,
            initiallyExpanded: true,
          );
  }
}
