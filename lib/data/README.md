# Data layer

Place HTTP data sources in `datasources/`, handwritten JSON models in `models/`,
and domain repository implementations in `repositories/`.

Models implement `fromJson`, `toJson`, and `toEntity`. Convert Dio and parsing
exceptions into the shared plain-Dart failures here. Return `Either` from the
repository; presentation and domain must never depend on Dio or data models.
