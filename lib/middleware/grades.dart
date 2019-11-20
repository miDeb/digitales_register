import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:requests/requests.dart';
import 'package:synchronized/synchronized.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../wrapper.dart';

final _colors = List.of(Colors.primaries)
  ..removeWhere((c) => _similarColors.contains(c));

final _similarColors = [
  Colors.lime,
  Colors.lightBlue,
  Colors.cyan,
  Colors.amber
];

const _defaultThick = 2;

List<Middleware<AppState>> gradesMiddlewares(Wrapper wrapper) => [
      TypedMiddleware<AppState, LoadSubjectsAction>(
        (store, action, next) => _load(next, action, wrapper, store),
      ),
      TypedMiddleware<AppState, LoadSubjectDetailsAction>(
        (store, action, next) => _loadDetail(store, next, action, wrapper),
      ),
    ];

const String _subjects = "/api/student/all_subjects";
const String _subjectsDetail = "/api/student/subject_detail";

final _gradesLock = new Lock();

void _load(NextDispatcher next, LoadSubjectsAction action, Wrapper wrapper,
        Store<AppState> store) =>
    _gradesLock.synchronized(() async {
      next(action);

      if (await wrapper.noInternet) {
        store.dispatch(NoInternetAction(true));
        return;
      }
      final which = store.state.gradesState.semester;

      List<AllSemesterSubject> loadedSubjects =
          List.of(store.state.gradesState.subjects);
      List<int> neededSemester = which.n != null ? [which.n] : [1, 2];
      int lastRequested;

      if (neededSemester
          .remove(lastRequested = store.state.gradesState.serverSemester)) {
        var data = await wrapper.post(_subjects, {
          "studentId": store.state.config.userId,
        });
        for (var s in data["subjects"]) {
          final subject = SingleSemesterSubject.parse(s);
          final same = loadedSubjects.firstWhere((i) => i.id == subject.id,
              orElse: () => null);
          if (same != null) {
            loadedSubjects[loadedSubjects.indexOf(same)] =
                same.rebuild((b) => b..subjects[lastRequested] = subject);
          } else
            loadedSubjects.add(
              AllSemesterSubject(
                (b) => b
                  ..subjects = MapBuilder(
                    {lastRequested: subject},
                  ),
              ),
            );
        }
      }
      while (neededSemester.isNotEmpty) {
        await Requests.get(
            "${wrapper.baseAddress}/?semesterWechsel=${lastRequested = neededSemester.removeLast()}");
        var data = await wrapper.post(_subjects, {
          "studentId": store.state.config.userId,
        });
        for (var s in data["subjects"]) {
          final subject = SingleSemesterSubject.parse(s);
          final same = loadedSubjects.firstWhere((i) => i.id == subject.id,
              orElse: () => null);
          if (same != null) {
            loadedSubjects[loadedSubjects.indexOf(same)] =
                same.rebuild((b) => b..subjects[lastRequested] = subject);
          } else
            loadedSubjects.add(
              AllSemesterSubject(
                (b) => b
                  ..subjects = MapBuilder(
                    {lastRequested: subject},
                  ),
              ),
            );
        }
      }
      if (loadedSubjects.isNotEmpty) {
        final graphConfigsBuilder =
            store.state.settingsState.graphConfigs.toBuilder();

        for (final entry in store.state.settingsState.graphConfigs.entries) {
          if (!loadedSubjects.any((s) => s.id == entry.key)) {
            graphConfigsBuilder.remove(entry);
          }
        }
        for (var subject in loadedSubjects) {
          if (!graphConfigsBuilder.build().containsKey(subject.id)) {
            graphConfigsBuilder.update(
              (b) => b
                ..[subject.id] = SubjectGraphConfig((b) => b
                  ..thick = _defaultThick
                  ..color = _colors
                      .firstWhere(
                        (color) => !graphConfigsBuilder
                            .build()
                            .values
                            .any((config) => config.color == color.value),
                        orElse: () => _similarColors.firstWhere(
                          (color) => !graphConfigsBuilder
                              .build()
                              .values
                              .any((config) => config.color == color.value),
                          orElse: () =>
                              (List.of(Colors.primaries)..shuffle()).first,
                        ),
                      )
                      .value),
            );
          }
        }
        store.dispatch(
            SetGraphConfigsAction(graphConfigsBuilder.build().toMap()));
        store.dispatch(
            SubjectsLoadedAction(ListBuilder(loadedSubjects), lastRequested));
      }
    });

void _loadDetail(Store<AppState> store, NextDispatcher next,
        LoadSubjectDetailsAction action, Wrapper wrapper) =>
    _gradesLock.synchronized(() async {
      final which = store.state.gradesState.semester;

      next(action);
      if (await wrapper.noInternet) {
        store.dispatch(NoInternetAction(true));
        return;
      }
      List<int> neededSemester = which.n != null ? [which.n] : [1, 2];
      int lastRequested;

      if (neededSemester
          .remove(lastRequested = store.state.gradesState.serverSemester)) {
        var data = await wrapper.post(_subjectsDetail, {
          "studentId": store.state.config.userId,
          "subjectId": action.subject.id,
        });
        action.subject.subjects[lastRequested]
            .replaceWithSpecificData(data, lastRequested);
      }
      while (neededSemester.isNotEmpty) {
        await Requests.get(
            "${wrapper.baseAddress}/?semesterWechsel=${lastRequested = neededSemester.removeLast()}");
        var data = await wrapper.post(_subjectsDetail, {
          "studentId": store.state.config.userId,
          "subjectId": action.subject.id
        });
        action.subject.subjects[lastRequested]
            .replaceWithSpecificData(data, lastRequested);
      }

      store.dispatch(SubjectsLoadedAction(
          store.state.gradesState.subjects.toBuilder(), lastRequested));
    });
