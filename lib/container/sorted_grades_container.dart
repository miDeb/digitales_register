import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/grades_actions.dart';
import '../actions/settings_actions.dart';
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
              LoadSubjectDetailsAction(
                (b) => b
                  ..subject = s.toBuilder()
                  ..semester = store.state.gradesState.semester.toBuilder(),
              ),
            )),
        showCancelledCallback = ((s) => store.dispatch(
            SetGradesShowCancelledAction((b) => b..showCancelled = s))),
        sortByTypeCallback = ((s) => store
            .dispatch(SetGradesTypeSortedAction((b) => b..typeSorted = s)));
}
