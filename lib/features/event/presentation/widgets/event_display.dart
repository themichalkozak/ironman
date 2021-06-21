import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/widgets/event_display_list_item.dart';

class EventDisplay extends StatefulWidget {
  final bool isExhausted;
  final List<Event> events;

  EventDisplay({Key key, @required this.events, @required this.isExhausted})
      : assert(events != null),
        assert(isExhausted != null),
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
            return index >= widget.events.length && !widget.isExhausted
                ? Container(
                    alignment: Alignment.center,
                    height: 50,
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    child: Text(
                      'Load more events..',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ))
                : EventListItem(event: widget.events[index]);
          },
          itemCount: widget.isExhausted
              ? widget.events.length
              : widget.events.length + 1,
        ));
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    print(_scrollController.position.extentAfter);
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      BlocProvider.of<EventBloc>(context).add(SearchNextPageResultEvent());
    }
    return false;
  }
}
