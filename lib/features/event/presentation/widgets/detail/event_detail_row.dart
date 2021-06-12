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
            children: [
              Text(date, style: Theme.of(context).textTheme.headline2),
              Text(',', style: Theme.of(context).textTheme.headline2),
              SizedBox(
                width: 4,
              ),
              Text(country, style: Theme.of(context).textTheme.headline2),
              Text(',', style: Theme.of(context).textTheme.headline2),
              SizedBox(
                width: 4,
              ),
              Text(venue, style: Theme.of(context).textTheme.headline2),
              SizedBox(
                width: 4,
              ),
              Image.network(flagUrl),
            ],
          ),
        ));
  }
}