
import 'package:flutter/material.dart';
import 'package:ironman/presentation/event/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          title: Text('Event',style: TextStyle(color: Colors.black),),
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
        onSubmitted: (value) => {
          context.read<EventBloc>().add(GetEventsEvent())
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  const Radius.circular(10)
              )
          ),
          contentPadding: const EdgeInsets.all(12.0),
          labelText: 'Search',
        ),
      ),
    ),
  );
}