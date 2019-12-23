import 'package:built_redux/built_redux.dart';

part 'absences_actions.g.dart';

abstract class AbsencesActions extends ReduxActions {
  AbsencesActions._();
  factory AbsencesActions() => new _$AbsencesActions();

  ActionDispatcher<void> load;
  ActionDispatcher<dynamic> loaded;
}
