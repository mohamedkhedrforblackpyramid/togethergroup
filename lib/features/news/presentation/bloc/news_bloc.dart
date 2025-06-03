import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_top_headlines.dart';
import '../../domain/usecases/search_articles.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;
  final SearchArticles searchArticles;
  int currentPage = 1;
  String? currentFromDate;
  String? currentToDate;

  NewsBloc({
    required this.getTopHeadlines,
    required this.searchArticles,
  }) : super(NewsInitial()) {
    on<GetTopHeadlinesEvent>(_onGetTopHeadlines);
    on<SearchArticlesEvent>(_onSearchArticles);
    on<LoadMoreArticlesEvent>(_onLoadMoreArticles);
  }

  Future<void> _onGetTopHeadlines(
    GetTopHeadlinesEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    currentPage = 1;
    currentFromDate = null;
    currentToDate = null;
    
    final failureOrArticles = await getTopHeadlines(PageParams(page: 1));
    emit(failureOrArticles.fold(
      (failure) => NewsError(message: _mapFailureToMessage(failure)),
      (articles) => NewsLoaded(articles: articles),
    ));
  }

  Future<void> _onSearchArticles(
    SearchArticlesEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    currentPage = 1;
    currentFromDate = event.fromDate;
    currentToDate = event.toDate;
    
    final failureOrArticles = await searchArticles(
      SearchParams(
        query: event.query,
        page: 1,
        fromDate: event.fromDate,
        toDate: event.toDate,
      ),
    );
    emit(failureOrArticles.fold(
      (failure) => NewsError(message: _mapFailureToMessage(failure)),
      (articles) => NewsLoaded(articles: articles),
    ));
  }

  Future<void> _onLoadMoreArticles(
    LoadMoreArticlesEvent event,
    Emitter<NewsState> emit,
  ) async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      currentPage++;
      final failureOrArticles = event.isSearch
          ? await searchArticles(
              SearchParams(
                query: event.query,
                page: currentPage,
                fromDate: event.fromDate ?? currentFromDate,
                toDate: event.toDate ?? currentToDate,
              ),
            )
          : await getTopHeadlines(PageParams(page: currentPage));

      emit(failureOrArticles.fold(
        (failure) => NewsError(message: _mapFailureToMessage(failure)),
        (newArticles) => NewsLoaded(
          articles: [...currentState.articles, ...newArticles],
        ),
      ));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case NetworkFailure:
        return 'Please check your internet connection';
      default:
        return 'Unexpected error';
    }
  }
} 