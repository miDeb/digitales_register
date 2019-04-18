import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../app_state.dart';
import '../ui/absences_page.dart';

class AbsencesPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AbsenceState>(
      builder: (BuildContext context, vm) {
        return AbsencesPage(state: vm);
      },
      converter: (Store<AppState> store) {
        return store.state.absenceState;
      },
    );
  }
}
