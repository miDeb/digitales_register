import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/grades_page.dart';

class GradesPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GradesPageViewModel>(
      builder: (BuildContext context, GradesPageViewModel vm) {
        return GradesPage(
          vm: vm,
        );
      },
      converter: (Store store) {
        return GradesPageViewModel.from(store);
      },
    );
  }
}

class GradesPageViewModel {
  final Semester showSemester;
  final ValueChanged<Semester> changeSemester;
  final bool loading;

  GradesPageViewModel.from(Store<AppState> store)
      : showSemester = store.state.gradesState.semester,
        changeSemester = ((newSemester) =>
            store.dispatch(SetGradesSemesterAction(newSemester))),
        loading = store.state.gradesState.loading;
}
