import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../actions/profile_actions.dart';
import '../app_state.dart';
import '../ui/change_email.dart';

class ChangeEmailContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, void>(
      connect: (_) {},
      builder: (context, state, api) {
        return ChangeEmail(
          changeEmail: (pass, email) => api.profileActions.changeEmail(
            ChangeEmailPayload(
              (b) => b
                ..pass = pass
                ..email = email,
            ),
          ),
        );
      },
    );
  }
}
