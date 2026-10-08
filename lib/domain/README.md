# Domain layer

Place immutable entities and progress rules in `entities/`, repository contracts
in `repositories/`, and use cases in `usecases/`.

This layer uses Dart, dartz, equatable, and the framework-free parts of core.
Repository methods and use cases return `Either<AppFailure, Entity>`.
Read requirements and overall completion from the API-backed entity. UI copy,
colors, Flutter, Dio, and service-locator lookups do not belong here.

`TopicProgress` preserves attendance above the requirement, clamps visual fill,
and rejects negative attendance or non-positive requirements at runtime. The
data layer must convert invalid API values into `InvalidResponseFailure`.
`TheoryProgress` adds remaining counts per section; extra lessons in one category
cannot replace lessons in the other. The API's `completed` flag controls overall
stage and exam availability even if the section counts disagree with that flag.
