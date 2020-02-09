import 'package:built_value/built_value.dart';
import 'package:built_redux/built_redux.dart';

part 'login_actions.g.dart';

abstract class LoginActions extends ReduxActions {
  LoginActions._();
  factory LoginActions() => _$LoginActions();

  ActionDispatcher<LoginPayload> login;
  ActionDispatcher<LoggedInPayload> loggedIn;
  ActionDispatcher<LoginFailedPayload> loginFailed;
  ActionDispatcher<LogoutPayload> logout;
  ActionDispatcher<void> updateLogout;
  ActionDispatcher<void> loggingIn;
  ActionDispatcher<void> automaticallyReloggedIn;
}

abstract class LoginPayload implements Built<LoginPayload, LoginPayloadBuilder> {
  LoginPayload._();
  factory LoginPayload([void Function(LoginPayloadBuilder) updates]) = _$LoginPayload;

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoginPayload')
          ..add('user', user)
          // ..add('pass', pass) // do not include the password
          ..add('url', url)
          ..add('fromStorage', fromStorage)
          ..add('offlineEnabled', offlineEnabled))
        .toString();
  }

  static void _initializeBuilder(LoginPayloadBuilder b) {
    b..offlineEnabled = false;
  }

  String get user;
  String get pass;
  String get url;
  bool get fromStorage;
  bool get offlineEnabled;
}

abstract class LoggedInPayload implements Built<LoggedInPayload, LoggedInPayloadBuilder> {
  LoggedInPayload._();
  factory LoggedInPayload([void Function(LoggedInPayloadBuilder) updates]) = _$LoggedInPayload;

  String get username;
  bool get fromStorage;
}

abstract class LoginFailedPayload implements Built<LoginFailedPayload, LoginFailedPayloadBuilder> {
  LoginFailedPayload._();
  factory LoginFailedPayload([void Function(LoginFailedPayloadBuilder) updates]) =
      _$LoginFailedPayload;

  String get cause;
  String get username;
  bool get fromStorage;
  bool get offlineEnabled;
  bool get noInternet;
}

abstract class LogoutPayload implements Built<LogoutPayload, LogoutPayloadBuilder> {
  LogoutPayload._();
  factory LogoutPayload([void Function(LogoutPayloadBuilder) updates]) = _$LogoutPayload;

  bool get hard;
  bool get forced;
}
