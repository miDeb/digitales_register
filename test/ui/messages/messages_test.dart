import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/messages_container.dart';
import 'package:dr/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('with attachment', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.messagesState.messages = ListBuilder(
            <Message>[
              Message(
                (b) => b
                  ..downloading = false
                  ..fileAvailable = false
                  ..fileName = "attachment.png"
                  ..fileOriginalName = "Bild.png"
                  ..fromName = "Sender"
                  ..recipientString = "Empfänger"
                  ..id = 25
                  ..subject = "Betreff"
                  ..timeSent = DateTime.parse("2020-03-04 20:57:38")
                  ..text =
                      '{"ops":[{"insert":"Sehr geehrte Eltern,\\nliebe Schülerinnen und Schüler,\\nwie Sie aus den Medien erfahren haben, hat die italienische Regierung heute Abend definitiv beschlossen, alle Schulen und Bildungseinrichtungen in Italien bis 15. März zu schließen, um die Ausbreitung des Corona-Virus einzudämmen. \\nAus diesem Grund muss auch "},{"attributes":{"bold":true},"insert":"der Schul- und Internatsbetrieb im Vinzentinum"},{"insert":" "},{"attributes":{"bold":true},"insert":"während dieser Tage eingestellt"},{"insert":" werden. \\nDie Bildungsdirektion bereitet ein Rundschreiben vor mit genaueren Hinweisen darauf, was dies konkret für die Schülerinnen und Schüler bedeutet. Wir werden Sie dann umgehend informieren. \\nWer noch Instrumente und Schulmaterialien abholen möchte, kann sich morgen zwischen 9.00 und 12.30 Uhr an den Heimleiter Paul Felix Rigo wenden.\\nDas "},{"attributes":{"bold":true},"insert":"Schulsekretariat bleibt geöffnet"},{"insert":". Der Schülertransport ist ausgesetzt.\\nChristoph Stragenegg\\nDirektor\\n"}]}',
              )
            ],
          ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: MessagesPageContainer(),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.text("Betreff"), findsOneWidget);
    await tester.tap(find.text("Betreff"));
    await tester.pumpAndSettle();
    expect(find.textContaining("Sehr geehrte Eltern"), findsOneWidget);
    expect(find.text("Anhang:"), findsOneWidget);
    expect(find.text("Herunterladen"), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("with_attachment.png"),
    );
  });
  testGoldens('downloading attachment', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.messagesState.messages = ListBuilder(
            <Message>[
              Message(
                (b) => b
                  ..downloading = true
                  ..fileAvailable = false
                  ..fileName = "attachment.png"
                  ..fileOriginalName = "Bild.png"
                  ..fromName = "Sender"
                  ..recipientString = "Empfänger"
                  ..id = 25
                  ..subject = "Betreff"
                  ..timeSent = DateTime.parse("2020-03-04 20:57:38")
                  ..text =
                      '{"ops":[{"insert":"Sehr geehrte Eltern,\\nliebe Schülerinnen und Schüler,\\nwie Sie aus den Medien erfahren haben, hat die italienische Regierung heute Abend definitiv beschlossen, alle Schulen und Bildungseinrichtungen in Italien bis 15. März zu schließen, um die Ausbreitung des Corona-Virus einzudämmen. \\nAus diesem Grund muss auch "},{"attributes":{"bold":true},"insert":"der Schul- und Internatsbetrieb im Vinzentinum"},{"insert":" "},{"attributes":{"bold":true},"insert":"während dieser Tage eingestellt"},{"insert":" werden. \\nDie Bildungsdirektion bereitet ein Rundschreiben vor mit genaueren Hinweisen darauf, was dies konkret für die Schülerinnen und Schüler bedeutet. Wir werden Sie dann umgehend informieren. \\nWer noch Instrumente und Schulmaterialien abholen möchte, kann sich morgen zwischen 9.00 und 12.30 Uhr an den Heimleiter Paul Felix Rigo wenden.\\nDas "},{"attributes":{"bold":true},"insert":"Schulsekretariat bleibt geöffnet"},{"insert":". Der Schülertransport ist ausgesetzt.\\nChristoph Stragenegg\\nDirektor\\n"}]}',
              )
            ],
          ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: MessagesPageContainer(),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.text("Betreff"), findsOneWidget);
    await tester.tap(find.text("Betreff"));
    // let the ExpansionTile expand
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("attachment_downloading.png"),
    );
  });
  testGoldens('downloaded attachment', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.messagesState.messages = ListBuilder(
            <Message>[
              Message(
                (b) => b
                  ..downloading = false
                  ..fileAvailable = true
                  ..fileName = "attachment.png"
                  ..fileOriginalName = "Bild.png"
                  ..fromName = "Sender"
                  ..recipientString = "Empfänger"
                  ..id = 25
                  ..subject = "Betreff"
                  ..timeSent = DateTime.parse("2020-03-04 20:57:38")
                  ..text =
                      '{"ops":[{"insert":"Sehr geehrte Eltern,\\nliebe Schülerinnen und Schüler,\\nwie Sie aus den Medien erfahren haben, hat die italienische Regierung heute Abend definitiv beschlossen, alle Schulen und Bildungseinrichtungen in Italien bis 15. März zu schließen, um die Ausbreitung des Corona-Virus einzudämmen. \\nAus diesem Grund muss auch "},{"attributes":{"bold":true},"insert":"der Schul- und Internatsbetrieb im Vinzentinum"},{"insert":" "},{"attributes":{"bold":true},"insert":"während dieser Tage eingestellt"},{"insert":" werden. \\nDie Bildungsdirektion bereitet ein Rundschreiben vor mit genaueren Hinweisen darauf, was dies konkret für die Schülerinnen und Schüler bedeutet. Wir werden Sie dann umgehend informieren. \\nWer noch Instrumente und Schulmaterialien abholen möchte, kann sich morgen zwischen 9.00 und 12.30 Uhr an den Heimleiter Paul Felix Rigo wenden.\\nDas "},{"attributes":{"bold":true},"insert":"Schulsekretariat bleibt geöffnet"},{"insert":". Der Schülertransport ist ausgesetzt.\\nChristoph Stragenegg\\nDirektor\\n"}]}',
              )
            ],
          ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: MessagesPageContainer(),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.text("Betreff"), findsOneWidget);
    await tester.tap(find.text("Betreff"));
    // let the ExpansionTile expand
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("attachment_downloaded.png"),
    );
  });
}
