
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/widgets/widgets.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: buildBody(context,searchQueryCallback));
  }

  void searchQueryCallback() =>
      _scrollController?.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  Widget buildBody(BuildContext context,Function searchQueryCallback) {
    return CustomScrollView(
      controller: _scrollController,
      shrinkWrap: true,
      slivers: [
        TitledSilverAppBar(title: 'Event'),
        SearchBoxSilverAppBar(callback: searchQueryCallback),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 8,
          ),
        ),
        buildSilverBody(context),
      ],
    );
  }
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
