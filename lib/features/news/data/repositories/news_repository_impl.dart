import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.getTopHeadlines(page: page);
        return Right(remoteArticles);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchArticles({
    required String query,
    int page = 1,
    String? fromDate,
    String? toDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.searchArticles(
          query,
          page: page,
          fromDate: fromDate,
          toDate: toDate,
        );
        return Right(remoteArticles);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(const NetworkFailure());
    }
  }
} 