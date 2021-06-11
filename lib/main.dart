import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/injector_container.dart' as di;
import 'package:ironman/core/route/app_router.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/screens/event_detail_screen.dart';

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
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),
            headline2: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
          )
        ),
        onGenerateRoute: di.sl<AppRouter>().onGenerateRoute
    );
  }
}