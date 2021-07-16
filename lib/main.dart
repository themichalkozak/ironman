import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/core/injector_container.dart' as di;
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/core/route/app_router.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import 'package:path_provider/path_provider.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   final appDocumentDir = await getApplicationDocumentsDirectory();
   Hive.init(appDocumentDir.path);
   Hive.registerAdapter(EventModelAdapter());
   await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => di.sl<InternetCubit>(),
    child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),
            headline2: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
          )
        ),
        onGenerateRoute: di.sl<AppRouter>().onGenerateRoute
    ),
);
  }
}
