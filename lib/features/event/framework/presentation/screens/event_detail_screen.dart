import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/framework/presentation/bloc/detail/bloc.dart';
import 'package:ironman/features/event/framework/presentation/widgets/detail/widgets.dart';
import 'package:ironman/features/event/framework/presentation/widgets/widgets.dart';


class EventDetailScreen extends StatelessWidget {
  static const String routeName = 'event-detail-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventDetailBloc, EventDetailState>(
        builder: (context, state) {
          if (state is Loading) {
            return LoadingWidget();
          }
          if (state is Error) {
            return MessageDisplay(message: state.errorMessage,assetPath: 'assets/images/event_date_and_time_symbol.png');
          }
          if (state is Loaded) {
            return EventDetailDisplay(eventDetail: state.data);
          }
          return Center(
            child: Text('Bug 🍑'),
          );
        },
      ),
    );
  }
}