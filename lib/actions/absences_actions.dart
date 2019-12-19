import 'package:built_value/built_value.dart';

part 'absences_actions.g.dart';

abstract class LoadAbsencesAction
    implements Built<LoadAbsencesAction, LoadAbsencesActionBuilder> {
  LoadAbsencesAction._();
  factory LoadAbsencesAction(
          [void Function(LoadAbsencesActionBuilder) updates]) =
      _$LoadAbsencesAction;
}

abstract class AbsencesLoadedAction
    implements Built<AbsencesLoadedAction, AbsencesLoadedActionBuilder> {
  AbsencesLoadedAction._();
  factory AbsencesLoadedAction(
          [void Function(AbsencesLoadedActionBuilder) updates]) =
      _$AbsencesLoadedAction;

  Object get absences;
}
