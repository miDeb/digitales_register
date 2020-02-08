// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grades_actions.dart';

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$GradesActions extends GradesActions {
  factory _$GradesActions() => _$GradesActions._();
  _$GradesActions._() : super._();

  final setSemester = ActionDispatcher<Semester>('GradesActions-setSemester');
  final load = ActionDispatcher<Semester>('GradesActions-load');
  final loadDetails = ActionDispatcher<LoadSubjectDetailsPayload>('GradesActions-loadDetails');
  final loaded = ActionDispatcher<SubjectsLoadedPayload>('GradesActions-loaded');
  final detailsLoaded = ActionDispatcher<SubjectDetailLoadedPayload>('GradesActions-detailsLoaded');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    setSemester.setDispatcher(dispatcher);
    load.setDispatcher(dispatcher);
    loadDetails.setDispatcher(dispatcher);
    loaded.setDispatcher(dispatcher);
    detailsLoaded.setDispatcher(dispatcher);
  }
}

class GradesActionsNames {
  static final setSemester = ActionName<Semester>('GradesActions-setSemester');
  static final load = ActionName<Semester>('GradesActions-load');
  static final loadDetails = ActionName<LoadSubjectDetailsPayload>('GradesActions-loadDetails');
  static final loaded = ActionName<SubjectsLoadedPayload>('GradesActions-loaded');
  static final detailsLoaded =
      ActionName<SubjectDetailLoadedPayload>('GradesActions-detailsLoaded');
}

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoadSubjectDetailsPayload extends LoadSubjectDetailsPayload {
  @override
  final Semester semester;
  @override
  final Subject subject;

  factory _$LoadSubjectDetailsPayload([void Function(LoadSubjectDetailsPayloadBuilder) updates]) =>
      (new LoadSubjectDetailsPayloadBuilder()..update(updates)).build();

  _$LoadSubjectDetailsPayload._({this.semester, this.subject}) : super._() {
    if (semester == null) {
      throw new BuiltValueNullFieldError('LoadSubjectDetailsPayload', 'semester');
    }
    if (subject == null) {
      throw new BuiltValueNullFieldError('LoadSubjectDetailsPayload', 'subject');
    }
  }

  @override
  LoadSubjectDetailsPayload rebuild(void Function(LoadSubjectDetailsPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoadSubjectDetailsPayloadBuilder toBuilder() =>
      new LoadSubjectDetailsPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoadSubjectDetailsPayload &&
        semester == other.semester &&
        subject == other.subject;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, semester.hashCode), subject.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoadSubjectDetailsPayload')
          ..add('semester', semester)
          ..add('subject', subject))
        .toString();
  }
}

