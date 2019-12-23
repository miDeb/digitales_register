import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/absences_page.dart';

class AbsencesPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, AbsencesState>(
      builder: (context, vm, actions) {
        return AbsencesPage(state: vm);
      },
      connect: (state) {
        return state.absencesState;
      },
    );
  }
}
