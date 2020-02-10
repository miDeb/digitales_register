import 'package:built_redux/built_redux.dart';

part 'certificate_actions.g.dart';

abstract class CertificateActions extends ReduxActions {
  CertificateActions._();
  factory CertificateActions() => _$CertificateActions();

  ActionDispatcher<void> load;
  ActionDispatcher<String> loaded;
}
