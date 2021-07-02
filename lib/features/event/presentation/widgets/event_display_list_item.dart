import 'package:flutter/material.dart';
import 'package:ironman/core/route/event/event_detail_screen_arguments.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/presentation/screens/event_detail_screen.dart';

class EventListItem extends StatelessWidget {
  final Event event;

  const EventListItem({
    Key key,
    @required this.event,
  })  : assert(event != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(
            EventDetailScreen.routeName,
            arguments: EventDetailScreenArgument(id: event.eventId)),
        title: Text(event.eventTitle),
        subtitle: Text(event.eventDate),
        trailing: Image.network(
          event.eventFlag,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) {
            return SizedBox();
          },
        ),
      ),
    );
  }
}
