import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/core/route/app_router.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/cache/implementation/event_cache_data_source_impl.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/business/data/network/implementation/EventNetworkDataSourceImpl.dart';
import 'package:ironman/features/event/business/domain/utils/date_util.dart';
import 'package:ironman/features/event/business/interactors/SearchEventsByQuery.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import 'package:ironman/features/event/domain/useCases/get_event_by_id.dart';
import 'package:ironman/features/event/domain/useCases/search_local_events_by_query.dart';
import 'package:ironman/features/event/domain/useCases/search_upcoming_events_by_query.dart';
import 'package:ironman/features/event/framework/datasource/cache/abstraction/event_dao_service.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/implementaion/event_hive_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/implementation/event_dao_service_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/mappers/cache_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';
import 'package:ironman/features/event/framework/datasource/network/implementation/event_api_service_impl.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:ironman/features/event/presentation/bloc/detail/bloc.dart';
import '../features/event/data/event/event_remote_data_source.dart';
import '../features/event/data/event/event_repository_impl.dart';
import '../features/event/domain/event_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {


  final box = await Hive.openBox('events');
  final singleEventsBox = await Hive.openBox('singleEvents');
  // Features
  // UseCases
  sl.registerLazySingleton(() => SearchEventsByQuery(sl(),sl(),sl()));
  sl.registerLazySingleton(() => SearchUpcomingEventsByQuery(sl()));
  sl.registerLazySingleton(() => GetEventById(sl()));
  sl.registerLazySingleton(() => SearchLocalEventsByQuery(sl()));
  // Bloc
  sl.registerFactory<InternetCubit>(() => InternetCubit(connectivity: sl()));
  sl.registerFactory<EventBloc>(() => (EventBloc(searchEventsByQuery: sl(),searchLocalEventsByQuery: sl(),searchUpcomingEventsByQuery: sl())));
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
  sl.registerLazySingleton<EventHive>(() => EventHiveImpl(box, singleEventsBox));
  sl.registerLazySingleton<EventApiService>(() => EventApiServiceImpl(sl()));
  sl.registerLazySingleton<EventDaoService>(() => EventDaoServiceImpl(sl(),sl()));
  sl.registerLazySingleton<EventCacheDataSource>(() => EventCacheDataSourceImpl(sl()));
  sl.registerLazySingleton<EventNetworkDataSource>(() => EventNetworkDataSourceImpl(sl()));
  sl.registerLazySingleton<EventLocalDataSource>(() => HiveEventLocalDataSourceImpl(box,singleEventsBox));
  sl.registerLazySingleton<EventRemoteDataSource>(() => EventRemoteDataSourceImpl(sl()));
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<AppRouter>(() => AppRouter());
  sl.registerLazySingleton(() => Connectivity());
  // TODO check this out !
  sl.registerLazySingleton(() => DateUtils());
  sl.registerLazySingleton<EventCacheMapper>(() => EventCacheMapper(sl()));
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
