import 'package:built_redux/built_redux.dart';

part 'absences_actions.g.dart';

abstract class AbsencesActions extends ReduxActions {
  factory AbsencesActions() => _$AbsencesActions();
  AbsencesActions._();

  VoidActionDispatcher load;
  ActionDispatcher<dynamic> loaded;
}
