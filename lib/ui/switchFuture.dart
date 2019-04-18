import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';

class _ViewModel {
  final bool future;
  final VoidCallback switchFuture;

  _ViewModel(this.future, this.switchFuture);
  _ViewModel.from(Store<AppState> store)
      : future = store.state.dayState.future,
        switchFuture = (() => store.dispatch(SwitchFutureAction()));

  @override
  operator ==(other) {
    return other is _ViewModel && other.future == this.future;
  }
}

class SwitchFuture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      builder: (context, vm) {
        return Center(
          child: RaisedButton(
            child: Text(vm.future ? "Vergangenheit" : "Zukunft"),
            onPressed: vm.switchFuture,
          ),
        );
      },
      converter: (store) {
        return _ViewModel.from(store);
      },
    );
  }
}
