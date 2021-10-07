import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/framework/presentation/widgets/filters_group_chip_widget.dart';
import 'package:ironman/features/event/framework/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/framework/presentation/widgets/widgets.dart';

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
    print('event_screen | build() ');
    final scaffold = ScaffoldMessenger.of(context);
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetConnected) {
          displayInternetInfoSnackBar(
              scaffold, 'Internet connected', Colors.green);
          context.read<EventBloc>().add(RefreshSearchEventsByQueryEvent());
        }
        if (state is InternetDisconnected) {
          displayInternetInfoSnackBar(
              scaffold, 'Internet disconnected', Colors.red);
        }
        if (state is InternetLoading) {
          displayInternetInfoSnackBar(
              scaffold, 'Checking internet connection', Colors.grey);
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: buildBody(context, searchQueryCallback)),
    );
  }

  void displayInternetInfoSnackBar(
      ScaffoldMessengerState state, String title, Color color) {
    state.hideCurrentSnackBar();
    state.showSnackBar(SnackBar(
      content: Text(title),
      backgroundColor: color,
      duration: Duration(seconds: 1),
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void searchQueryCallback() {
    print('event_screen | searchQueryCallback()');
    _scrollController?.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext context, Function searchQueryCallback) {
    final scaffold = ScaffoldMessenger.of(context);
    print('Scaffold Type:');
    print(scaffold.runtimeType);
    return CustomScrollView(
      key: Key(CUSTOM_SCROLL_VIEW_KEY),
      controller: _scrollController,
      shrinkWrap: true,
      slivers: [
        TitledSilverAppBar(title: 'Event'),
        SearchBoxSilverAppBar(callback: searchQueryCallback),
        FilterGroupChipWidget(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 8,
          ),
        ),
        buildSilverBody(context)
      ],
    );
  }
}

BlocBuilder<EventBloc, EventState> buildSilverBody(BuildContext context) {
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
        return SliverToBoxAdapter(child: MessageDisplay(message: EVENTS_NOT_FOUND_MESSAGE_TEXT,assetPath: 'assets/images/event_date_and_time_symbol.png'));
      }
      return EventDisplay(
          events: loadState.events, isExhausted: loadState.isExhausted);
    }
  });
}

bool isHighlighted(String selected, String current) => selected == current;

