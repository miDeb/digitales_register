import 'package:flutter/material.dart';

class NewsSticker extends StatelessWidget {
  final String text;

  const NewsSticker({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: Theme.of(context).textTheme.body1.copyWith(
              color: Colors.white,
            ),
      ),
      decoration: ShapeDecoration(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
