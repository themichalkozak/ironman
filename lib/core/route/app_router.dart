import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/route/event/event_detail_screen_arguments.dart';
import '../../features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/core/injector_container.dart' as di;
import 'package:ironman/features/event/framework/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/framework/presentation/bloc/detail/bloc.dart';
import 'package:ironman/features/event/framework/presentation/screens/event_detail_screen.dart';
import 'package:ironman/features/event/framework/presentation/widgets/event_screen.dart';

class AppRouter {
  final EventBloc _eventBloc = di.sl<EventBloc>();

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _eventBloc..add(SearchNewQuery(query: '',orderAndFilter: EVENT_FILTER_QUERY)),
                  child: EventScreen(),
                ));
        break;
      case EventDetailScreen.routeName:
        if(routeSettings.name == EventDetailScreen.routeName){
          final args = routeSettings.arguments as EventDetailScreenArgument;
          return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => di.sl<EventDetailBloc>()..add(GetEventByIdEvent(id: args.id)),
                child: EventDetailScreen(),
              ));
        }
        break;
      default:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _eventBloc,
                  child: EventScreen(),
                ));
        break;
    }
  }
}
