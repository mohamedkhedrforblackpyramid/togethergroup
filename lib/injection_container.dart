import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/news/data/datasources/news_remote_data_source.dart';
import 'features/news/data/repositories/news_repository_impl.dart';
import 'features/news/domain/repositories/news_repository.dart';
import 'features/news/domain/usecases/get_top_headlines.dart';
import 'features/news/domain/usecases/search_articles.dart';
import 'features/news/presentation/bloc/news_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(
    () => NewsBloc(
      getTopHeadlines: sl(),
      searchArticles: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => SearchArticles(sl()));

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
} 