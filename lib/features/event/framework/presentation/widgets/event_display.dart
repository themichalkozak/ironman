import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ironman/features/event/framework/presentation/widgets/reconect_bottom_button.dart';
import '../../../business/domain/models/event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/framework/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/framework/presentation/widgets/bottom_loader.dart';
import 'package:ironman/features/event/framework/presentation/widgets/widgets.dart';

class EventDisplay extends StatefulWidget {
  final bool isExhausted;
  final bool isTimeout;
  final List<Event> events;

  EventDisplay(
      {Key key,
      @required this.events,
      @required this.isExhausted,
      this.isTimeout = false})
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
          if (widget.isTimeout) {
            return ReconnectBottomButton(callback: () => _reconnectSearchNextPageQuery(context));
          } else {
            print('event_display searchNextPage');
            _searchNextPage(context);
            return BottomLoader();
          }
        }
        return EventListItem(event: widget.events[itemIndex]);
      }
      return Divider(
        height: 0,
        color: Colors.grey,
      );
    }, semanticIndexCallback: (widget, localIndex) {
      if (localIndex.isEven) {
        return localIndex ~/ 2;
      }
      return null;
    },
            childCount: max(
                0,
                ((widget.isExhausted && !widget.isTimeout)
                            ? widget.events.length
                            : widget.events.length + 1) * 2 - 1)
        ));
  }

  void _searchNextPage(BuildContext bContext) {
    print('event_display | _searchNextPage invoke | context: $bContext');
    bContext.read<EventBloc>().add(SearchNextPageResultEvent());
  }

  void _reconnectSearchNextPageQuery(BuildContext context){
    print('event_display | _reconnectSearchNextPageQuery invoke | context: $context');
    context.read<EventBloc>().add(RefreshSearchEventsByQueryEvent());
  }
}
