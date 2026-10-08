# Theory Progress

A German Flutter app for Class B theory attendance, built as a frontend interview
task. The targets are iPhone 17 Pro Max and an Android simulator.

## Current milestone

Task 1 establishes the app shell, German copy catalogue, Material 3 theme and
design tokens, bundled Schibsted Grotesk fonts, layer structure, and dependencies.
Task 2 adds framework-free failures, the use-case base, domain entities and
progress rules, the repository contract, and the progress use case with tests.
Task 3 adds the header/badge, section cards, next-step row, error card, and pressed
feedback. An explicit debug-only entry point previews these with local fixtures.
Task 4 adds the gauge card, custom-painted arc/ticks/needle, and completion copy.
The gauge animates over 900 ms after an 80 ms delay, transitions color over 400 ms,
and shows its final state immediately when reduced motion is enabled.
The default app entry point remains the shell until screen integration. The road
sheet, booking interaction, loader, Cubit/GetIt wiring, and HTTP integration follow
in their scheduled tasks. The app does not call the backend yet.

See [AGENTS.md](AGENTS.md) for architecture boundaries, API details, acceptance
criteria, references, and the full task sequence. Each task is reviewed before
its commit; work on the next task starts only after the user's instruction.

## Run the current shell

Toolchain used for this milestone: Flutter 3.35.4 stable / Dart 3.9.2.
Use Xcode and an iOS simulator on macOS, or an Android SDK/emulator installation.

```sh
flutter pub get
flutter devices
flutter run -d <simulator-device-id>
```

Select the iPhone 17 Pro Max simulator or the Android emulator explicitly.
Web and desktop are excluded from this project; their untouched starter folders
do not indicate supported targets.

## Preview the components

```sh
flutter run -d <simulator-device-id> -t example/main.dart
flutter run -d <simulator-device-id> -t example/main.dart --dart-define=PREVIEW_SCENARIO=complete
flutter run -d <simulator-device-id> -t example/main.dart --dart-define=PREVIEW_SCENARIO=error
```

Scenarios: `progress` (default), `empty`, `partial`, `special-complete`, `complete`,
`error`, `not-found`. All names/counts in this entry point are frontend fixtures;
it does not contact the backend and cannot run in release/profile mode. Retry in
the preview switches back to the progress fixture. Student selection and the road
sheet are added in their scheduled tasks; their callbacks are tested separately.
There is no scenario-switching panel in the app.

## Backend contract and planned configuration

The existing Spring Boot backend is separate and is not modified by this app.
From its directory, using JDK 25:

```sh
./gradlew bootRun
```

The endpoint is `GET /api/students/{id}/theory-progress` on port **8080**.
It returns `studentId`, `studentName`, `licenseClass`, `basicTopics`,
`specialTopics`, and `completed`. Each topic section has `attended` and `required`.
Unknown students return HTTP 404 with a body such as
`{"message":"Student '999' not found"}`.

| Runtime | Default API base URL (task 7) |
| --- | --- |
| iOS simulator | `http://localhost:8080` |
| Android emulator | `http://10.0.2.2:8080` |

Task 7 will add `--dart-define=API_BASE_URL=...` and
`--dart-define=STUDENT_ID=...` (default `1`), emulator HTTP configuration, and the
student-name tap selector. These defines are not consumed by the shell yet.

## Architecture

- `core`: shared configuration, failures, use-case base, DI, tokens, and strings.
- `data`: Dio data sources, handwritten JSON models, repository implementations.
- `domain`: immutable entities, progress rules, repository interfaces, use cases.
- `presentation`: Cubit states, the screen, and rendering/interaction widgets.

The planned data flow is screen → Cubit → use case → repository → data source.
Repositories return `Either<AppFailure, TheoryProgress>`; Cubit uses `fold`.
GetIt constructs dependencies; classes receive them through constructors.
The domain and shared failure types have no Flutter or Dio dependencies.

Packages: `flutter_bloc`, `equatable`, `dio`, `dartz`, and `get_it`.
German strings use `AppStrings`; there is no localization or code generation.
Fonts are bundled for offline use with their [licence](assets/fonts/OFL.txt).

## Checks

```sh
dart format --output=none --set-exit-if-changed lib example test
flutter analyze
flutter test
```

The tests cover the five progress scenarios, API completion precedence, dynamic
requirements, excess attendance, invalid section counts, use-case success/failure
forwarding, German startup copy even on an English device, section labels, name
taps, error retry, and component layout at 2× text scale. Gauge tests cover German
completion wording and semantic totals, dynamic requirements, reduced motion,
animation lifecycle, and disposal during its initial delay. Data/Cubit and booking
interaction tests follow with their implementations.
Goldens and a dedicated integration suite are deferred. The progress and completed
gauge previews have been checked on iPhone 17 Pro Max; full-screen comparisons
and Android verification are scheduled for task 8.

The final interview handoff in task 9 will expand this README with the completed
architecture diagram, state screenshots/GIFs, verified platform commands,
decisions, trade-offs, and next steps.
