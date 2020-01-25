import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Kein Internet",
            style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.red),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            ":(",
            style: TextStyle(fontSize: 50, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
