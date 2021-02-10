import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Keine Verbindung",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.red),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            ":(",
            style: TextStyle(fontSize: 50, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
