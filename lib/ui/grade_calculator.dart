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

import 'package:built_collection/built_collection.dart';
import 'package:deleteable_tile/deleteable_tile.dart';
import 'package:dr/l10n/l10n.dart' as l10n;
import 'package:dr/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:tuple/tuple.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../util.dart';
import 'dialog.dart';

bool isGradeInRange(int grade) {
  return grade >= 0 && grade <= 1000;
}

int? tryParseFormattedGrade(String grade) {
  bool matchesWholeInput(RegExpMatch? match) {
    return match != null && match.start == 0 && match.end == match.input.length;
  }

  final accurate = RegExp(r"(\d+)(?:[.,](\d{1,2}))?").firstMatch(grade);
  if (matchesWholeInput(accurate)) {
    final major = accurate!.group(1)!;
    final minor = accurate.group(2);
    final majorParsed = int.tryParse(major);
    if (majorParsed == null) {
      return null;
    }
    var minorParsed = minor != null ? int.tryParse(minor) : 0;
    if (minorParsed == null) {
      return null;
    }
    if (minor?.length == 1) {
      // parse .5 as 50/100
      minorParsed *= 10;
    }
    final combinedGrade = majorParsed * 100 + minorParsed;
    if (!isGradeInRange(combinedGrade)) {
      return null;
    }
    return combinedGrade;
  }

  final less = RegExp(r"(\d+)-").firstMatch(grade);
  if (matchesWholeInput(less)) {
    final lessParsed = int.tryParse(less!.group(1)!);
    if (lessParsed == null) {
      return null;
    }
    final combinedGrade = lessParsed * 100 - 25;
    if (!isGradeInRange(combinedGrade)) {
      return null;
    }
    return combinedGrade;
  }

  final more = RegExp(r"(\d+)\+").firstMatch(grade);
  if (matchesWholeInput(more)) {
    final moreParsed = int.tryParse(more!.group(1)!);
    if (moreParsed == null) {
      return null;
    }
    final combinedGrade = moreParsed * 100 + 25;
    if (!isGradeInRange(combinedGrade)) {
      return null;
    }
    return combinedGrade;
  }

  final between = RegExp(r"(\d+)[-/](\d+)").firstMatch(grade);
  if (matchesWholeInput(between)) {
    final startParsed = int.tryParse(between!.group(1)!);
    if (startParsed == null) {
      return null;
    }
    final endParsed = int.tryParse(between.group(2)!);
    if (endParsed == null) {
      return null;
    }
    if (endParsed != startParsed + 1) {
      return null;
    }
    final combinedGrade = startParsed * 100 + 50;
    if (!isGradeInRange(combinedGrade)) {
      return null;
    }
    return combinedGrade;
  }

  return null;
}

String _calculateAverage(List<_Grade> grades) {
  var weights = 0;
  var sum = 0;
  for (final grade in grades) {
    weights += grade.weightPercentage;
    sum += grade.grade * grade.weightPercentage;
  }
  if (weights == 0) {
    return "/";
  }
  final average = sum ~/ weights;
  return gradeAverageFormat.format(average / 100);
}

typedef _UpdateGrade = void Function(_Grade previous, _Grade? updated);

class GradeCalculator extends StatefulWidget {
  const GradeCalculator({Key? key}) : super(key: key);
  @override
  _GradeCalculatorState createState() => _GradeCalculatorState();
}

class _Grade {
  int grade;
  int weightPercentage;
  String? description;

  _Grade({
    required this.grade,
    required this.weightPercentage,
    this.description,
  });
}

