import 'package:flutter/material.dart';

class EventDetailSilverAppBar extends StatelessWidget {

  final String title;

  const EventDetailSilverAppBar({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 150,
      floating: false,
      pinned: true,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 8, bottom: 8),
            collapseMode: CollapseMode.parallax,
            title: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}