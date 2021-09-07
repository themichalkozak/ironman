import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/framework/presentation/widgets/filter_chip_widget.dart';


class FilterGroupChipWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(builder: (context, state) {
      if (state is Loaded) {
        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterChipWidget(EVENT_FILTER_QUERY, state.orderAndFilter),
                SizedBox(width: 8,),
                FilterChipWidget(
                    EVENT_FILTER_FUTURE_DATE, state.orderAndFilter),
                SizedBox(width: 8,),
                FilterChipWidget(
                    EVENT_FILTER_PAST_DATE, state.orderAndFilter),
              ],
            ),
          ),
        );
      } else {
        return SliverToBoxAdapter(child: SizedBox());
      }
    });
  }

}