import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/pass_reset.dart';

class PassResetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, ResetPassState>(
      connect: (AppState appState) => appState.loginState.resetPassState,
      builder: (context, state, actions) {
        return PassReset(
          message: state.message,
          failure: state.failure,
          resetPass: actions.loginActions.resetPass,
          onClose: actions.load,
        );
      },
    );
  }
}
