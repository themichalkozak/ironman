import 'package:flutter/material.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/presentation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterChipWidget extends StatelessWidget {

  final String selectedOrderAndFilter;
  final String currentOrderAndFilter;


  FilterChipWidget(this.currentOrderAndFilter,this.selectedOrderAndFilter);

  @override
  Widget build(BuildContext context) {
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

}

bool isSelected(String selected, String current) => selected == current;

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

void updateOrderAndFilter(BuildContext context, String orderAndFilter) {
  context
      .read<EventBloc>()
      .add(UpdateOrderAndFilter(orderAndFilter: orderAndFilter));
}
