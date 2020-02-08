// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$LoginActions extends LoginActions {
  factory _$LoginActions() => _$LoginActions._();
  _$LoginActions._() : super._();

  final login = ActionDispatcher<LoginAction>('LoginActions-login');
  final loggedIn = ActionDispatcher<LoggedInPayload>('LoginActions-loggedIn');
  final loginFailed = ActionDispatcher<LoginFailedPayload>('LoginActions-loginFailed');
  final logout = ActionDispatcher<LogoutPayload>('LoginActions-logout');
  final updateLogout = ActionDispatcher<void>('LoginActions-updateLogout');
  final loggingIn = ActionDispatcher<void>('LoginActions-loggingIn');
  final automaticallyReloggedIn = ActionDispatcher<void>('LoginActions-automaticallyReloggedIn');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    login.setDispatcher(dispatcher);
    loggedIn.setDispatcher(dispatcher);
    loginFailed.setDispatcher(dispatcher);
    logout.setDispatcher(dispatcher);
    updateLogout.setDispatcher(dispatcher);
    loggingIn.setDispatcher(dispatcher);
    automaticallyReloggedIn.setDispatcher(dispatcher);
  }
}

class LoginActionsNames {
  static final login = ActionName<LoginAction>('LoginActions-login');
  static final loggedIn = ActionName<LoggedInPayload>('LoginActions-loggedIn');
  static final loginFailed = ActionName<LoginFailedPayload>('LoginActions-loginFailed');
  static final logout = ActionName<LogoutPayload>('LoginActions-logout');
  static final updateLogout = ActionName<void>('LoginActions-updateLogout');
  static final loggingIn = ActionName<void>('LoginActions-loggingIn');
  static final automaticallyReloggedIn = ActionName<void>('LoginActions-automaticallyReloggedIn');
}

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginAction extends LoginAction {
  @override
  final String user;
  @override
  final String pass;
  @override
  final String url;
  @override
  final bool fromStorage;
  @override
  final bool offlineEnabled;

  factory _$LoginAction([void Function(LoginActionBuilder) updates]) =>
      (new LoginActionBuilder()..update(updates)).build();

  _$LoginAction._({this.user, this.pass, this.url, this.fromStorage, this.offlineEnabled})
      : super._() {
    if (user == null) {
      throw new BuiltValueNullFieldError('LoginAction', 'user');
    }
    if (pass == null) {
      throw new BuiltValueNullFieldError('LoginAction', 'pass');
    }
    if (url == null) {
      throw new BuiltValueNullFieldError('LoginAction', 'url');
    }
    if (fromStorage == null) {
      throw new BuiltValueNullFieldError('LoginAction', 'fromStorage');
    }
    if (offlineEnabled == null) {
      throw new BuiltValueNullFieldError('LoginAction', 'offlineEnabled');
    }
  }

  @override
  LoginAction rebuild(void Function(LoginActionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginActionBuilder toBuilder() => new LoginActionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginAction &&
        user == other.user &&
        pass == other.pass &&
        url == other.url &&
        fromStorage == other.fromStorage &&
        offlineEnabled == other.offlineEnabled;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, user.hashCode), pass.hashCode), url.hashCode), fromStorage.hashCode),
        offlineEnabled.hashCode));
  }
}

class LoginActionBuilder implements Builder<LoginAction, LoginActionBuilder> {
  _$LoginAction _$v;

  String _user;
  String get user => _$this._user;
  set user(String user) => _$this._user = user;

  String _pass;
  String get pass => _$this._pass;
  set pass(String pass) => _$this._pass = pass;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  bool _fromStorage;
  bool get fromStorage => _$this._fromStorage;
  set fromStorage(bool fromStorage) => _$this._fromStorage = fromStorage;

  bool _offlineEnabled;
  bool get offlineEnabled => _$this._offlineEnabled;
  set offlineEnabled(bool offlineEnabled) => _$this._offlineEnabled = offlineEnabled;

  LoginActionBuilder() {
    LoginAction._initializeBuilder(this);
  }

  LoginActionBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user;
      _pass = _$v.pass;
      _url = _$v.url;
      _fromStorage = _$v.fromStorage;
      _offlineEnabled = _$v.offlineEnabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginAction other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LoginAction;
  }

  @override
  void update(void Function(LoginActionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LoginAction build() {
    final _$result = _$v ??
        new _$LoginAction._(
            user: user,
            pass: pass,
            url: url,
            fromStorage: fromStorage,
            offlineEnabled: offlineEnabled);
    replace(_$result);
    return _$result;
  }
}

class _$LoggedInPayload extends LoggedInPayload {
  @override
  final String username;
  @override
  final bool fromStorage;

  factory _$LoggedInPayload([void Function(LoggedInPayloadBuilder) updates]) =>
      (new LoggedInPayloadBuilder()..update(updates)).build();

  _$LoggedInPayload._({this.username, this.fromStorage}) : super._() {
    if (username == null) {
      throw new BuiltValueNullFieldError('LoggedInPayload', 'username');
    }
    if (fromStorage == null) {
      throw new BuiltValueNullFieldError('LoggedInPayload', 'fromStorage');
    }
  }

  @override
  LoggedInPayload rebuild(void Function(LoggedInPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoggedInPayloadBuilder toBuilder() => new LoggedInPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoggedInPayload &&
        username == other.username &&
        fromStorage == other.fromStorage;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, username.hashCode), fromStorage.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoggedInPayload')
          ..add('username', username)
          ..add('fromStorage', fromStorage))
        .toString();
  }
}

