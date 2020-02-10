import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Certificate extends StatelessWidget {
  final String vm;

  const Certificate({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Zeugnis")),
      body: vm == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: HtmlWidget(vm),
              ),
            ),
    );
  }
}
