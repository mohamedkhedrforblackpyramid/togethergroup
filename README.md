# News Reader App

A Flutter application that fetches and displays news articles from NewsAPI.org. The app follows Clean Architecture principles and uses BLoC for state management.

## Project Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── dio_helper.dart
│   │   ├── end_points.dart
│   │   └── network_info.dart
│   └── usecases/
│       └── usecase.dart
└── features/
    └── news/
        ├── data/
        │   ├── datasources/
        │   │   └── news_remote_data_source.dart
        │   ├── models/
        │   │   └── article_model.dart
        │   └── repositories/
        │       └── news_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── article.dart
        │   ├── repositories/
        │   │   └── news_repository.dart
        │   └── usecases/
        │       ├── get_top_headlines.dart
        │       └── search_articles.dart
        └── presentation/
            ├── bloc/
            │   ├── news_bloc.dart
            │   ├── news_event.dart
            │   └── news_state.dart
            ├── pages/
            │   ├── article_detail_page.dart
            │   └── news_page.dart
            └── widgets/
                └── article_list_item.dart
```

## Features

- Fetch and display news articles from NewsAPI.org
- Search functionality
- Infinite scrolling pagination
- Clean Architecture implementation
- BLoC pattern for state management
- Dependency Injection using get_it
- Error handling and offline support
- Modern Material Design UI

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  get_it: ^7.6.0
  dartz: ^0.10.1
  http: ^1.1.0
  dio: ^5.3.2
  shared_preferences: ^2.2.0
  internet_connection_checker: ^1.0.0+1
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Make sure you have a valid API key from [NewsAPI.org](https://newsapi.org)
4. Update the API key in `lib/features/news/data/datasources/news_remote_data_source.dart`
5. Run the app using `flutter run`

## Architecture

The project follows Clean Architecture principles with three main layers:

1. **Data Layer**
   - Remote data source
   - Models
   - Repository implementations

2. **Domain Layer**
   - Entities
   - Repository interfaces
   - Use cases

3. **Presentation Layer**
   - BLoC (Business Logic Component)
   - Pages
   - Widgets

## Error Handling

The app implements comprehensive error handling:
- Network errors
- API errors
- Offline support
- User-friendly error messages

## State Management

Uses BLoC pattern with the following states:
- NewsInitial
- NewsLoading
- NewsLoaded
- NewsError

And events:
- GetTopHeadlinesEvent
- SearchArticlesEvent
- LoadMoreArticlesEvent

## Contributing

Feel free to submit issues and enhancement requests.
