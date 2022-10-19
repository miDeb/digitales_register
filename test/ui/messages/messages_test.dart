// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/messages_container.dart';
import 'package:dr/data.dart';
import 'package:dr/utc_date_time.dart';
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
                  ..attachments = ListBuilder(
                    <MessageAttachmentFile>[
                      MessageAttachmentFile(
                        (b) => b
                          ..downloading = false
                          ..fileAvailable = false
                          ..file = "attachment.png"
                          ..originalName = "Bild.png"
                          ..messageId = 123
                          ..id = 12,
                      )
                    ],
                  )
                  ..fromName = "Sender"
                  ..recipientString = "Empfänger"
                  ..id = 25
                  ..subject = "Betreff"
                  ..timeSent = UtcDateTime.parse("2020-03-04 20:57:38")
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
    expect(find.text("Öffnen"), findsOneWidget);
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
                  ..attachments = ListBuilder(
                    <MessageAttachmentFile>[
                      MessageAttachmentFile(
                        (b) => b
                          ..downloading = true
                          ..fileAvailable = false
                          ..file = "attachment.png"
                          ..originalName = "Bild.png"
                          ..messageId = 123
                          ..id = 12,
                      )
                    ],
                  )
                  ..fromName = "Sender"
                  ..recipientString = "Empfänger"
                  ..id = 25
                  ..subject = "Betreff"
                  ..timeSent = UtcDateTime.parse("2020-03-04 20:57:38")
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
                  ..attachments = ListBuilder(
                    <MessageAttachmentFile>[
                      MessageAttachmentFile(
                        (b) => b
                          ..downloading = false
                          ..fileAvailable = true
                          ..file = "attachment.png"
                          ..originalName = "Bild.png"
                          ..messageId = 123
                          ..id = 12,
                      )
                    ],
                  )
                  ..fromName = "Sender"
                  ..recipientString = "Empfänger"
                  ..id = 25
                  ..subject = "Betreff"
                  ..timeSent = UtcDateTime.parse("2020-03-04 20:57:38")
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
