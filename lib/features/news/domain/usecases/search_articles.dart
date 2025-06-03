import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class SearchArticles implements UseCase<List<Article>, SearchParams> {
  final NewsRepository repository;

  SearchArticles(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(SearchParams params) async {
    return await repository.searchArticles(
      query: params.query,
      page: params.page,
      fromDate: params.fromDate,
      toDate: params.toDate,
    );
  }
}

class SearchParams extends Equatable {
  final String query;
  final int page;
  final String? fromDate;
  final String? toDate;

  const SearchParams({
    required this.query,
    this.page = 1,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [query, page, fromDate, toDate];
} 