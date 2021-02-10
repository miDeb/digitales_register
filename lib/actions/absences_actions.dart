import 'package:built_redux/built_redux.dart';

part 'absences_actions.g.dart';

abstract class AbsencesActions extends ReduxActions {
  factory AbsencesActions() => _$AbsencesActions();
  AbsencesActions._();

  abstract final VoidActionDispatcher load;
  abstract final ActionDispatcher<dynamic> loaded;
}
