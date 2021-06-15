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
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: _handleScrollNotification,
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            return index == widget.events.length
                ? Container(
              alignment: Alignment.center,
              height: 50,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
                child: Text('Load more events..',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),))
                : EventListItem(event: widget.events[index]);
          },
          itemCount: widget.events.length + 1,
        ));
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    print(_scrollController.position.extentAfter);
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
    //  todo not implemented
    }
    return false;
  }
}
