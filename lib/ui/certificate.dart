import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

import '../container/certificate_container.dart';
import 'no_internet.dart';

class Certificate extends StatelessWidget {
  final CertificateViewModel vm;

  const Certificate({Key key, this.vm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ResponsiveAppBar(title: Text("Zeugnis")),
      body: vm.html == null
          ? Center(
              child: vm.noInternet
                  ? const NoInternet()
                  : const CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: HtmlWidget(vm.html),
              ),
            ),
    );
  }
}
