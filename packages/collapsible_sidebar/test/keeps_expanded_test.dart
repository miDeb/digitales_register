import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'rebuilding does not change the size when alwaysExpanded is set to true',
      (tester) async {
    final sidebar = MaterialApp(
      home: Row(
        children: [
          StatefulBuilder(
            builder: (context, setState) => CollapsibleSidebar(
              alwaysExpanded: true,
              title: TextButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("Press me"),
              ),
              items: const [],
              body: const SizedBox(),
              titleTooltip: "title",
              toggleTooltipCollapsed: "Collapsed",
              toggleTooltipExpanded: "Expanded",
              avatar: const Icon(Icons.person),
            ),
          ),
        ],
      ),
    );

    await tester.pumpWidget(sidebar);
    await tester.pumpAndSettle();
    var box = find.byType(CollapsibleSidebar).evaluate().single.renderObject
        as RenderBox;
    final initialWidth = box.size.width;
    expect(initialWidth, 278);
    // trigger a rebuild
    await tester.tap(find.text("Press me"));
    await tester.pumpAndSettle();
    box = find.byType(CollapsibleSidebar).evaluate().single.renderObject
        as RenderBox;
    // rebuilding should not change the size
    expect(box.size.width, initialWidth);
  });
}
