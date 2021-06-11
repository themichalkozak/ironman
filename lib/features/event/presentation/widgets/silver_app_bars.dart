import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';

List<Widget> buildHeaderSilver(BuildContext context) {
  return <Widget>[buildFirstAppBar(), buildSecondAppBar(context)];
}

SliverAppBar buildFirstAppBar() {
  return SliverAppBar(
    backgroundColor: Colors.white,
    expandedHeight: 150,
    floating: false,
    elevation: 0,
    flexibleSpace: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          title: Text(
            'Event',
            style: TextStyle(color: Colors.black),
          ),
        );
      },
    ),
  );
}

SliverAppBar buildSecondAppBar(BuildContext context) {
  return SliverAppBar(
    backgroundColor: Colors.white,
    pinned: true,
    title: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      child: TextField(
        onSubmitted: (value) {

          if (value == null || value.isEmpty) {
            context.read<EventBloc>().add(GetEventsEvent());
          } else {
              context
                  .read<EventBloc>()
                  .add(SearchEventsByQueryEvent(query: value));
            }
        print(value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(const Radius.circular(10))),
          contentPadding: const EdgeInsets.all(12.0),
          labelText: 'Search',
        ),
      ),
    ),
  );
}
