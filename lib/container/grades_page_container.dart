import 'package:dr/actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/ui/grades_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class GradesPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GradesPageViewModel>(
      builder: (BuildContext context, GradesPageViewModel vm) {
        return GradesPage(
          vm: vm,
        );
      },
      distinct: true,
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
  @override
  operator ==(other) {
    return other is GradesPageViewModel &&
        other.showSemester == showSemester &&
        other.loading == loading;
  }

  GradesPageViewModel.from(Store<AppState> store)
      : showSemester = store.state.gradesState.semester,
        changeSemester = ((newSemester) =>
            store.dispatch(SetGradesSemesterAction(newSemester))),
        loading = store.state.gradesState.loading;
}
