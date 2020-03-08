import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:url_launcher/url_launcher.dart';

class QuillDeltaViewer extends StatelessWidget {
  /// The document delta to be rendered
  final Delta delta;

  QuillDeltaViewer({Key key, this.delta}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return render(removeLastNewline(isolateLines(delta)), context);
  }

  /// Splits all operations at newlines
  /// Newlines will be at the end of operations
  List<Operation> isolateLines(Delta delta) {
    List<Operation> operations = [];
    for (var i = 0; i < delta.length; i++) {
      final op = delta.elementAt(i);
      var string = op.data;
      final split = <String>[];
      while (true) {
        var index = string.indexOf("\n");
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
    operations.removeLast();
    final last = operations.removeLast();
    return operations
      ..add(
        Operation.insert(
          last.data.substring(0, last.data.length - 1),
          last.attributes,
        ),
      );
  }

  Widget render(List<Operation> ops, BuildContext context) {
    var reversed = ops.reversed.toList();
    final widgets = <InlineSpan>[];
    for (var i = 0; i < reversed.length; i++) {
      final op = reversed[i];
      if (op.data == "\n") {
        var use = <Operation>[];
        while (
            reversed.length > i + 1 && !reversed[i + 1].data.endsWith("\n")) {
          use.add(reversed[i + 1]);
          i++;
        }
        use = use.reversed.toList();
        widgets.add(renderBlock(use..add(op), context));
      } else {
        widgets.add(renderText(op, context));
      }
    }
    return Text.rich(
      TextSpan(
        children: widgets.reversed.toList(),
      ),
    );
  }

  InlineSpan renderBlock(List<Operation> ops, BuildContext context) {
    final blockOperation = ops.last;

    bool list = false;
    if (blockOperation.attributes != null) {
      list = blockOperation.attributes["list"] != null;
    }
    final text = ops.map((e) => renderText(e, context)).toList();

    if (list) {
      return TextSpan(
        children: [
          TextSpan(text: "• "),
          ...text,
        ],
      );
    }
    return TextSpan(children: text);
  }

  TextSpan renderText(Operation op, BuildContext context) {
    bool bold = false;
    bool italics = false;
    String link;
    bool strike = false;
    bool underline = false;
    if (op.attributes != null) {
      bold = op.attributes["bold"] == true;
      italics = op.attributes["italics"] == true;
      link = op.attributes["link"];
      strike = op.attributes["strike"] == true;
      underline = op.attributes["underline"] == true;
    }
    bool isLink = link != null;

    final text = op.data;

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
        color: isLink ? Theme.of(context).accentColor : null,
      ),
      recognizer: isLink
          ? (TapGestureRecognizer()
            ..onTap = () {
              launch(link);
            })
          : null,
    );
  }
}
