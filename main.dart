import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/injector_container.dart' as di;
import 'package:ironman/features/event/presentation/bloc/bloc.dart';

import 'features/event/presentation/screens/event_screen.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => di.sl<EventBloc>()..add(GetEventsEvent()),
          child: EventScreen(),
        )
    );
  }
}
