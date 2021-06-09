import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/features/event/domain/useCases/get_events.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import '../features/event/data/event/event_remote_data_source.dart';
import '../features/event/data/event/event_repository_impl.dart';
import '../features/event/domain/event_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  // UseCases
  sl.registerLazySingleton(() => GetEvents(sl()));
  // Bloc
  sl.registerFactory<EventBloc>(() => (EventBloc(getEvents: sl())));
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
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
