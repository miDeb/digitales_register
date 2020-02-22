import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../actions/login_actions.dart';
import '../app_state.dart';
import '../ui/request_pass_reset.dart';

class RequestPassResetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, ResetPassState>(
      connect: (AppState appState) => appState.loginState.resetPassState,
      builder: (context, state, actions) {
        return RequestPassReset(
          resetPass: (user, email) => actions.loginActions.requestPassReset(
            RequestPassResetPayload(
              (b) => b
                ..user = user
                ..email = email,
            ),
          ),
          message: state.message,
          failure: state.failure,
        );
      },
    );
  }
}
