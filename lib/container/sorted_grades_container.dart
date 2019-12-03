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

typedef void ViewSubjectDetailCallback(Subject s);
typedef void SetBoolCallback(bool byType);

class SortedGradesViewModel {
  final List<Subject> subjects;
  final Semester semester;
  final bool sortByType, showCancelled;
  final ViewSubjectDetailCallback viewSubjectDetail;
  final SetBoolCallback sortByTypeCallback, showCancelledCallback;
  SortedGradesViewModel.from(Store<AppState> store)
      : subjects = store.state.gradesState.subjects.toList(),
        sortByType = store.state.settingsState.typeSorted,
        semester = store.state.gradesState.semester,
        showCancelled = store.state.settingsState.showCancelled == true,
        viewSubjectDetail = ((s) => store.dispatch(
            LoadSubjectDetailsAction(s, store.state.gradesState.semester))),
        showCancelledCallback =
            ((s) => store.dispatch(SetGradesShowCancelledAction(s))),
        sortByTypeCallback =
            ((s) => store.dispatch(SetGradesTypeSortedAction(s)));
}