class _GradeCalculatorState extends State<GradeCalculator> {
  final List<_Grade> grades = [];
  Future<void> addGrade() async {
    final Tuple2<int, int>? grade = await showDialog(
      context: context,
      builder: (context) {
        int? grade;
        int? weight;
        return StatefulBuilder(
          builder: (context, setState) => InfoDialog(
            title: Text(createNewGrade()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Input(
                  autofocus: true,
                  showErrorForEmptyInput: false,
                  inputType: _InputType.grade,
                  updateValue: (value) {
                    setState(() {
                      grade = value;
                    });
                  },
                ),
                _Input(
                  showErrorForEmptyInput: false,
                  inputType: _InputType.weight,
                  updateValue: (value) {
                    setState(() {
                      weight = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  l10n.cancel(),
                ),
              ),
              ElevatedButton(
                onPressed: grade != null && weight != null
                    ? () {
                        Navigator.pop(context, Tuple2(grade!, weight!));
                      }
                    : null,
                child: Text(
                  l10n.add(),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (grade != null) {
      setState(() {
        grades.add(_Grade(grade: grade.item1, weightPercentage: grade.item2));
      });
    }
  }

  Future<void> importGrades() async {
    final List<_Grade>? result = await Navigator.of(
      context,
      rootNavigator: true,
    ).push(
      MaterialPageRoute(
        builder: (context) => _ImportGradesContainer(),
        fullscreenDialog: true,
      ),
    );
    if (result == null) {
      return;
    }
    assert(grades.isEmpty);
    assert(result.isNotEmpty);
    setState(() {
      grades.addAll(result);
    });
  }

  void updateGrade(_Grade previous, _Grade? updated) {
    setState(() {
      if (updated == null) {
        grades.remove(previous);
      } else {
        assert(grades.contains(previous));
        previous.description = updated.description;
        previous.grade = updated.grade;
        previous.weightPercentage = updated.weightPercentage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showGreeting = grades.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gradeCalculator()),
      ),
      body: AnimatedCrossFade(
        firstChild: Greeting(
          import: importGrades,
          add: addGrade,
        ),
        secondChild: GradesList(
          grades: grades,
          updateGrade: updateGrade,
          addGrade: addGrade,
        ),
        crossFadeState:
            showGreeting ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 250),
      ),
      floatingActionButton: showGreeting
          ? null
          : FloatingActionButton.extended(
              onPressed: addGrade,
              label: Text(l10n.addGrade()),
              icon: const Icon(Icons.add),
            ),
    );
  }
}

@visibleForTesting
class GradesList extends StatelessWidget {
  final List<_Grade> grades;
  final _UpdateGrade updateGrade;
  final VoidCallback addGrade;

  const GradesList(
      {Key? key,
      required this.grades,
      required this.updateGrade,
      required this.addGrade})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 2,
          child: ListTile(
            title: Text(l10n.average()),
            subtitle: Text(
              "${grades.length} ${l10n.grades(grades.length)}",
            ),
            trailing: Text(_calculateAverage(grades)),
          ),
        ),
        if (grades.isNotEmpty)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8).copyWith(bottom: 160),
              children: [
                for (final grade in grades)
                  GradeTile(
                    key: ObjectKey(grade),
                    grade: grade,
                    updateGrade: updateGrade,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

@visibleForTesting
class GradeTile extends StatelessWidget {
  final _Grade grade;
  final _UpdateGrade updateGrade;

  const GradeTile({Key? key, required this.grade, required this.updateGrade})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeleteableTile(
      onDeleted: () {
        updateGrade(grade, null);
      },
      icon: const Icon(Icons.close),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: _Input(
                      initial: grade.weightPercentage.toString(),
                      inputType: _InputType.weight,
                      updateValue: (value) {
                        if (value != null) {
                          updateGrade(
                            grade,
                            _Grade(
                              grade: grade.grade,
                              weightPercentage: value,
                              // show no description
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _Input(
                      initial: formatGradeFromInt(grade.grade),
                      inputType: _InputType.grade,
                      updateValue: (value) {
                        if (value != null) {
                          updateGrade(
                            grade,
                            _Grade(
                              grade: value,
                              weightPercentage: grade.weightPercentage,
                              // show no description anymore
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (grade.description != null)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  grade.description!,
                  style: Theme.of(context).textTheme.caption,
                ),
              )
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class Greeting extends StatelessWidget {
  final VoidCallback import, add;

  const Greeting({Key? key, required this.import, required this.add})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            l10n.gradeCalculatorHint(),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: import,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.save_alt),
                  const SizedBox(width: 8),
                  Text(l10n.importGrades()),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: add,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add),
                  const SizedBox(width: 8),
                  Text(l10n.addGrade()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImportGrades extends StatefulWidget {
  final List<Subject> subjects;

  const _ImportGrades({Key? key, required this.subjects}) : super(key: key);
  @override
  _ImportGradesState createState() => _ImportGradesState();
}

class _ImportGradesContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, BuiltList<Subject>>(
      connect: (state) => state.gradesState.subjects,
      builder: (context, state, actions) => _ImportGrades(
        subjects: state.toList(),
      ),
    );
  }
}

class _ImportGradesState extends State<_ImportGrades> {
  Subject? selectedSubject;
  Semester? selectedSemester;
  List<_Grade>? grades;

  void _recalculateGrades() {
    setState(() {
      if (selectedSemester != null && selectedSubject != null) {
        grades = selectedSubject!
                .basicGrades(selectedSemester!)
                ?.where((e) => !e.cancelled)
                .map(
                  (e) => _Grade(
                    grade: e.grade!,
                    weightPercentage: e.weightPercentage,
                    description: "${selectedSubject!.name} · ${e.type}",
                  ),
                )
                .toList() ??
            [];
      } else {
        grades = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.importGrades()),
      ),
      body: Column(
        children: [
          DropdownButton<Subject>(
            items: [
              for (final subject in widget.subjects)
                DropdownMenuItem(
                  value: subject,
                  child: Text(subject.name),
                ),
            ],
            value: selectedSubject,
            hint: Text(l10n.selectSubject()),
            onChanged: (subject) {
              setState(() {
                selectedSubject = subject;
              });
              _recalculateGrades();
            },
          ),
          const SizedBox(
            height: 16,
          ),
          RadioListTile<Semester>(
            title: Text(l10n.firstSemester()),
            value: Semester.first,
            groupValue: selectedSemester,
            onChanged: (value) {
              setState(() {
                selectedSemester = value;
              });
              _recalculateGrades();
            },
          ),
          RadioListTile<Semester>(
            title: Text(l10n.secondSemester()),
            value: Semester.second,
            groupValue: selectedSemester,
            onChanged: (value) {
              setState(() {
                selectedSemester = value;
              });
              _recalculateGrades();
            },
          ),
          RadioListTile<Semester>(
            title: Text(l10n.bothSemester()),
            value: Semester.all,
            groupValue: selectedSemester,
            onChanged: (value) {
              setState(() {
                selectedSemester = value;
              });
              _recalculateGrades();
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Center(
            child: ElevatedButton(
              onPressed: selectedSemester != null &&
                      selectedSubject != null &&
                      grades!.isNotEmpty
                  ? () {
                      Navigator.pop(context, grades);
                    }
                  : null,
              child: Text(l10n.import()),
            ),
          ),
          if (selectedSemester != null &&
              selectedSubject != null &&
              grades!.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.noGradesAvailable(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

enum _InputType { grade, weight }

class _Input extends StatefulWidget {
  final _InputType inputType;
  final String? initial;
  final void Function(int?) updateValue;
  final bool showErrorForEmptyInput;
  final bool autofocus;

  const _Input({
    Key? key,
    required this.inputType,
    this.initial,
    required this.updateValue,
    this.showErrorForEmptyInput = true,
    this.autofocus = false,
  }) : super(key: key);
  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<_Input> {
  late final TextEditingController controller;
  final focusNode = FocusNode();

  int? getValue() {
    final value = controller.text;
    switch (widget.inputType) {
      case _InputType.grade:
        return tryParseFormattedGrade(value);
      case _InputType.weight:
        final percentage = int.tryParse(value);
        if (percentage != null && percentage >= 0 && percentage <= 100) {
          return percentage;
        } else {
          return null;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initial);
    focusNode.addListener(() {
      setState(() {
        // update error text
      });
    });
  }

  bool isValid() => getValue() != null;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.autofocus,
      keyboardType:
          widget.inputType == _InputType.weight ? TextInputType.number : null,
      focusNode: focusNode,
      controller: controller,
      decoration: InputDecoration(
        errorText: isValid() ||
                (!widget.showErrorForEmptyInput && controller.text.isEmpty) ||
                focusNode.hasFocus
            ? null
            : l10n.invalidValue(),
        labelText: widget.inputType == _InputType.grade
            ? l10n.grades(1)
            : l10n.weighting(),
        suffixText: widget.inputType == _InputType.weight ? "%" : null,
      ),
      onChanged: (_) {
        widget.updateValue(getValue());
        setState(() {
          // will show an error after checking the controller
        });
      },
    );
  }
}
