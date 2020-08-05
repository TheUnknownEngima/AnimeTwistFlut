import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InfoChip extends StatelessWidget {
  final String text;

  InfoChip({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).accentColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(7.5),
      label: AutoSizeText(
        text,
        textAlign: TextAlign.start,
        maxLines: 1,
        minFontSize: 15.0,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20.0,
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
    );
  }
}
