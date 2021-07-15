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

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((bContext, index) {
          final itemIndex = index ~/ 2;
          if (index.isEven) {
            if (itemIndex >= widget.events.length) {
              _searchNextPage(bContext);
              return BottomLoader();
            }
            return EventListItem(event: widget.events[itemIndex]);
          }
          return Divider(height: 0, color: Colors.grey,);
        },
            semanticIndexCallback: (widget, localIndex) {
              if (localIndex.isEven) {
                return localIndex ~/ 2;
              }
              return null;
            },
            childCount: max(
                0,
                (widget.isExhausted
                    ? widget.events.length
                    : widget.events.length + 1)
                    * 2 -
                    1)
        )
    );
  }

  void _searchNextPage(BuildContext bContext) =>
    bContext.read<EventBloc>().add(SearchNextPageResultEvent());

}