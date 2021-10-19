import 'package:flutter/material.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/framework/presentation/widgets/titled_silver_app_bar.dart';
import '../../../../business/domain/models/event_detail.dart';
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
        SliverAppBar(
          backgroundColor: Theme.of(context).primaryColor,
          expandedHeight: 120,
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                eventDetail.eventTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
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
            child: Text('Category:',
                key: Key(CATEGORY_HEADER_KEY),
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
