import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> nestedNavKey = GlobalKey();
  final GlobalKey<NavigatorState> rootNavKey = GlobalKey();
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavKey,
      title: 'Flutter Demo',
      home: WillPopScope(
        onWillPop: () {
          // We have to manually handle the back press.
          // If the nested navigator can handle it, let it handle it.
          // If not, check if the root navigator could.
          // Otherwise don't handle it.
          if (nestedNavKey.currentState!.canPop()) {
            nestedNavKey.currentState!.pop();
            return Future.value(false);
          } else if (rootNavKey.currentState!.canPop()) {
            rootNavKey.currentState!.pop();
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: ResponsiveScaffold<int>(
          navKey: nestedNavKey,
          homeId: 0,
          homeAppBar: AppBar(
            title: Text("Home $count"),
          ),
          homeFloatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                count++;
              });
            },
            child: const Icon(Icons.add),
          ),
          homeBody: const Scaffold(
            body: FlutterLogo(),
          ),
          drawerBuilder: (onSelected, onGoHome, currentSelected, tabletMode) {
            return Drawer(
              child: Column(
                children: [
                  if (tabletMode)
                    ListTile(
                      title: const Text("Homeaaaaaaaaaaaaaaaaaaaaaaaaa"),
                      onTap: onGoHome,
                      trailing: const Icon(Icons.home),
                    ),
                  ListTile(
                    title: const Text("foo"),
                    trailing: const Icon(Icons.home),
                    onTap: () => onSelected(
                      const Scaffold(
                        appBar: ResponsiveAppBar(
                          title: Text("foo"),
                        ),
                        body: Placeholder(),
                      ),
                      1,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