class LoggedInPayloadBuilder implements Builder<LoggedInPayload, LoggedInPayloadBuilder> {
  _$LoggedInPayload _$v;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  bool _fromStorage;
  bool get fromStorage => _$this._fromStorage;
  set fromStorage(bool fromStorage) => _$this._fromStorage = fromStorage;

  LoggedInPayloadBuilder();

  LoggedInPayloadBuilder get _$this {
    if (_$v != null) {
      _username = _$v.username;
      _fromStorage = _$v.fromStorage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoggedInPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LoggedInPayload;
  }

  @override
  void update(void Function(LoggedInPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LoggedInPayload build() {
    final _$result = _$v ?? new _$LoggedInPayload._(username: username, fromStorage: fromStorage);
    replace(_$result);
    return _$result;
  }
}

class _$LoginFailedPayload extends LoginFailedPayload {
  @override
  final String cause;
  @override
  final String username;
  @override
  final bool fromStorage;
  @override
  final bool offlineEnabled;
  @override
  final bool noInternet;

  factory _$LoginFailedPayload([void Function(LoginFailedPayloadBuilder) updates]) =>
      (new LoginFailedPayloadBuilder()..update(updates)).build();

  _$LoginFailedPayload._(
      {this.cause, this.username, this.fromStorage, this.offlineEnabled, this.noInternet})
      : super._() {
    if (cause == null) {
      throw new BuiltValueNullFieldError('LoginFailedPayload', 'cause');
    }
    if (username == null) {
      throw new BuiltValueNullFieldError('LoginFailedPayload', 'username');
    }
    if (fromStorage == null) {
      throw new BuiltValueNullFieldError('LoginFailedPayload', 'fromStorage');
    }
    if (offlineEnabled == null) {
      throw new BuiltValueNullFieldError('LoginFailedPayload', 'offlineEnabled');
    }
    if (noInternet == null) {
      throw new BuiltValueNullFieldError('LoginFailedPayload', 'noInternet');
    }
  }

  @override
  LoginFailedPayload rebuild(void Function(LoginFailedPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginFailedPayloadBuilder toBuilder() => new LoginFailedPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginFailedPayload &&
        cause == other.cause &&
        username == other.username &&
        fromStorage == other.fromStorage &&
        offlineEnabled == other.offlineEnabled &&
        noInternet == other.noInternet;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, cause.hashCode), username.hashCode), fromStorage.hashCode),
            offlineEnabled.hashCode),
        noInternet.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoginFailedPayload')
          ..add('cause', cause)
          ..add('username', username)
          ..add('fromStorage', fromStorage)
          ..add('offlineEnabled', offlineEnabled)
          ..add('noInternet', noInternet))
        .toString();
  }
}

class LoginFailedPayloadBuilder implements Builder<LoginFailedPayload, LoginFailedPayloadBuilder> {
  _$LoginFailedPayload _$v;

  String _cause;
  String get cause => _$this._cause;
  set cause(String cause) => _$this._cause = cause;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  bool _fromStorage;
  bool get fromStorage => _$this._fromStorage;
  set fromStorage(bool fromStorage) => _$this._fromStorage = fromStorage;

  bool _offlineEnabled;
  bool get offlineEnabled => _$this._offlineEnabled;
  set offlineEnabled(bool offlineEnabled) => _$this._offlineEnabled = offlineEnabled;

  bool _noInternet;
  bool get noInternet => _$this._noInternet;
  set noInternet(bool noInternet) => _$this._noInternet = noInternet;

  LoginFailedPayloadBuilder();

  LoginFailedPayloadBuilder get _$this {
    if (_$v != null) {
      _cause = _$v.cause;
      _username = _$v.username;
      _fromStorage = _$v.fromStorage;
      _offlineEnabled = _$v.offlineEnabled;
      _noInternet = _$v.noInternet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginFailedPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LoginFailedPayload;
  }

  @override
  void update(void Function(LoginFailedPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LoginFailedPayload build() {
    final _$result = _$v ??
        new _$LoginFailedPayload._(
            cause: cause,
            username: username,
            fromStorage: fromStorage,
            offlineEnabled: offlineEnabled,
            noInternet: noInternet);
    replace(_$result);
    return _$result;
  }
}

class _$LogoutPayload extends LogoutPayload {
  @override
  final bool hard;
  @override
  final bool forced;

  factory _$LogoutPayload([void Function(LogoutPayloadBuilder) updates]) =>
      (new LogoutPayloadBuilder()..update(updates)).build();

  _$LogoutPayload._({this.hard, this.forced}) : super._() {
    if (hard == null) {
      throw new BuiltValueNullFieldError('LogoutPayload', 'hard');
    }
    if (forced == null) {
      throw new BuiltValueNullFieldError('LogoutPayload', 'forced');
    }
  }

  @override
  LogoutPayload rebuild(void Function(LogoutPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoutPayloadBuilder toBuilder() => new LogoutPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoutPayload && hard == other.hard && forced == other.forced;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, hard.hashCode), forced.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LogoutPayload')..add('hard', hard)..add('forced', forced))
        .toString();
  }
}

class LogoutPayloadBuilder implements Builder<LogoutPayload, LogoutPayloadBuilder> {
  _$LogoutPayload _$v;

  bool _hard;
  bool get hard => _$this._hard;
  set hard(bool hard) => _$this._hard = hard;

  bool _forced;
  bool get forced => _$this._forced;
  set forced(bool forced) => _$this._forced = forced;

  LogoutPayloadBuilder();

  LogoutPayloadBuilder get _$this {
    if (_$v != null) {
      _hard = _$v.hard;
      _forced = _$v.forced;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogoutPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LogoutPayload;
  }

  @override
  void update(void Function(LogoutPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LogoutPayload build() {
    final _$result = _$v ?? new _$LogoutPayload._(hard: hard, forced: forced);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
