import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/notification_icon_container.dart';
import 'package:dr/container/notifications_page_container.dart';
import 'package:dr/data.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/ui/notifications_page.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('Notification icon shows badge', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.notificationState.notifications = ListBuilder(
            [
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title"
                  ..timeSent = DateTime.now(),
              ),
            ],
          ),
        ),
        AppActions(),
      ),
      child: MaterialApp(home: Material(child: NotificationIconContainer())),
    );
    await tester.pumpWidget(widget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
    await expectLater(find.byType(NotificationIconContainer),
        matchesGoldenFile("icon_before_animation.png"));
    await tester.pump(const Duration(milliseconds: 25));
    await expectLater(find.byType(NotificationIconContainer),
        matchesGoldenFile("icon_animating.png"));
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(find.byType(NotificationIconContainer),
        matchesGoldenFile("icon_animated.png"));
  });
  testGoldens('Notification page', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.notificationState.notifications = ListBuilder(
            [
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title1"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title2"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title3"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
            ],
          ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: NotificationPageContainer(),
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(NotificationWidget), findsNWidgets(3));
    await expectLater(
        find.byType(NotificationPage), matchesGoldenFile("page.png"));
  });

  testGoldens('Notification page delete single animation',
      (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState(
          (b) => b.notificationState.notifications = ListBuilder(
            [
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title1"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title2"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title3"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
            ],
          ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: NotificationPageContainer(),
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(NotificationWidget), findsNWidgets(3));
    await tester.tap(find.byIcon(Icons.done).first);
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("notification_not_yet_deleted.png"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("notification_deleting.png"));
    await tester.pump(const Duration(milliseconds: 151));
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("notification_deleted.png"));
    expect(find.byType(NotificationWidget), findsNWidgets(2));
  });
  testGoldens('Notification page delete all animation',
      (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState(
          (b) => b.notificationState.notifications = ListBuilder(
            [
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title1"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title2"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title3"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
            ],
          ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: NotificationPageContainer(),
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(NotificationWidget), findsNWidgets(3));
    await tester.tap(find.byIcon(Icons.done_all));
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("notifications_not_yet_deleted.png"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("notifications_deleting.png"));
    await tester.pump(const Duration(milliseconds: 151));
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("notifications_deleted.png"));
    expect(find.byType(NotificationWidget), findsNothing);
  });
  testGoldens('Notification page delete last animation',
      (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState(
          (b) => b.notificationState.notifications = ListBuilder(
            [
              Notification(
                (b) => b
                  ..id = 0
                  ..title = "title1"
                  ..timeSent = DateTime(2020, 1, 2),
              ),
            ],
          ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: NotificationPageContainer(),
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(NotificationWidget), findsOneWidget);
    await tester.tap(find.byIcon(Icons.done));
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("single_notification_not_yet_deleted.png"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("single_notification_deleting.png"));
    await tester.pump(const Duration(milliseconds: 151));
    await expectLater(find.byType(NotificationPage),
        matchesGoldenFile("single_notification_deleted.png"));
    expect(find.byType(NotificationWidget), findsNothing);
  });
}
