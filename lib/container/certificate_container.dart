import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/certificate.dart';

class CertificateContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, CertificateViewModel>(
      connect: (state) {
        return CertificateViewModel(
            state.certificateState.html, state.noInternet);
      },
      builder: (context, vm, actions) {
        return Certificate(vm: vm);
      },
    );
  }
}

class CertificateViewModel {
  final String html;
  final bool noInternet;

  CertificateViewModel(this.html, this.noInternet);
}