class LoadSubjectDetailsPayloadBuilder
    implements Builder<LoadSubjectDetailsPayload, LoadSubjectDetailsPayloadBuilder> {
  _$LoadSubjectDetailsPayload _$v;

  SemesterBuilder _semester;
  SemesterBuilder get semester => _$this._semester ??= new SemesterBuilder();
  set semester(SemesterBuilder semester) => _$this._semester = semester;

  SubjectBuilder _subject;
  SubjectBuilder get subject => _$this._subject ??= new SubjectBuilder();
  set subject(SubjectBuilder subject) => _$this._subject = subject;

  LoadSubjectDetailsPayloadBuilder();

  LoadSubjectDetailsPayloadBuilder get _$this {
    if (_$v != null) {
      _semester = _$v.semester?.toBuilder();
      _subject = _$v.subject?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoadSubjectDetailsPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LoadSubjectDetailsPayload;
  }

  @override
  void update(void Function(LoadSubjectDetailsPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LoadSubjectDetailsPayload build() {
    _$LoadSubjectDetailsPayload _$result;
    try {
      _$result = _$v ??
          new _$LoadSubjectDetailsPayload._(semester: semester.build(), subject: subject.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'semester';
        semester.build();
        _$failedField = 'subject';
        subject.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'LoadSubjectDetailsPayload', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SubjectsLoadedPayload extends SubjectsLoadedPayload {
  @override
  final Semester semester;
  @override
  final Object data;

  factory _$SubjectsLoadedPayload([void Function(SubjectsLoadedPayloadBuilder) updates]) =>
      (new SubjectsLoadedPayloadBuilder()..update(updates)).build();

  _$SubjectsLoadedPayload._({this.semester, this.data}) : super._() {
    if (semester == null) {
      throw new BuiltValueNullFieldError('SubjectsLoadedPayload', 'semester');
    }
    if (data == null) {
      throw new BuiltValueNullFieldError('SubjectsLoadedPayload', 'data');
    }
  }

  @override
  SubjectsLoadedPayload rebuild(void Function(SubjectsLoadedPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubjectsLoadedPayloadBuilder toBuilder() => new SubjectsLoadedPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubjectsLoadedPayload && semester == other.semester && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, semester.hashCode), data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SubjectsLoadedPayload')
          ..add('semester', semester)
          ..add('data', data))
        .toString();
  }
}

class SubjectsLoadedPayloadBuilder
    implements Builder<SubjectsLoadedPayload, SubjectsLoadedPayloadBuilder> {
  _$SubjectsLoadedPayload _$v;

  SemesterBuilder _semester;
  SemesterBuilder get semester => _$this._semester ??= new SemesterBuilder();
  set semester(SemesterBuilder semester) => _$this._semester = semester;

  Object _data;
  Object get data => _$this._data;
  set data(Object data) => _$this._data = data;

  SubjectsLoadedPayloadBuilder();

  SubjectsLoadedPayloadBuilder get _$this {
    if (_$v != null) {
      _semester = _$v.semester?.toBuilder();
      _data = _$v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubjectsLoadedPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SubjectsLoadedPayload;
  }

  @override
  void update(void Function(SubjectsLoadedPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SubjectsLoadedPayload build() {
    _$SubjectsLoadedPayload _$result;
    try {
      _$result = _$v ?? new _$SubjectsLoadedPayload._(semester: semester.build(), data: data);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'semester';
        semester.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('SubjectsLoadedPayload', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SubjectDetailLoadedPayload extends SubjectDetailLoadedPayload {
  @override
  final Semester semester;
  @override
  final Subject subject;
  @override
  final Object data;

  factory _$SubjectDetailLoadedPayload(
          [void Function(SubjectDetailLoadedPayloadBuilder) updates]) =>
      (new SubjectDetailLoadedPayloadBuilder()..update(updates)).build();

  _$SubjectDetailLoadedPayload._({this.semester, this.subject, this.data}) : super._() {
    if (semester == null) {
      throw new BuiltValueNullFieldError('SubjectDetailLoadedPayload', 'semester');
    }
    if (subject == null) {
      throw new BuiltValueNullFieldError('SubjectDetailLoadedPayload', 'subject');
    }
    if (data == null) {
      throw new BuiltValueNullFieldError('SubjectDetailLoadedPayload', 'data');
    }
  }

  @override
  SubjectDetailLoadedPayload rebuild(void Function(SubjectDetailLoadedPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubjectDetailLoadedPayloadBuilder toBuilder() =>
      new SubjectDetailLoadedPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubjectDetailLoadedPayload &&
        semester == other.semester &&
        subject == other.subject &&
        data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, semester.hashCode), subject.hashCode), data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SubjectDetailLoadedPayload')
          ..add('semester', semester)
          ..add('subject', subject)
          ..add('data', data))
        .toString();
  }
}

class SubjectDetailLoadedPayloadBuilder
    implements Builder<SubjectDetailLoadedPayload, SubjectDetailLoadedPayloadBuilder> {
  _$SubjectDetailLoadedPayload _$v;

  SemesterBuilder _semester;
  SemesterBuilder get semester => _$this._semester ??= new SemesterBuilder();
  set semester(SemesterBuilder semester) => _$this._semester = semester;

  SubjectBuilder _subject;
  SubjectBuilder get subject => _$this._subject ??= new SubjectBuilder();
  set subject(SubjectBuilder subject) => _$this._subject = subject;

  Object _data;
  Object get data => _$this._data;
  set data(Object data) => _$this._data = data;

  SubjectDetailLoadedPayloadBuilder();

  SubjectDetailLoadedPayloadBuilder get _$this {
    if (_$v != null) {
      _semester = _$v.semester?.toBuilder();
      _subject = _$v.subject?.toBuilder();
      _data = _$v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubjectDetailLoadedPayload other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SubjectDetailLoadedPayload;
  }

  @override
  void update(void Function(SubjectDetailLoadedPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SubjectDetailLoadedPayload build() {
    _$SubjectDetailLoadedPayload _$result;
    try {
      _$result = _$v ??
          new _$SubjectDetailLoadedPayload._(
              semester: semester.build(), subject: subject.build(), data: data);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'semester';
        semester.build();
        _$failedField = 'subject';
        subject.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SubjectDetailLoadedPayload', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
