import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/KitsuModel.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchTrailerButton extends StatelessWidget {
  final KitsuModel kitsuModel;

  WatchTrailerButton({this.kitsuModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height * 0.16,
      child: OutlineButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        highlightedBorderColor: Colors.redAccent,
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 2.0,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: AutoSizeText(
            "Watch Trailer",
            maxLines: 1,
            minFontSize: 10.0,
            maxFontSize: 20.0,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        onPressed: () async {
          kitsuModel.trailerURL != null || kitsuModel.trailerURL.isEmpty
              ? launch("https://youtu.be/" + kitsuModel.trailerURL)
              : Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Trailer not found!"),
                  ),
                );
        },
      ),
    );
  }
}
