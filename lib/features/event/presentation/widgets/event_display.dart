import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/widgets/bottom_loader.dart';
import 'package:ironman/features/event/presentation/widgets/event_display_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return CustomScrollView(
      slivers: [_buildSilverList(widget.events, widget.isExhausted,context)],
    );
  }
}

Widget _buildSilverList(List<Event> events, bool isExhausted, BuildContext bContext) {
  return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        print('event_display | _buildSilverList | index: $index');
    final itemIndex = index ~/ 2;
    if (index.isEven) {
      print('event_display | _buildSilverList | itemIndex: $itemIndex');
      if (itemIndex >= events.length) {
        bContext.read<EventBloc>().add(SearchNextPageResultEvent());
        return BottomLoader();
      }
      return EventListItem(event: events[itemIndex]);
    }
    return Divider(height: 0,color: Colors.grey,);
  }, semanticIndexCallback: (widget, localIndex) {
    if (localIndex.isEven) {
      return localIndex ~/ 2;
    }
    return null;
  },
          childCount: max(
              0,
          (isExhausted
              ? events.length
              : events.length + 1)
              * 2 -
              1)
      )
  );
}
