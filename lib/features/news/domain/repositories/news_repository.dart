import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines({int page = 1});
  Future<Either<Failure, List<Article>>> searchArticles({
    required String query,
    int page = 1,
    String? fromDate,
    String? toDate,
  });
} 