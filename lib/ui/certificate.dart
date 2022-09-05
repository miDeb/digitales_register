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

import 'package:dr/container/certificate_container.dart';
import 'package:dr/ui/last_fetched_overlay.dart';
import 'package:dr/ui/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

class Certificate extends StatelessWidget {
  final CertificateViewModel vm;

  const Certificate({Key? key, required this.vm}) : super(key: key);
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
          : LastFetchedOverlay(
              lastFetched: vm.lastFetched,
              noInternet: vm.noInternet,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: HtmlWidget(vm.html!),
                ),
              ),
            ),
    );
  }
}
