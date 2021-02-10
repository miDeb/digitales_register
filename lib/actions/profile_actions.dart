import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'profile_actions.g.dart';

abstract class ProfileActions extends ReduxActions {
  factory ProfileActions() => _$ProfileActions();
  ProfileActions._();

  abstract final VoidActionDispatcher load;
  abstract final ActionDispatcher<Object> loaded;
  abstract final ActionDispatcher<bool> sendNotificationEmails;
  abstract final ActionDispatcher<ChangeEmailPayload> changeEmail;
}

abstract class ChangeEmailPayload
    implements Built<ChangeEmailPayload, ChangeEmailPayloadBuilder> {
  factory ChangeEmailPayload(
          [void Function(ChangeEmailPayloadBuilder)? updates]) =
      _$ChangeEmailPayload;
  ChangeEmailPayload._();

  String get pass;
  String get email;

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChangeEmailPayload')
          //..add('pass', pass) // do not include the pass
          ..add('email', email))
        .toString();
  }
}
