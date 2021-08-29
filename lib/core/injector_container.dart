import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/core/route/app_router.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/cache/implementation/event_cache_data_source_impl.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/business/data/network/implementation/EventNetworkDataSourceImpl.dart';
import 'package:ironman/features/event/business/domain/utils/date_util.dart';
import 'package:ironman/features/event/business/interactors/get_event_by_id.dart';
import 'package:ironman/features/event/business/interactors/search_events_by_query.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/abstraciton/event_detail_service_dao.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/hive/abstraction/event_detail_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/hive/implementation/event_detail_hive_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/implementation/event_detail_service_dao_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/model/event_detail_cache_entity.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/hive/abstraction/event_specification_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/hive/implementation/event_specification_hive_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/mapper/cache_specification_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/model/event_specification_cache_entity.dart';
import '../features/event/framework/datasource/cache/event/abstraction/event_dao_service.dart';
import '../features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import '../features/event/framework/datasource/cache/event/hive/implementation/event_hive_impl.dart';
import '../features/event/framework/datasource/cache/event/implementation/event_dao_service_impl.dart';
import '../features/event/framework/datasource/cache/eventDetail/mapper/cache_detail_event_mapper.dart';
import '../features/event/framework/datasource/cache/event/mapper/cache_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';
import 'package:ironman/features/event/framework/datasource/network/implementation/event_api_service_impl.dart';
import 'package:ironman/features/event/framework/datasource/network/mappers/network_event_detail_mapper.dart';
import 'package:ironman/features/event/framework/presentation/bloc/detail/event_detail_bloc.dart';
import 'package:ironman/features/event/framework/presentation/bloc/event_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {


  final box = await Hive.openBox('events');
  final singleEventsBox = await Hive.openBox<EventDetailCacheEntity>('singleEvents');
  final specificationEvent = await Hive.openBox<EventSpecificationCacheEntity>('specificationEvent');
  // Features
  // UseCases
  sl.registerLazySingleton(() => SearchEventsByQuery(sl(),sl(),sl()));
  sl.registerLazySingleton(() => GetEventById(sl(),sl(),sl(),sl()));
  // Bloc
  sl.registerFactory<InternetCubit>(() => InternetCubit(connectivity: sl()));
  sl.registerFactory<EventBloc>(() => (EventBloc(searchEventsByQuery: sl())));
  sl.registerFactory<EventDetailBloc>(() => (EventDetailBloc(getEventById: sl())));

  // Data sources
  sl.registerLazySingleton<EventCacheDataSource>(() => EventCacheDataSourceImpl(sl(),sl()));
  sl.registerLazySingleton<EventNetworkDataSource>(() => EventNetworkDataSourceImpl(sl()));

  sl.registerLazySingleton<EventDaoService>(() => EventDaoServiceImpl(sl(),sl(),sl()));
  sl.registerLazySingleton<EventDetailServiceDao>(() => EventDetailServiceDaoImpl(sl(),sl(),sl(),sl()));

  // Api
  sl.registerLazySingleton<EventApiService>(() => EventApiServiceImpl(sl(),sl()));

  // Hive
  sl.registerLazySingleton<EventHive>(() => EventHiveImpl(box));
  sl.registerLazySingleton<EventDetailHive>(() => EventDetailHiveImpl(singleEventsBox));
  sl.registerLazySingleton<EventSpecificationHive>(() => EventSpecificationHiveImpl(specificationEvent));


  // Core

  // Mapper
  sl.registerLazySingleton(() => SpecificationEventCacheMapper());
  sl.registerLazySingleton(() => EventDetailCacheMapper(sl()));
  sl.registerLazySingleton(() => NetworkMapper());


  sl.registerLazySingleton<AppRouter>(() => AppRouter());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DateUtils());
  sl.registerLazySingleton<EventCacheMapper>(() => EventCacheMapper(sl()));
  // External
  sl.registerLazySingleton(() => http.Client());
}
