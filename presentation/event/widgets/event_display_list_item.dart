import 'package:flutter/material.dart';
import 'package:ironman/domain/event/entity/event.dart';

class EventListItem extends StatelessWidget {
  final Event event;

  const EventListItem({
    Key key,
    @required this.event,
  })  : assert(event != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.eventTitle),
      subtitle: Text(event.eventDate),
      trailing: Image.network(event.eventFlag),
    );
  }
}