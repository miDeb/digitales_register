import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:tuple/tuple.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import '../ui/messages.dart';

class MessagesPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, Tuple2<MessagesState, bool>>(
      builder: (context, vm, actions) {
        return MessagesPage(
          state: vm.item1,
          noInternet: vm.item2,
          onDownloadFile: actions.messagesActions.downloadFile,
          onOpenFile: actions.messagesActions.openFile,
        );
      },
      connect: (state) {
        return Tuple2(state.messagesState, state.noInternet);
      },
    );
  }
}
