import 'package:flutter/material.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'widgets.dart';

class EventDetailDisplay extends StatelessWidget {
  final EventDetail eventDetail;

  const EventDetailDisplay({
    @required this.eventDetail,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        EventDetailSilverAppBar(title: eventDetail.eventTitle),
        EventDetailRow(
          date: eventDetail.eventDate,
          country: eventDetail.eventCountryName,
          venue: eventDetail.eventVenue,
          flagUrl: eventDetail.eventFlag,
        ),
        EventDetailInformationWidget(information: eventDetail.information),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text('Category: ',
                style: Theme.of(context).textTheme.headline1),
          ),
        ),
        EventCategoryListWidget(
            eventSpecifications: eventDetail.eventSpecifications),
        SliverFillRemaining()
      ],
    );
  }
}