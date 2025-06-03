import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../widgets/article_list_item.dart';
import 'article_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load all news initially
    context.read<NewsBloc>().add(GetTopHeadlinesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<NewsBloc>().state;
      if (state is NewsLoaded) {
        context.read<NewsBloc>().add(
              LoadMoreArticlesEvent(
                isSearch: _isSearching,
                query: _searchController.text,
              ),
            );
      }
    }
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      context.read<NewsBloc>().add(SearchArticlesEvent(query));
    }
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    context.read<NewsBloc>().add(GetTopHeadlinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search news...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _performSearch(),
              )
            : const Text('Latest News'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _clearSearch();
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoading && state is! NewsLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            if (state.articles.isEmpty) {
              return const Center(
                child: Text('No articles found'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                if (_isSearching && _searchController.text.isNotEmpty) {
                  _performSearch();
                } else {
                  context.read<NewsBloc>().add(GetTopHeadlinesEvent());
                }
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.articles.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.articles.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final article = state.articles[index];
                  return ArticleListItem(
                    article: article,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(article: article),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is NewsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_isSearching && _searchController.text.isNotEmpty) {
                        _performSearch();
                      } else {
                        context.read<NewsBloc>().add(GetTopHeadlinesEvent());
                      }
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}