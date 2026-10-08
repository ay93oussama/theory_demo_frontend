# Domain layer

Place immutable entities and progress rules in `entities/`, repository contracts
in `repositories/`, and use cases in `usecases/`.

This layer uses Dart, dartz, equatable, and the framework-free parts of core.
Repository methods and use cases return `Either<AppFailure, Entity>`.
Read requirements and overall completion from the API-backed entity. UI copy,
colors, Flutter, Dio, and service-locator lookups do not belong here.
