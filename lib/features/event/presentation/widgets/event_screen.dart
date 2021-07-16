import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
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
    final scaffold = ScaffoldMessenger.of(context);
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetState) {
          scaffold.hideCurrentSnackBar();
          displayInternetInfoSnackBar(
              scaffold, 'Internet connected', Colors.green);
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

  void searchQueryCallback() => _scrollController?.animateTo(0,
      duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);

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
        SliverToBoxAdapter(
          child: SizedBox(
            height: 8,
          ),
        ),
        buildSilverBody(context),
        // BlocBuilder<InternetCubit,InternetState>(
        //     builder: (context,state){
        //       if(state is InternetConnected){
        //         return displayNetwokInfo(context,state.connectionType.toString(), Colors.green);
        //       }else if( state is InternetDisconnected){
        //         return displayNetwokInfo('No connection', Colors.red);
        //       }else {
        //         return displayNetwokInfo('Checking internet connection', Colors.grey);
        //       }
        //     }),
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
