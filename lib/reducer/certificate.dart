import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/certificate_actions.dart';

import '../app_state.dart';

final certificateReducerBuilder =
    NestedReducerBuilder<AppState, AppStateBuilder, CertificateState, CertificateStateBuilder>(
  (s) => s.certificateState,
  (b) => b.certificateState,
)..add(CertificateActionsNames.loaded, _loaded);

void _loaded(CertificateState state, Action<String> action, CertificateStateBuilder builder) {
  builder..html = action.payload;
}
