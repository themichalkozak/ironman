import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';
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
      controller: _scrollController,
      shrinkWrap: true,
      slivers: [
        TitledSilverAppBar(title: 'Event'),
        SearchBoxSilverAppBar(callback: searchQueryCallback),
        silverChipEvent(context),
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

Widget displayNetwokInfo(BuildContext context, String message, Color color) {
  return SliverFillRemaining(
    hasScrollBody: false,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 30,
        color: color,
        child: Text(message),
      ),
    ),
  );
}

Widget silverChipEvent(BuildContext context) {
  return BlocBuilder<EventBloc, EventState>(builder: (context, state) {
    if (state is Loaded) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildFilterChip(EVENT_FILTER_QUERY, state.orderAndFilter, context),
              SizedBox(width: 8,),
              _buildFilterChip(
                  EVENT_FILTER_FUTURE_DATE, state.orderAndFilter, context),
              SizedBox(width: 8,),
              _buildFilterChip(
                  EVENT_FILTER_PAST_DATE, state.orderAndFilter, context),
            ],
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter(child: SizedBox());
    }
  });
}

Widget _buildFilterChip(String currentOrderAndFilter,
    String selectedOrderAndFilter, BuildContext context) {
  return FilterChip(
      selectedColor: Theme.of(context).primaryColor,
      selected: isSelected(selectedOrderAndFilter,currentOrderAndFilter),
      label: Text(_convertEventTenseToString(currentOrderAndFilter)),
      onSelected: (bool selected) {
        if (selected) {
          updateOrderAndFilter(context, currentOrderAndFilter);
          print(
              'event_screen | FilterChips | eventTense: $currentOrderAndFilter | onSelect: $selectedOrderAndFilter');
        }
      });
}

bool isSelected(String selected, String current) => selected == current;

void updateOrderAndFilter(BuildContext context, String orderAndFilter) {
  context
      .read<EventBloc>()
      .add(UpdateOrderAndFilter(orderAndFilter: orderAndFilter));
}

String _convertEventTenseToString(String orderAndFilter) {
  switch (orderAndFilter) {
    case EVENT_FILTER_PAST_DATE:
      return 'PAST';
    case EVENT_FILTER_QUERY:
      return 'ALL';
    case EVENT_FILTER_FUTURE_DATE:
      return 'UPCOMING';
    default:
      return 'ALL';
  }
}

bool isHighlighted(String selected, String current) => selected == current;

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
      if (loadState.events.isEmpty) {
        return SliverToBoxAdapter(child: EmptyList());
      }
      return EventDisplay(
          events: loadState.events, isExhausted: loadState.isExhausted);
    }
  });
}
