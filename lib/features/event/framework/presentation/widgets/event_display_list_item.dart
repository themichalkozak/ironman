import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ironman/core/route/event/event_detail_screen_arguments.dart';
import 'package:ironman/core/utils/constants.dart';
import '../../../business/domain/models/event.dart';
import 'package:ironman/features/event/framework/presentation/screens/event_detail_screen.dart';

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
        trailing: Container(
          height: 20,
          width: 20,
          child: CachedNetworkImage(
            key: Key(EVENT_IMAGE_KEY),
            imageUrl: event.eventFlag,
            errorWidget:
                (context, url, error) {
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
