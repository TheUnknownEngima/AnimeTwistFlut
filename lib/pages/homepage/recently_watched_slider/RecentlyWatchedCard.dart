// Flutter imports:
import 'dart:ui';

import 'package:AnimeTwistFlut/constants.dart';
import 'package:AnimeTwistFlut/models/RecentlyWatchedModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/all.dart';

// Project imports:
import '../../../animations/Transitions.dart';
import '../../anime_info_page/AnimeInfoPage.dart';
import 'RecentlyWatchedSlider.dart';

class RecentlyWatchedCard extends StatefulWidget {
  final RecentlyWatchedModel lastWatchedModel;
  final int pageNum;
  final PageController pageController;

  const RecentlyWatchedCard({
    @required this.lastWatchedModel,
    @required this.pageNum,
    @required this.pageController,
  });

  @override
  State<StatefulWidget> createState() {
    return _RecentlyWatchedCardState();
  }
}

class _RecentlyWatchedCardState extends State<RecentlyWatchedCard> {
  @override
  void initState() {
    super.initState();
  }

  bool shouldOffset() {
    // Since we can't access pageController.page before min/maxScrollExtent /
    // pixels is null, return false if thats the case and prevent nasty
    // exceptions.
    if (widget.pageController.position.minScrollExtent == null) return false;
    return widget.pageController.page.floor() == widget.pageNum;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Consumer(
              builder: (context, watch, child) {
                var prov = watch(offsetProvider);
                return Image.network(
                  widget.lastWatchedModel.kitsuModel?.coverImage ??
                      widget.lastWatchedModel.kitsuModel?.posterImage ??
                      DEFAULT_IMAGE_URL,
                  fit: BoxFit.cover,
                  alignment: shouldOffset()
                      ? Alignment(-prov.state.abs() * 1.25, 0)
                      : Alignment(0, 0),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0xff070E30).withOpacity(0.7),
            ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: AutoSizeText(
                    widget.lastWatchedModel.twistModel.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 17.0,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Season " +
                      widget.lastWatchedModel.twistModel.season.toString() +
                      " Episode " +
                      widget.lastWatchedModel.episodeModel.number.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => AnimeInfoPage(
                      twistModel: widget.lastWatchedModel.twistModel,
                      kitsuModel: widget.lastWatchedModel.kitsuModel,
                      isFromRecentlyWatched: true,
                      lastWatchedEpisodeNum:
                          widget.lastWatchedModel.episodeModel.number,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
