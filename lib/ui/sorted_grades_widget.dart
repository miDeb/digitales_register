import 'package:badges/badges.dart';
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
  final VoidCallback showGradeCalculator;

  const SortedGradesWidget({
    Key? key,
    required this.vm,
    required this.viewSubjectDetail,
    required this.sortByTypeCallback,
    required this.showCancelledCallback,
    required this.showGradeCalculator,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile.adaptive(
          title: const Text("Noten nach Art sortieren"),
          onChanged: sortByTypeCallback,
          value: vm.sortByType,
        ),
        SwitchListTile.adaptive(
          title: const Text("Gelöschte Noten anzeigen"),
          onChanged: showCancelledCallback,
          value: vm.showCancelled!,
        ),
        const Divider(
          height: 0,
        ),
        for (final s in vm.subjects)
          SubjectWidget(
            subject: s,
            sortByType: vm.sortByType,
            viewSubjectDetail: () => viewSubjectDetail(s),
            showCancelled: vm.showCancelled!,
            semester: vm.semester,
            noInternet: vm.noInternet!,
            ignoredForAverage: vm.ignoredSubjectsForAverage.any(
                (element) => element.toLowerCase() == s.name.toLowerCase()),
          ),
        if (vm.subjects.any(
          (s) => vm.ignoredSubjectsForAverage.any(
            (element) => element.toLowerCase() == s.name.toLowerCase(),
          ),
        ))
          const ListTile(
            title: Text(
              "* Du hast dieses Fach aus dem Notendurchschnitt ausgeschlossen",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListTile(
            title: Row(
              children: const [
                Text("Notenrechner"),
              ],
            ),
            subtitle:
                const Text("Berechne den Durchschnitt von beliebigen Noten"),
            onTap: showGradeCalculator,
          ),
        ),
      ],
    );
  }
}

class SubjectWidget extends StatefulWidget {
  final bool sortByType, showCancelled, noInternet, ignoredForAverage;
  final Subject subject;
  final Semester semester;
  final VoidCallback viewSubjectDetail;

  const SubjectWidget(
      {Key? key,
      required this.sortByType,
      required this.subject,
      required this.viewSubjectDetail,
      required this.showCancelled,
      required this.semester,
      required this.noInternet,
      required this.ignoredForAverage})
      : super(key: key);

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget>
    with TickerProviderStateMixin {
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
        key: ValueKey(widget.subject.id),
        title: Text.rich(
          TextSpan(
            text: widget.subject.name,
            children: [
              if (widget.ignoredForAverage)
                const TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
        leading: Text.rich(
          TextSpan(
            text: 'Ø ',
            children: <TextSpan>[
              TextSpan(
                text: widget.subject.averageFormatted(widget.semester),
              ),
            ],
          ),
        ),
        trailing:
            widget.noInternet && entries == null ? const SizedBox() : null,
        onExpansionChanged: (expansion) {
          closed = !expansion;
          if (expansion) {
            widget.viewSubjectDetail();
          }
        },
        initiallyExpanded: !closed,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            vsync: this,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (currentChild != null) currentChild,
                    for (final child in previousChildren)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: child,
                      ),
                  ],
                );
              },
              duration: const Duration(milliseconds: 200),
              child: entries != null
                  ? Column(
                      // we're using a UniqueKey here so that the framework
                      // detects a change on every rebuild. There would be no
                      // animations otherwise, as the Column as the direct child
                      // of the AnimatedSwitcher always stays the same (just different children).
                      key: UniqueKey(),
                      children: [
                        if (widget.sortByType)
                          ...Subject.sortByType(entries).entries.map(
                                (entry) => GradeTypeWidget(
                                  typeName: entry.key,
                                  entries: entry.value
                                      .where((g) =>
                                          widget.showCancelled || !g.cancelled)
                                      .toList(),
                                ),
                              )
                        else
                          ...entries
                              .where(
                                  (g) => widget.showCancelled || !g.cancelled)
                              .map(
                                (g) => g is GradeDetail
                                    ? GradeWidget(grade: g)
                                    : ObservationWidget(
                                        observation: g as Observation,
                                      ),
                              )
                      ],
                    )
                  : (!widget.noInternet)
                      ? const LinearProgressIndicator()
                      : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

const lineThrough = TextStyle(decoration: TextDecoration.lineThrough);

class GradeWidget extends StatelessWidget {
  final GradeDetail grade;

  const GradeWidget({Key? key, required this.grade}) : super(key: key);
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
                  grade.description!,
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
                  grade.cancelledDescription!,
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
        if (grade.competences.isNotEmpty)
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

  const ObservationWidget({Key? key, required this.observation})
      : super(key: key);
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

  const CompetenceWidget(
      {Key? key, required this.competence, required this.cancelled})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, bottom: 16, right: 8),
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

  const Star({Key? key, required this.filled}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Icon(filled ? Icons.star : Icons.star_border);
  }
}

class GradeTypeWidget extends StatelessWidget {
  final String typeName;
  final List<DetailEntry> entries;

  const GradeTypeWidget(
      {Key? key, required this.typeName, required this.entries})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final displayGrades = entries
        .map(
          (g) => g is GradeDetail
              ? GradeWidget(grade: g)
              : ObservationWidget(
                  observation: g as Observation,
                ),
        )
        .toList();
    return displayGrades.isEmpty
        ? const SizedBox()
        : ExpansionTile(
            title: Text(typeName),
            initiallyExpanded: true,
            children: displayGrades,
          );
  }
}
