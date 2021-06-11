import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/core/injector_container.dart' as di;
import 'package:ironman/features/event/presentation/screens/event_detail_screen.dart';
import 'package:ironman/features/event/presentation/screens/event_screen.dart';

class AppRouter {
  final EventBloc _eventBloc = di.sl<EventBloc>()..add(GetEventsEvent());

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _eventBloc,
                  child: EventScreen(),
                ));
        break;
      case EventDetailScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _eventBloc,
                  child: EventDetailScreen(),
                ));
        break;
      default:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _eventBloc,
                  child: EventScreen(),
                ));
    }
  }
}
