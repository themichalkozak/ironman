import 'package:flutter/material.dart';
import '../../../../business/domain/models/event_detail.dart';

class EventCategoryListWidget extends StatelessWidget {
  final List<EventSpecification> eventSpecifications;

  const EventCategoryListWidget({
    @required this.eventSpecifications,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20, left: 20.0, top: 4),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text(
                  eventSpecifications[index].name,
                ),
              ),
            ),
          );
        }, childCount: eventSpecifications.length));
  }
}