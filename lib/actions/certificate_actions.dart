import 'package:built_redux/built_redux.dart';

part 'certificate_actions.g.dart';

abstract class CertificateActions extends ReduxActions {
  factory CertificateActions() => _$CertificateActions();
  CertificateActions._();

  ActionDispatcher<void> load;
  ActionDispatcher<String> loaded;
}
