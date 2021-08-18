import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:url_launcher/url_launcher.dart';

class QuillDeltaViewer extends StatelessWidget {
  /// The document delta to be rendered
  final Delta delta;

  const QuillDeltaViewer({Key? key, required this.delta}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return render(removeLastNewline(isolateLines(delta)), context);
  }

  /// Splits all operations at newlines
  /// Newlines will be at the end of operations
  List<Operation> isolateLines(Delta delta) {
    final List<Operation> operations = [];
    for (var i = 0; i < delta.length; i++) {
      final op = delta.elementAt(i);
      var string = op.stringData;
      final split = <String>[];
      for (;;) {
        final index = string.indexOf("\n");
        if (index == -1) {
          split.add(string);
          break;
        }
        split.add(string.substring(0, index + 1));
        string = string.substring(index + 1);
      }
      operations.addAll(
        split.map(
          (s) => Operation.insert(
            s,
            op.attributes,
          ),
        ),
      );
    }
    return operations;
  }

  List<Operation> removeLastNewline(List<Operation> operations) {
    while (operations.last.stringData.isEmpty) {
      operations.removeLast();
    }
    return operations
      ..add(
        removeTrailingNewline(
          operations.removeLast(),
        ),
      );
  }

  Operation removeTrailingNewline(Operation operation) {
    if (operation.stringData.lastIndexOf("\n") ==
        operation.stringData.length - 1) {
      return Operation.insert(
        operation.stringData.substring(
          0,
          operation.stringData.length - 1,
        ),
      );
    } else {
      return operation;
    }
  }

  Widget render(List<Operation> ops, BuildContext context) {
    final reversed = ops.reversed.toList();
    final widgets = <Widget>[];
    var spans = <InlineSpan>[];

    /// Whether we previously rendered a block.
    /// blocks always go to a new line automatically, so _one_
    /// newline in front should be removed
    var renderedBlock = false;

    for (var i = 0; i < reversed.length; i++) {
      var op = reversed[i];
      if (op.data == "\n") {
        if (spans.isNotEmpty) {
          widgets.add(
            Text.rich(
              TextSpan(
                children: spans.reversed.toList(),
              ),
            ),
          );
          spans = [];
        }
        var use = <Operation>[];
        while (reversed.length > i + 1 &&
            !reversed[i + 1].stringData.endsWith("\n")) {
          use.add(reversed[i + 1]);
          i++;
        }
        use = use.reversed.toList();
        widgets.add(renderBlock(use..add(op), context));
        renderedBlock = true;
      } else {
        if (renderedBlock) {
          op = removeTrailingNewline(op);
        }
        spans.add(renderText(op, context));
        renderedBlock = false;
      }
    }
    if (spans.isNotEmpty) {
      widgets.add(
        Text.rich(
          TextSpan(
            children: spans.reversed.toList(),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets.reversed.toList(),
    );
  }

  Widget renderBlock(List<Operation> ops, BuildContext context) {
    final blockOperation = ops.last;

    bool list = false;
    if (blockOperation.attributes != null) {
      list = blockOperation.attributes!["list"] != null;
    }
    final text = Text.rich(
      TextSpan(
        children: removeLastNewline(ops)
            .map(
              (e) => renderText(e, context),
            )
            .toList(),
      ),
    );

    if (list) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•"),
          const SizedBox(width: 2.5),
          Expanded(child: text),
        ],
      );
    }
    return text;
  }

  TextSpan renderText(Operation op, BuildContext context) {
    bool bold = false;
    bool italics = false;
    String? link;
    bool strike = false;
    bool underline = false;
    if (op.attributes != null) {
      bold = op.attributes!["bold"] == true;
      italics = op.attributes!["italics"] == true;
      link = op.attributes!["link"] as String?;
      strike = op.attributes!["strike"] == true;
      underline = op.attributes!["underline"] == true;
    }
    final isLink = link != null;

    final text = op.stringData;

    return TextSpan(
      text: text,
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : null,
        fontStyle: italics ? FontStyle.italic : null,
        decoration: TextDecoration.combine(
          [
            if (strike) TextDecoration.lineThrough,
            if (underline) TextDecoration.underline,
          ],
        ),
        color: isLink ? Theme.of(context).colorScheme.secondary : null,
      ),
      recognizer: isLink
          ? (TapGestureRecognizer()
            ..onTap = () {
              launch(link!);
            })
          : null,
    );
  }
}

extension DataHelper on Operation {
  String get stringData => data as String;
}
