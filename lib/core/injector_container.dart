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
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/business/domain/utils/date_util.dart';
import 'package:ironman/features/event/business/interactors/get_event_by_id.dart';
import 'package:ironman/features/event/business/interactors/search_events_by_query.dart';
import 'package:ironman/features/event/framework/datasource/cache/abstraction/event_dao_service.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/implementaion/event_hive_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/implementation/event_dao_service_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/mappers/cache_detail_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/mappers/cache_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/mappers/cache_specification_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';
import 'package:ironman/features/event/framework/datasource/network/implementation/event_api_service_impl.dart';
import 'package:ironman/features/event/framework/datasource/network/mappers/network_event_detail_mapper.dart';
import 'package:ironman/features/event/framework/presentation/bloc/detail/event_detail_bloc.dart';
import 'package:ironman/features/event/framework/presentation/bloc/event_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {


  final box = await Hive.openBox('events');
  final singleEventsBox = await Hive.openBox<EventDetail>('singleEvents');
  // Features
  // UseCases
  sl.registerLazySingleton(() => SearchEventsByQuery(sl(),sl(),sl()));
  sl.registerLazySingleton(() => GetEventById(sl(),sl(),sl()));
  // Bloc
  sl.registerFactory<InternetCubit>(() => InternetCubit(connectivity: sl()));
  sl.registerFactory<EventBloc>(() => (EventBloc(searchEventsByQuery: sl())));
  sl.registerFactory<EventDetailBloc>(() => (EventDetailBloc(getEventById: sl())));

  // Data sources
  sl.registerLazySingleton<EventHive>(() => EventHiveImpl(box, singleEventsBox));
  sl.registerLazySingleton<EventApiService>(() => EventApiServiceImpl(sl(),sl()));
  sl.registerLazySingleton<EventDaoService>(() => EventDaoServiceImpl(sl(),sl(),sl()));
  sl.registerLazySingleton<EventCacheDataSource>(() => EventCacheDataSourceImpl(sl()));
  sl.registerLazySingleton<EventNetworkDataSource>(() => EventNetworkDataSourceImpl(sl()));
  // Core
  sl.registerLazySingleton(() => SpecificationEventCacheMapper());
  sl.registerLazySingleton(() => EventDetailCacheMapper(sl()));
  sl.registerLazySingleton(() => NetworkMapper());
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
