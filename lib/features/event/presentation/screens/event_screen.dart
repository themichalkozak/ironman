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
  return NestedScrollView(
      headerSliverBuilder: (BuildContext silverContext, bool innerBoxScrolled) {
        return buildHeaderSilver(silverContext);
      },
      body: buildSilverBody(context));
}


BlocBuilder<EventBloc, EventState> buildSilverBody(BuildContext context) {
  return BlocBuilder<EventBloc, EventState>(builder: (context, state) {
    if (state is Empty) {
      return MessageDisplay(message: 'Start searching');
    } else if (state is Loading) {
      return LoadingWidget();
    } else if (state is Loaded) {
      return EventDisplay(events: state.events);
    } else if (state is Error) {
      return MessageDisplay(message: state.errorMessage);
    } else {
      return Center(
        child: Text('Smth goes wrong'),
      );
    }
  });
}

