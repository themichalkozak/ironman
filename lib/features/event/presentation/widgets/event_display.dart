import 'package:flutter/material.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/presentation/widgets/event_display_list_item.dart';

class EventDisplay extends StatefulWidget {
  final List<Event> events;

  EventDisplay({
    Key key,
    @required this.events,
  })  : assert(events != null),
        super(key: key);

  @override
  _EventDisplayState createState() => _EventDisplayState();
}

class _EventDisplayState extends State<EventDisplay> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    setUpScrollControllerListener();
    super.initState();
  }

  void setUpScrollControllerListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('NEXT PAGE');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return EventListItem(event: widget.events[index]);
      },
      itemCount: widget.events.length,
    );
  }
}
