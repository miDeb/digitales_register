import 'package:built_redux/built_redux.dart';

part 'absences_actions.g.dart';

abstract class AbsencesActions extends ReduxActions {
  factory AbsencesActions() => _$AbsencesActions();
  AbsencesActions._();

  ActionDispatcher<void> load;
  ActionDispatcher<dynamic> loaded;
}
