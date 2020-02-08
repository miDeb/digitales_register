// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$DashboardActions extends DashboardActions {
  factory _$DashboardActions() => _$DashboardActions._();
  _$DashboardActions._() : super._();

  final loaded = ActionDispatcher<DaysLoadedPayload>('DashboardActions-loaded');
  final notLoaded = ActionDispatcher<void>('DashboardActions-notLoaded');
  final load = ActionDispatcher<bool>('DashboardActions-load');
  final switchFuture = ActionDispatcher<void>('DashboardActions-switchFuture');
  final homeworkAdded = ActionDispatcher<HomeworkAddedPayload>('DashboardActions-homeworkAdded');
  final addReminder = ActionDispatcher<AddReminderPayload>('DashboardActions-addReminder');
  final deleteHomework = ActionDispatcher<Homework>('DashboardActions-deleteHomework');
  final toggleDone = ActionDispatcher<ToggleDonePayload>('DashboardActions-toggleDone');
  final markAsSeen = ActionDispatcher<Homework>('DashboardActions-markAsSeen');
  final markDeletedHomeworkAsSeen =
      ActionDispatcher<Day>('DashboardActions-markDeletedHomeworkAsSeen');
  final markAllAsSeen = ActionDispatcher<void>('DashboardActions-markAllAsSeen');
  final updateBlacklist =
      ActionDispatcher<BuiltList<HomeworkType>>('DashboardActions-updateBlacklist');
  final refresh = ActionDispatcher<void>('DashboardActions-refresh');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    loaded.setDispatcher(dispatcher);
    notLoaded.setDispatcher(dispatcher);
    load.setDispatcher(dispatcher);
    switchFuture.setDispatcher(dispatcher);
    homeworkAdded.setDispatcher(dispatcher);
    addReminder.setDispatcher(dispatcher);
    deleteHomework.setDispatcher(dispatcher);
    toggleDone.setDispatcher(dispatcher);
    markAsSeen.setDispatcher(dispatcher);
    markDeletedHomeworkAsSeen.setDispatcher(dispatcher);
    markAllAsSeen.setDispatcher(dispatcher);
    updateBlacklist.setDispatcher(dispatcher);
    refresh.setDispatcher(dispatcher);
  }
}

class DashboardActionsNames {
  static final loaded = ActionName<DaysLoadedPayload>('DashboardActions-loaded');
  static final notLoaded = ActionName<void>('DashboardActions-notLoaded');
  static final load = ActionName<bool>('DashboardActions-load');
  static final switchFuture = ActionName<void>('DashboardActions-switchFuture');
  static final homeworkAdded = ActionName<HomeworkAddedPayload>('DashboardActions-homeworkAdded');
  static final addReminder = ActionName<AddReminderPayload>('DashboardActions-addReminder');
  static final deleteHomework = ActionName<Homework>('DashboardActions-deleteHomework');
  static final toggleDone = ActionName<ToggleDonePayload>('DashboardActions-toggleDone');
  static final markAsSeen = ActionName<Homework>('DashboardActions-markAsSeen');
  static final markDeletedHomeworkAsSeen =
      ActionName<Day>('DashboardActions-markDeletedHomeworkAsSeen');
  static final markAllAsSeen = ActionName<void>('DashboardActions-markAllAsSeen');
  static final updateBlacklist =
      ActionName<BuiltList<HomeworkType>>('DashboardActions-updateBlacklist');
  static final refresh = ActionName<void>('DashboardActions-refresh');
}

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DaysLoadedPayload extends DaysLoadedPayload {
  @override
  final Object data;
  @override
  final bool future;
  @override
  final bool markNewOrChangedEntries;

  factory _$DaysLoadedPayload([void Function(DaysLoadedPayloadBuilder) updates]) =>
      (new DaysLoadedPayloadBuilder()..update(updates)).build();

  _$DaysLoadedPayload._({this.data, this.future, this.markNewOrChangedEntries}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('DaysLoadedPayload', 'data');
    }
    if (future == null) {
      throw new BuiltValueNullFieldError('DaysLoadedPayload', 'future');
    }
    if (markNewOrChangedEntries == null) {
      throw new BuiltValueNullFieldError('DaysLoadedPayload', 'markNewOrChangedEntries');
    }
  }

  @override
  DaysLoadedPayload rebuild(void Function(DaysLoadedPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DaysLoadedPayloadBuilder toBuilder() => new DaysLoadedPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DaysLoadedPayload &&
        data == other.data &&
        future == other.future &&
        markNewOrChangedEntries == other.markNewOrChangedEntries;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, data.hashCode), future.hashCode), markNewOrChangedEntries.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DaysLoadedPayload')
          ..add('data', data)
          ..add('future', future)
          ..add('markNewOrChangedEntries', markNewOrChangedEntries))
        .toString();
  }
}

class DaysLoadedPayloadBuilder implements Builder<DaysLoadedPayload, DaysLoadedPayloadBuilder> {
  _$DaysLoadedPayload _$v;

  Object _data;
  Object get data => _$this._data;
  set data(Object data) => _$this._data = data;

  bool _future;
  bool get future => _$this._future;
  set future(bool future) => _$this._future = future;

  bool _markNewOrChangedEntries;
  bool get markNewOrChangedEntries => _$this._markNewOrChangedEntries;
  set markNewOrChangedEntries(bool markNewOrChangedEntries) =>
      _$this._markNewOrChangedEntries = markNewOrChangedEntries;

  DaysLoadedPayloadBuilder();

  DaysLoadedPayloadBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data;
      _future = _$v.future;
      _markNewOrChangedEntries = _$v.markNewOrChangedEntries;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DaysLoadedPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DaysLoadedPayload;
  }

  @override
  void update(void Function(DaysLoadedPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DaysLoadedPayload build() {
    final _$result = _$v ??
        new _$DaysLoadedPayload._(
            data: data, future: future, markNewOrChangedEntries: markNewOrChangedEntries);
    replace(_$result);
    return _$result;
  }
}

class _$HomeworkAddedPayload extends HomeworkAddedPayload {
  @override
  final Object data;
  @override
  final DateTime date;

  factory _$HomeworkAddedPayload([void Function(HomeworkAddedPayloadBuilder) updates]) =>
      (new HomeworkAddedPayloadBuilder()..update(updates)).build();

  _$HomeworkAddedPayload._({this.data, this.date}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('HomeworkAddedPayload', 'data');
    }
    if (date == null) {
      throw new BuiltValueNullFieldError('HomeworkAddedPayload', 'date');
    }
  }

  @override
  HomeworkAddedPayload rebuild(void Function(HomeworkAddedPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeworkAddedPayloadBuilder toBuilder() => new HomeworkAddedPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomeworkAddedPayload && data == other.data && date == other.date;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, data.hashCode), date.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('HomeworkAddedPayload')
          ..add('data', data)
          ..add('date', date))
        .toString();
  }
}

class HomeworkAddedPayloadBuilder
    implements Builder<HomeworkAddedPayload, HomeworkAddedPayloadBuilder> {
  _$HomeworkAddedPayload _$v;

  Object _data;
  Object get data => _$this._data;
  set data(Object data) => _$this._data = data;

  DateTime _date;
  DateTime get date => _$this._date;
  set date(DateTime date) => _$this._date = date;

  HomeworkAddedPayloadBuilder();

  HomeworkAddedPayloadBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data;
      _date = _$v.date;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomeworkAddedPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$HomeworkAddedPayload;
  }

  @override
  void update(void Function(HomeworkAddedPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$HomeworkAddedPayload build() {
    final _$result = _$v ?? new _$HomeworkAddedPayload._(data: data, date: date);
    replace(_$result);
    return _$result;
  }
}

class _$AddReminderPayload extends AddReminderPayload {
  @override
  final String msg;
  @override
  final DateTime date;

  factory _$AddReminderPayload([void Function(AddReminderPayloadBuilder) updates]) =>
      (new AddReminderPayloadBuilder()..update(updates)).build();

  _$AddReminderPayload._({this.msg, this.date}) : super._() {
    if (msg == null) {
      throw new BuiltValueNullFieldError('AddReminderPayload', 'msg');
    }
    if (date == null) {
      throw new BuiltValueNullFieldError('AddReminderPayload', 'date');
    }
  }

  @override
  AddReminderPayload rebuild(void Function(AddReminderPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddReminderPayloadBuilder toBuilder() => new AddReminderPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AddReminderPayload && msg == other.msg && date == other.date;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, msg.hashCode), date.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AddReminderPayload')..add('msg', msg)..add('date', date))
        .toString();
  }
}

class AddReminderPayloadBuilder implements Builder<AddReminderPayload, AddReminderPayloadBuilder> {
  _$AddReminderPayload _$v;

  String _msg;
  String get msg => _$this._msg;
  set msg(String msg) => _$this._msg = msg;

  DateTime _date;
  DateTime get date => _$this._date;
  set date(DateTime date) => _$this._date = date;

  AddReminderPayloadBuilder();

  AddReminderPayloadBuilder get _$this {
    if (_$v != null) {
      _msg = _$v.msg;
      _date = _$v.date;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AddReminderPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AddReminderPayload;
  }

  @override
  void update(void Function(AddReminderPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AddReminderPayload build() {
    final _$result = _$v ?? new _$AddReminderPayload._(msg: msg, date: date);
    replace(_$result);
    return _$result;
  }
}

class _$ToggleDonePayload extends ToggleDonePayload {
  @override
  final Homework hw;
  @override
  final bool done;

  factory _$ToggleDonePayload([void Function(ToggleDonePayloadBuilder) updates]) =>
      (new ToggleDonePayloadBuilder()..update(updates)).build();

  _$ToggleDonePayload._({this.hw, this.done}) : super._() {
    if (hw == null) {
      throw new BuiltValueNullFieldError('ToggleDonePayload', 'hw');
    }
    if (done == null) {
      throw new BuiltValueNullFieldError('ToggleDonePayload', 'done');
    }
  }

  @override
  ToggleDonePayload rebuild(void Function(ToggleDonePayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ToggleDonePayloadBuilder toBuilder() => new ToggleDonePayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ToggleDonePayload && hw == other.hw && done == other.done;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, hw.hashCode), done.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ToggleDonePayload')..add('hw', hw)..add('done', done))
        .toString();
  }
}

class ToggleDonePayloadBuilder implements Builder<ToggleDonePayload, ToggleDonePayloadBuilder> {
  _$ToggleDonePayload _$v;

  HomeworkBuilder _hw;
  HomeworkBuilder get hw => _$this._hw ??= new HomeworkBuilder();
  set hw(HomeworkBuilder hw) => _$this._hw = hw;

  bool _done;
  bool get done => _$this._done;
  set done(bool done) => _$this._done = done;

  ToggleDonePayloadBuilder();

  ToggleDonePayloadBuilder get _$this {
    if (_$v != null) {
      _hw = _$v.hw?.toBuilder();
      _done = _$v.done;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ToggleDonePayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ToggleDonePayload;
  }

  @override
  void update(void Function(ToggleDonePayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ToggleDonePayload build() {
    _$ToggleDonePayload _$result;
    try {
      _$result = _$v ?? new _$ToggleDonePayload._(hw: hw.build(), done: done);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'hw';
        hw.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('ToggleDonePayload', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
