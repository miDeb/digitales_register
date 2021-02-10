import 'package:built_redux/built_redux.dart';

part 'certificate_actions.g.dart';

abstract class CertificateActions extends ReduxActions {
  factory CertificateActions() => _$CertificateActions();
  CertificateActions._();

  abstract final VoidActionDispatcher load;
  abstract final ActionDispatcher<String> loaded;
}
