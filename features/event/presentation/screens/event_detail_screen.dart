import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/widgets/loading_widget.dart';
import 'package:ironman/features/event/presentation/widgets/message_display.dart';



class EventDetailScreen extends StatelessWidget {

  static const String routeName = 'event-detail-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is Loading) {
            return LoadingWidget();
          }
          if (state is Error) {
            return MessageDisplay(message: state.errorMessage);
          }
          if (state is LoadedDetail) {
            return buildBody(context, state.event);
          }
          return Center(
            child: Text('Bug 🍑'),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, EventDetail eventDetail) {
    print(eventDetail.toString());
    return CustomScrollView(
      slivers: [
        buildSilverAppBar(context, eventDetail.eventTitle),
        SliverToBoxAdapter(
            child: Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Text(eventDetail.eventDate,
                  style: Theme.of(context).textTheme.headline2),
              Text(',', style: Theme.of(context).textTheme.headline2),
              SizedBox(
                width: 4,
              ),
              Text(eventDetail.eventCountryName,
                  style: Theme.of(context).textTheme.headline2),
              Text(',', style: Theme.of(context).textTheme.headline2),
              SizedBox(
                width: 4,
              ),
              Text(eventDetail.eventVenue,
                  style: Theme.of(context).textTheme.headline2),
              SizedBox(
                width: 4,
              ),
              Image.network(eventDetail.eventFlag),
            ],
          ),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Information: ',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(eventDetail.information ?? 'No information'),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text('Category: ',
                style: Theme.of(context).textTheme.headline1),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20, left: 20.0, top: 4),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text(
                  eventDetail.eventSpecifications[index].name,
                ),
              ),
            ),
          );
        }, childCount: eventDetail.eventSpecifications.length)),
        SliverFillRemaining()
      ],
    );
  }

  Widget buildSilverAppBar(BuildContext context, String title) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 150,
      floating: false,
      pinned: true,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 8, bottom: 8),
            collapseMode: CollapseMode.parallax,
            title: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
