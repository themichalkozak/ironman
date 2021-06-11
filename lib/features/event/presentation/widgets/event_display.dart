import 'package:flutter/material.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/presentation/widgets/event_display_list_item.dart';

class EventDisplay extends StatelessWidget {
  final List<Event> events;

  const EventDisplay({
    Key key,
    @required this.events,
  })  : assert(events != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return EventListItem(event: events[index]);
      },itemCount: events.length,);
  }
}