import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:tuple/tuple.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/absences_page.dart';

class AbsencesPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, Tuple2<AbsencesState, bool>>(
      builder: (context, vm, actions) {
        return AbsencesPage(
          state: vm.item1,
          noInternet: vm.item2,
        );
      },
      connect: (state) {
        return Tuple2(state.absencesState, state.noInternet);
      },
    );
  }
}
