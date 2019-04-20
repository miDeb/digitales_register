import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/sorted_grades_widget.dart';

class SortedGradesContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SortedGradesViewModel>(
      converter: (Store store) {
        return SortedGradesViewModel.from(store);
      },
      builder: (BuildContext context, SortedGradesViewModel vm) {
        return SortedGradesWidget(vm: vm);
      },
    );
  }
}

typedef void ViewSubjectDetailCallback(AllSemesterSubject s);
typedef void SetBoolCallback(bool byType);

class SortedGradesViewModel {
  final List<AllSemesterSubject> subjects;
  final int semester;
  final bool sortByType, noAvgForAllSemester, showCancelled;
  final ViewSubjectDetailCallback viewSubjectDetail;
  final SetBoolCallback sortByTypeCallback, showCancelledCallback;
  SortedGradesViewModel.from(Store<AppState> store)
      : subjects = store.state.gradesState.subjects.toList(),
        sortByType = store.state.settingsState.typeSorted,
        semester = store.state.gradesState.semester.n,
        showCancelled = store.state.settingsState.showCancelled == true,
        viewSubjectDetail =
            ((s) => store.dispatch(LoadSubjectDetailsAction(s))),
        showCancelledCallback =
            ((s) => store.dispatch(SetGradesShowCancelledAction(s))),
        sortByTypeCallback =
            ((s) => store.dispatch(SetGradesTypeSortedAction(s))),
        noAvgForAllSemester = store.state.settingsState.noAverageForAllSemester;
}
