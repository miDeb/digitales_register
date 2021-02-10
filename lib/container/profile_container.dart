import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:tuple/tuple.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/profile.dart';

class ProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, Tuple2<bool, ProfileState>>(
      builder: (context, vm, actions) {
        return Profile(
          profileState: vm.item2,
          noInternet: vm.item1,
          setSendNotificationEmails: actions
              .profileActions.sendNotificationEmails,
          changeEmail:
              actions.routingActions.showChangeEmail,
          changePass: () => actions.loginActions.showChangePass(false),
        );
      },
      connect: (AppState state) {
        return Tuple2(state.noInternet, state.profileState);
      },
    );
  }
}
