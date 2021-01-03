import 'package:flutter/material.dart';
import 'package:responsive_scaffold/scaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ResponsiveScaffold<int>(
        homeId: 0,
        home: Scaffold(
          body: FlutterLogo(),
          appBar: ResponsiveAppBar(
            title: Text("Home $count"),
            isHomePage: true,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                count++;
              });
            },
          ),
        ),
        drawerBuilder: (onSelected, onGoHome, currentSelected, tabletMode) {
          return Drawer(
            child: Column(
              children: [
                if (tabletMode)
                  ListTile(
                    title: Text("Homeaaaaaaaaaaaaaaaaaaaaaaaaa"),
                    onTap: onGoHome,
                    trailing: Icon(Icons.home),
                  ),
                ListTile(
                  title: Text("foo"),
                  trailing: Icon(Icons.home),
                  onTap: () => onSelected(
                    Scaffold(
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
    );
  }
}
