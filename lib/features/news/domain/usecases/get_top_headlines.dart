import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines implements UseCase<List<Article>, PageParams> {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(PageParams params) async {
    return await repository.getTopHeadlines(page: params.page);
  }
}

class PageParams extends Equatable {
  final int page;

  const PageParams({this.page = 1});

  @override
  List<Object?> get props => [page];
} 