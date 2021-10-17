import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventDetailRow extends StatelessWidget {
  final String date;
  final String country;
  final String venue;
  final String flagUrl;

  const EventDetailRow({
    @required this.date,
    @required this.country,
    @required this.venue,
    @required this.flagUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: Text(date, style: Theme.of(context).textTheme.headline2)),
          Text(',', style: Theme.of(context).textTheme.headline2),
          SizedBox(
            width: 4,
          ),
          Flexible(
              fit: FlexFit.loose,
              child:
                  Text(country, style: Theme.of(context).textTheme.headline2)),
          Text(',', style: Theme.of(context).textTheme.headline2),
          SizedBox(
            width: 4,
          ),
          Text(venue, style: Theme.of(context).textTheme.headline2),
          SizedBox(
            width: 4,
          ),
          CachedNetworkImage(imageUrl: flagUrl),
        ],
      ),
    ));
  }
}
