import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'profile_actions.g.dart';

abstract class ProfileActions extends ReduxActions {
  ProfileActions._();
  factory ProfileActions() => _$ProfileActions();

  ActionDispatcher<void> load;
  ActionDispatcher<dynamic> loaded;
  ActionDispatcher<bool> sendNotificationEmails;
  ActionDispatcher<ChangeEmailPayload> changeEmail;
}

abstract class ChangeEmailPayload
    implements Built<ChangeEmailPayload, ChangeEmailPayloadBuilder> {
  ChangeEmailPayload._();
  factory ChangeEmailPayload(
          [void Function(ChangeEmailPayloadBuilder) updates]) =
      _$ChangeEmailPayload;

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
