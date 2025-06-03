import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class GetTopHeadlinesEvent extends NewsEvent {}

class SearchArticlesEvent extends NewsEvent {
  final String query;
  final String? fromDate;
  final String? toDate;

  const SearchArticlesEvent(
    this.query, {
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [query, fromDate, toDate];
}

class LoadMoreArticlesEvent extends NewsEvent {
  final bool isSearch;
  final String query;
  final String? fromDate;
  final String? toDate;

  const LoadMoreArticlesEvent({
    this.isSearch = false,
    this.query = '',
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [isSearch, query, fromDate, toDate];
} 