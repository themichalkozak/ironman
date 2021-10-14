import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/framework/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/framework/presentation/widgets/widgets.dart';

class EventList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<EventBloc, EventState>(builder: (context, state) {
      if (state is Initial) {
        return SliverFillRemaining(
            child: MessageDisplay(message: 'Start searching'));
      } else if (state is Loading) {
        return SliverFillRemaining(child: LoadingWidget());
      } else if (state is Error) {
        return SliverFillRemaining(
            child: MessageDisplay(message: state.errorMessage));
      } else {
        final loadState = state as Loaded;
        if (loadState.events.isEmpty) {
          return SliverToBoxAdapter(
              child: MessageDisplay(
                  message: EVENTS_NOT_FOUND_MESSAGE_TEXT,
                  assetPath: 'assets/images/event_date_and_time_symbol.png'));
        }
        return EventDisplay(
            events: loadState.events, isExhausted: loadState.isExhausted);
      }
    });
  }
}