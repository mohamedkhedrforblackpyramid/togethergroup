# Features Directory

Each feature should follow this structure:

```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── remote_data_source.dart
│   │   └── local_data_source.dart
│   ├── models/
│   │   └── model.dart
│   └── repositories/
│       └── repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── entity.dart
│   ├── repositories/
│   │   └── repository.dart
│   └── usecases/
│       └── usecase.dart
└── presentation/
    ├── bloc/
    │   ├── bloc.dart
    │   ├── event.dart
    │   └── state.dart
    ├── pages/
    │   └── page.dart
    └── widgets/
        └── widgets.dart
``` 