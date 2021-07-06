
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
      SliverAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        expandedHeight: 150,
        centerTitle: true,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Text('Event',style: TextStyle(color: Colors.white,fontSize: 32,fontWeight: FontWeight.bold),),
          ),
        ),
      ),
      SliverAppBar(
        backgroundColor: Colors.white,
        pinned: true,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          child: TextField(
            onSubmitted: (value) {
              context
                  .read<EventBloc>()
                  .add(SearchEventsByQueryEvent(query: value));
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(10))),
              contentPadding: const EdgeInsets.all(12.0),
              labelText: 'Search',
            ),
          ),
        ),
      ),
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
      return SliverToBoxAdapter(
          child: MessageDisplay(message: 'Start searching'));
    } else if (state is Loading) {
      return SliverFillRemaining(child: LoadingWidget());
    } else if (state is Loaded) {
      return EventDisplay(events: state.events, isExhausted: state.isExhausted);
    } else if (state is Error) {
      return SliverToBoxAdapter(
          child: MessageDisplay(message: state.errorMessage));
    } else {
      return SliverToBoxAdapter(
        child: Center(
          child: Text('Smth goes wrong'),
        ),
      );
    }
  });
}
