import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({int page = 1});
  Future<List<ArticleModel>> searchArticles(
    String query, {
    int page = 1,
    String? fromDate,
    String? toDate,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;
  final String apiKey = 'a62166abf28146c98a2fecf211697d82';
  final String baseUrl = 'https://newsapi.org/v2';

  NewsRemoteDataSourceImpl({required this.client});

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Future<List<ArticleModel>> getTopHeadlines({int page = 1}) async {
    try {
      final queryParams = {
        'sources': 'techcrunch',
        'pageSize': '20',
        'page': page.toString(),
        'apiKey': apiKey,
      };

      final uri = Uri.parse('$baseUrl/top-headlines').replace(queryParameters: queryParams);

      print('Requesting URL: $uri'); // For debugging

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'ok') {
          final List<dynamic> articles = jsonResponse['articles'];
          return articles
              .map((article) => ArticleModel.fromJson(article))
              .toList();
        } else {
          throw const ServerException(message: 'API returned error status');
        }
      } else if (response.statusCode == 401) {
        throw const ServerException(message: 'Invalid API key');
      } else if (response.statusCode == 429) {
        throw const ServerException(message: 'Request limit exceeded');
      } else {
        throw ServerException(
          message: 'Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<List<ArticleModel>> searchArticles(
    String query, {
    int page = 1,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'sources': 'techcrunch',
        'pageSize': '20',
        'page': page.toString(),
        'sortBy': 'publishedAt',
        'apiKey': apiKey,
      };

      if (fromDate != null) {
        queryParams['from'] = fromDate;
      }

      if (toDate != null) {
        queryParams['to'] = toDate;
      }

      final uri = Uri.parse('$baseUrl/everything').replace(queryParameters: queryParams);

      print('Requesting URL: $uri'); // For debugging

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // For debugging
      print('Response body: ${response.body}'); // For debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['status'] == 'ok') {
          final List<dynamic> articles = jsonResponse['articles'];
          return articles
              .map((article) => ArticleModel.fromJson(article))
              .toList();
        } else {
          throw ServerException(
            message: jsonResponse['message'] ?? 'API returned error status',
          );
        }
      } else if (response.statusCode == 401) {
        throw const ServerException(message: 'Invalid API key');
      } else if (response.statusCode == 429) {
        throw const ServerException(message: 'Request limit exceeded');
      } else {
        throw ServerException(
          message: 'Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
} 