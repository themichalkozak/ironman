import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/framework/presentation/widgets/event_list.dart';
import 'package:ironman/features/event/framework/presentation/widgets/filters_group_chip_widget.dart';
import 'package:ironman/features/event/framework/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/framework/presentation/widgets/sliver_sub_header.dart';
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
    print(scaffold.runtimeType);
    return CustomScrollView(
      key: Key(CUSTOM_SCROLL_VIEW_KEY),
      controller: _scrollController,
      shrinkWrap: true,
      slivers: [
        TitledSilverAppBar(title: 'Event'),
          SliverSubHeader(
            pinned: true,
            minHeight: 100,
            maxHeight: 40,
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              child: TextField(
                onSubmitted: (value) {
                  print(
                      'search_box_silver_app_bar | TextFiled | onSubmitted | value: $value');
                  searchQueryCallback();
                  context.read<EventBloc>().add(SearchNewQuery(query: value));
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
        FilterGroupChipWidget(),
        EventList()
      ],
    );
  }
}

bool isHighlighted(String selected, String current) => selected == current;
