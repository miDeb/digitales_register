import 'package:dr/ui/certificate.dart';

import '../actions/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../app_state.dart';

class CertificateContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, String>(
      connect: (state) {
        return state.certificateState.html;
      },
      builder: (context, vm, actions) {
        return Certificate(vm: vm);
      },
    );
  }
}
