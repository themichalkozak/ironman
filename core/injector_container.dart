import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/core/route/app_router.dart';
import 'package:ironman/features/event/domain/useCases/get_event_by_id.dart';
import 'package:ironman/features/event/domain/useCases/get_events.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/bloc/detail/bloc.dart';
import '../features/event/data/event/event_remote_data_source.dart';
import '../features/event/data/event/event_repository_impl.dart';
import '../features/event/domain/event_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  // UseCases
  sl.registerLazySingleton(() => GetEvents(sl()));
  sl.registerLazySingleton(() => SearchEventsByQuery(sl()));
  sl.registerLazySingleton(() => GetEventById(sl()));
  // Bloc
  sl.registerFactory<EventBloc>(() => (EventBloc(getEvents: sl(),searchEventsByQuery: sl())));
  sl.registerFactory<EventDetailBloc>(() => (EventDetailBloc(getEventById: sl())));
  // Repositories
  sl.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(
          remoteDataSource: sl(),
          networkInfo: sl()
      ));
  // Data sources
  sl.registerLazySingleton<EventRemoteDataSource>(() => EventRemoteDataSourceImpl(sl()));
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<AppRouter>(() => AppRouter());
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
