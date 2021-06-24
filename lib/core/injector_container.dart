import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/core/route/app_router.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import 'package:ironman/features/event/domain/useCases/get_event_by_id.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/bloc/detail/bloc.dart';
import '../features/event/data/event/event_remote_data_source.dart';
import '../features/event/data/event/event_repository_impl.dart';
import '../features/event/domain/event_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {


  final box = await Hive.openBox('events');
  // Features
  // UseCases
  sl.registerLazySingleton(() => SearchEventsByQuery(sl()));
  sl.registerLazySingleton(() => GetEventById(sl()));
  // Bloc
  sl.registerFactory<EventBloc>(() => (EventBloc(searchEventsByQuery: sl())));
  sl.registerFactory<EventDetailBloc>(() => (EventDetailBloc(getEventById: sl())));
  // Repositories
  sl.registerLazySingleton<EventRepository>(
      () {
        return EventRepositoryImpl(
          localDataSource: sl(),
          remoteDataSource: sl(),
          networkInfo: sl()
      );
      });
  // Data sources
  sl.registerLazySingleton<EventLocalDataSource>(() => HiveEventLocalDataSourceImpl(box));
  sl.registerLazySingleton<EventRemoteDataSource>(() => EventRemoteDataSourceImpl(sl()));
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<AppRouter>(() => AppRouter());
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
