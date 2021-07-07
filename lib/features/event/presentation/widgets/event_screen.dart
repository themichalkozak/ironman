
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/widgets/widgets.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: buildBody(context));
  }
}

Widget buildBody(BuildContext context) {
  return CustomScrollView(
    shrinkWrap: true,
    slivers: [
      TitledSilverAppBar(title: 'Event'),
      SearchBoxSilverAppBar(),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 8,
        ),
      ),
      buildSilverBody(context),
    ],
  );
}

BlocBuilder<EventBloc, EventState> buildSilverBody(BuildContext context) {
  return BlocBuilder<EventBloc, EventState>(builder: (context, state) {
    if (state is Empty) {
      return SliverFillRemaining(
          child: MessageDisplay(message: 'Start searching'));
    } else if (state is Loading) {
      return SliverFillRemaining(child: LoadingWidget());
    } else if (state is Error) {
      return SliverFillRemaining(
          child: MessageDisplay(message: state.errorMessage));
    } else {
      final loadState = state as Loaded;
      if(loadState.events.isEmpty){
        return SliverFillRemaining(child: EmptyList());
      }
      return EventDisplay(events: loadState.events, isExhausted: loadState.isExhausted);

    }
  });
}
