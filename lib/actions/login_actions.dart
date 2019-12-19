import 'package:built_value/built_value.dart';
part 'login_actions.g.dart';

abstract class LoginAction implements Built<LoginAction, LoginActionBuilder> {
  LoginAction._();
  factory LoginAction([void Function(LoginActionBuilder) updates]) =
      _$LoginAction;

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoginAction')
          ..add('user', user)
          // ..add('pass', pass) // do not include the password
          ..add('url', url)
          ..add('fromStorage', fromStorage)
          ..add('offlineEnabled', offlineEnabled))
        .toString();
  }

  static void _initializeBuilder(LoginActionBuilder b) {
    b..offlineEnabled = false;
  }

  String get user;
  String get pass;
  String get url;
  bool get fromStorage;
  bool get offlineEnabled;
}

abstract class LoggedInAction
    implements Built<LoggedInAction, LoggedInActionBuilder> {
  LoggedInAction._();
  factory LoggedInAction([void Function(LoggedInActionBuilder) updates]) =
      _$LoggedInAction;

  String get username;
  bool get fromStorage;
}

abstract class LoginFailedAction
    implements Built<LoginFailedAction, LoginFailedActionBuilder> {
  LoginFailedAction._();
  factory LoginFailedAction([void Function(LoginFailedActionBuilder) updates]) =
      _$LoginFailedAction;

  String get cause;
  String get username;
  bool get fromStorage;
  bool get offlineEnabled;
  bool get noInternet;
}

abstract class LogoutAction
    implements Built<LogoutAction, LogoutActionBuilder> {
  LogoutAction._();
  factory LogoutAction([void Function(LogoutActionBuilder) updates]) =
      _$LogoutAction;

  bool get hard;
  bool get forced;
}

abstract class UpdateLogoutAction
    implements Built<UpdateLogoutAction, UpdateLogoutActionBuilder> {
  UpdateLogoutAction._();
  factory UpdateLogoutAction(
          [void Function(UpdateLogoutActionBuilder) updates]) =
      _$UpdateLogoutAction;
}

abstract class LoggingInAction
    implements Built<LoggingInAction, LoggingInActionBuilder> {
  LoggingInAction._();
  factory LoggingInAction([void Function(LoggingInActionBuilder) updates]) =
      _$LoggingInAction;
}

abstract class LoggedInAgainAutomatically
    implements
        Built<LoggedInAgainAutomatically, LoggedInAgainAutomaticallyBuilder> {
  LoggedInAgainAutomatically._();
  factory LoggedInAgainAutomatically(
          [void Function(LoggedInAgainAutomaticallyBuilder) updates]) =
      _$LoggedInAgainAutomatically;
}
