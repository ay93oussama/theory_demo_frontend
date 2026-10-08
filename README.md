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
Task 5 adds the road sheet and completed-state booking button. The sheet slides
in over 320 ms with a 250 ms scrim fade and supports close, scrim, swipe, and system
back dismissal. Booking shows one German toast for 2.2 seconds with a 250 ms
fade/rise; another tap restarts its lifetime. Both honor reduced motion.
Task 6 adds the supplied engine PNG assembly, alternating pistons, sparks and
rotating pulley (1.2 s), RPM bar (2.4 s), checklist spinner (900 ms), skeleton
pulse (1.4 s), and loading fade (300 ms). Reduced motion shows a static loading
view. Controllers stop when the view is removed; the image children are reused.
Task 7 connects the default entry point to the real API using Dio, handwritten
models, a repository/use case, Cubit, and GetIt. Loading lasts at least 800 ms,
concurrently with the request. Tap the student name to switch demo students;
pull down or tap the update timestamp to refresh. A 404 has separate German copy.
Requests for an older selection cannot overwrite the current student.
Task 8 verifies the app on both target simulators and improves screen-reader
grouping: headings, explanatory copy, and retry remain separate, and errors use
a live region. The approved visual layout is preserved.

See [AGENTS.md](AGENTS.md) for architecture boundaries, API details, acceptance
criteria, references, and the full task sequence. Each task is reviewed before
its commit; work on the next task starts only after the user's instruction.

## Run the app

Toolchain used for this milestone: Flutter 3.35.4 stable / Dart 3.9.2.
Use Xcode and an iOS simulator on macOS, or an Android SDK/emulator installation.

```sh
flutter pub get
flutter devices
flutter run -d <simulator-device-id> --dart-define=DEMO_MODE=true
```

Select the iPhone 17 Pro Max simulator or the Android emulator explicitly.
Web and desktop are excluded from this project; their untouched starter folders
do not indicate supported targets.

## Preview the components

```sh
flutter run -d <simulator-device-id> -t example/main.dart
flutter run -d <simulator-device-id> -t example/main.dart --dart-define=PREVIEW_SCENARIO=complete
flutter run -d <simulator-device-id> -t example/main.dart --dart-define=PREVIEW_SCENARIO=error
flutter run -d <simulator-device-id> -t example/main.dart --dart-define=PREVIEW_SCENARIO=loading
```

Scenarios: `progress` (default), `empty`, `partial`, `special-complete`, `complete`,
`error`, `not-found`, `loading`. The loading preview stays visible for inspection.
All names/counts in this entry point are frontend fixtures;
it does not contact the backend and cannot run in release/profile mode. Retry in
the preview switches back to the progress fixture. Tap the next-step row to open
the road sheet, including before completion. The complete fixture also provides
the booking button and toast. Use the default entry point for live student selection.
There is no scenario-switching panel in the app.

## Backend contract and configuration

The existing Spring Boot backend is separate and is not modified by this app.
From `/Users/oussama/StudioProjects/Backend projects/theory demo backend`, using JDK 25:

```sh
./gradlew bootRun
```

The endpoint is `GET /api/students/{id}/theory-progress` on port **8080**.
It returns `studentId`, `studentName`, `licenseClass`, `basicTopics`,
`specialTopics`, and `completed`. Each topic section has `attended` and `required`.
Unknown students return HTTP 404 with a body such as
`{"message":"Student '999' not found"}`.

| Runtime | Default API base URL |
| --- | --- |
| iOS simulator | `http://localhost:8080` |
| Android emulator | `http://10.0.2.2:8080` |

Configure the URL and initial student at build time:

```sh
flutter run -d <ios-simulator-id> --dart-define=API_BASE_URL=http://localhost:8080 --dart-define=STUDENT_ID=3
flutter run -d <android-emulator-id> --dart-define=API_BASE_URL=http://10.0.2.2:8080 --dart-define=STUDENT_ID=1
```

`STUDENT_ID` defaults to `1`. `DEMO_MODE` defaults to true in debug builds and false
in profile/release; override it with `--dart-define=DEMO_MODE=true` or `false`.
In demo mode, tap the name to choose IDs 1 (Tom, in progress), 2 (Julian, no
attendance), or 3 (Oussama, complete). Names come from the API and are cached;
failed name lookups keep a selectable `Fahrschüler {id}` fallback. The badge has
no action. Selection always fetches fresh progress and resets on app restart.

HTTP exceptions are limited to emulator/loopback hosts on Android and local
networking on iOS. For a custom remote API URL, use HTTPS. Connection, send, and
receive timeouts are 10 seconds. Use `STUDENT_ID=999` to demonstrate the real 404,
or `API_BASE_URL=http://localhost:8081` on iOS to demonstrate an unreachable API
when that port is unused. Restart the app after changing dart-defines.

The timestamp records the client's successful response time. It updates every
minute and on app resume. Pull-to-refresh and retry keep the selected student;
loading removes the previous student's progress while keeping a matching cached
name. Overall completion always follows API `completed`; section completion uses
the API attendance and requirement counts.

## Architecture

- `core`: shared configuration, failures, use-case base, DI, tokens, and strings.
- `data`: Dio data sources, handwritten JSON models, repository implementations.
- `domain`: immutable entities, progress rules, repository interfaces, use cases.
- `presentation`: Cubit states, the screen, and rendering/interaction widgets.

The data flow is screen → Cubit → use case → repository → data source.
Repositories return `Either<AppFailure, TheoryProgress>`; Cubit uses `fold`.
GetIt constructs dependencies; classes receive them through constructors.
The domain and shared failure types have no Flutter or Dio dependencies.

Packages: `flutter_bloc`, `equatable`, `dio`, `dartz`, and `get_it`.
German strings use `AppStrings`; there is no localization or code generation.
Fonts are bundled for offline use with their [licence](assets/fonts/OFL.txt).
The engine uses the six supplied PNG parts in `assets/engine/`, with their 2× and
3× variants; it needs no animation package or network access.

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
animation lifecycle, and disposal during its initial delay. Interaction tests cover
sheet statuses/dismissal, booking copy, repeated taps without stacking, toast
expiry/disposal, and large text with reduced motion. Two loading tests cover German
copy/semantics, animation disposal, changing reduced-motion preferences, and 2×
text. Data tests check JSON round-tripping, the request contract, 404/server/network
failure conversion, and malformed data. Cubit tests cover the 800 ms minimum,
slow responses, retry, cached names, timestamps, stale selection results, and
closure. Screen tests exercise German progress/completion/zero states, selector,
booking, retry, timestamp refresh, and pull-to-refresh using a fake repository.
Goldens and a dedicated integration suite are deferred. Both target simulators
run against the real backend. See [the verification record](docs/verification.md)
for the states, accessibility checks, and limits of the manual device coverage.

The final interview handoff in task 9 will expand this README with the completed
architecture diagram, state screenshots/GIFs, verified platform commands,
decisions, trade-offs, and next steps.
