# Theory Progress — project instructions

## Scope and source precedence

Build Ticket 2 only: a German Flutter home screen showing a Class B student's
theory attendance. The app is for an iPhone 17 Pro Max simulator and an Android
simulator. Web, desktop, login, additional pages, and a topic detail list are out
of scope. Existing generated platform scaffolding is not a support commitment.

Apply the user's latest explicit instructions first. For product conflicts,
Ticket 2 acceptance criteria take precedence over the real backend, which takes
precedence over the handoff README. Use the HTML and screenshots for visual
geometry; acceptance criteria and real data determine status and fill amounts.

Before each task, read this file, the project README, and the handoff README.
Read the relevant visual or asset reference before implementing that component.
Reference locations in the current workspace owner's environment:

- Design: `/Users/oussama/Desktop/design_handoff_theory_progress_2/`
  - `README.md`: exact tokens, copy, states, and motion.
  - `design/Theory Progress App.dc.html`: visual reference source.
  - `screenshots/`: eight 780×1688 reference images with a device frame.
- Engine: `/Users/oussama/Desktop/asset animation engine/assets/engine/`
  - `ENGINE.md`: PNG assembly and motion specification.
  - `engine_loader.dart`: implementation reference to adapt.
  - PNG components with `2.0x/` and `3.0x/` resolution variants.
- Backend: `/Users/oussama/StudioProjects/Backend projects/theory demo backend`.
  Inspect it when needed, but **never modify backend files**.

These external references must not override the user's choices recorded below.
In particular, the handoff's Riverpod, Freezed, JSON generation, routing,
localization, feature-based folders, and missing-student-name assumptions are
superseded. Do not recreate the prototype's developer scenario panel.

## Acceptance criteria

- Progress 8/12 and 1/2 displays `8 von 12` and `1 von 2` with indicators.
- Overall completion displays `Theorie erledigt ✓`.
- If only one section is complete, only that section is marked done; the overall
  status remains open according to the API's `completed` field.
- Show loading while fetching, for at least 800 ms.
- Errors provide a German explanation and `Erneut versuchen`.
- Handle HTTP 404 separately from connection/server failures.
- Zero attendance shows `0 von 12` and `0 von 2`, never an empty-state replacement.
- Support pull-to-refresh and the timestamp refresh action.
- The road bottom sheet stays; it is not navigation to another page.
- Booking shows `Die Prüfungsbuchung ist nicht Teil dieses Prototyps` as a toast.
- The completed state must have a widget test. Run on a target simulator and
  document startup and API configuration before the final handoff.

Counts in these examples are fixtures, not application constants. Read each
requirement from the API. Preserve raw attended counts, clamp visual fill to its
valid range, and prevent negative remaining counts.

## Stack and dependencies

- Flutter, Material 3 with exact custom tokens; Dart 3.
- `flutter_bloc` with **Cubit**, and handwritten immutable states.
- `equatable` for entity, parameter, and state equality.
- `dio` for HTTP; `dartz` for `Either` and `fold`.
- `get_it` for dependency registration; constructor injection inside classes.
- `flutter_test` and `flutter_lints` for a small, focused test/check suite.
- Schibsted Grotesk 400/500/600/700/800 bundled with its SIL OFL licence.
- Supplied engine PNGs animated with Flutter transforms; gauge and dashed borders
  can use CustomPainter. No animation/font/router dependency is needed.

No Freezed, `freezed_annotation`, `json_annotation`, JSON generators,
`build_runner`, injectable generation, ARB, `gen-l10n`, `intl`, or localization
feature. Keep all visible and accessibility copy German through `AppStrings`.
Supply German labels explicitly for framework controls used by this screen.

## Layer-based structure

The following is the target structure; add implementations at their scheduled
task rather than creating empty Dart classes in advance.

```text
lib/
  main.dart
  app.dart
  core/
    config/          app_config.dart, demo_students.dart
    constants/       app_strings.dart, app_assets.dart
    di/              injection_container.dart
    errors/          app_failure.dart
    usecases/        use_case.dart
    network/         dio_client.dart
    theme/           app_colors.dart, app_text.dart, app_motion.dart,
                     app_dimensions.dart, app_theme.dart
  data/
    datasources/     theory_progress_remote_data_source.dart
    models/          theory_progress_model.dart, topic_progress_model.dart
    repositories/    theory_progress_repository_impl.dart
  domain/
    entities/        theory_progress.dart, topic_progress.dart
    repositories/    theory_progress_repository.dart
    usecases/        get_theory_progress_use_case.dart
  presentation/
    cubits/theory_progress/
                     theory_progress_cubit.dart, theory_progress_state.dart
    screens/         theory_progress_screen.dart
    widgets/         demo_student_menu.dart and the progress UI components
assets/
  fonts/
  engine/            PNGs plus 2.0x/ and 3.0x/ variants (task 6)
test/
  domain/
  data/
  presentation/
```

### Dependency boundaries

- Domain owns entities, totals/remaining/section completion/progress-stage rules,
  repository interfaces, and use cases. No Flutter, Dio, data models, German copy,
  colors, or GetIt imports here.
- Put all failure types in `core/errors/app_failure.dart`. Use a common
  `AppFailure` with `StudentNotFoundFailure`, `NetworkFailure`, `ServerFailure`,
  and `InvalidResponseFailure`. This file must be plain Dart without Flutter or
  Dio dependencies; failure types do not hold presentation text.
- The data layer converts Dio and malformed-response exceptions to these
  failures. Models have handwritten `fromJson`, `toJson`, and `toEntity` methods.
  Return domain entities from repository contracts, not data models.
- `core/usecases/use_case.dart` imports dartz, equatable, and
  `../errors/app_failure.dart`. Its `UseCase<Result, Params>` declares
  `Future<Either<AppFailure, Result>> call(Params params)`. Include equatable
  `NoParams` with empty props.
- `GetTheoryProgressUseCase` depends on the repository interface and receives
  `GetTheoryProgressParams(studentId: ...)`, an equatable parameter object.
- Repository and use case return `Either<AppFailure, TheoryProgress>`. Cubit
  awaits the use case and uses `result.fold<void>(left, right)` to emit failure
  or loaded state. Commands that emit state return `Future<void>`.
- Cubit prepares display text using domain values and `AppStrings`. There is
  **no separate mapper layer/class**. Widgets render; they do not decide business
  completion, compute remaining counts, fetch data, or resolve repositories.
- GetIt registrations live in `core/di/injection_container.dart`. Configuration,
  Dio, data source, repository, and use case are shared/lazy instances. Register
  Cubit as a factory; create it via `BlocProvider(create: ...)` at the app boundary
  so BlocProvider owns disposal. Classes receive dependencies through constructors.
- Sheet visibility, toast lifecycle, and animation controllers are local UI state.

## API and state handling

`GET /api/students/{id}/theory-progress` on port **8080**, without authentication:

```json
{
  "studentId": "3",
  "studentName": "Oussama",
  "licenseClass": "B",
  "basicTopics": {"attended": 12, "required": 12},
  "specialTopics": {"attended": 2, "required": 2},
  "completed": true
}
```

- Unknown ID: HTTP 404, e.g. `{"message":"Student '999' not found"}`. Render the
  German not-found copy rather than the raw English backend message.
- Overall status and booking eligibility use **API `completed`**. Section done is
  `attended >= required`. Total required is the sum of API requirements.
- `studentName` is supplied by the backend; never hardcode demo names in the app.
- Configure `API_BASE_URL` and `STUDENT_ID` with `--dart-define`. Default student
  ID is `1`. Platform defaults: Android `http://10.0.2.2:8080`, iOS simulator
  `http://localhost:8080`. Add emulator HTTP platform configuration in task 7.
- Configure a 10-second HTTP timeout. Expected failures become `Left(AppFailure)`;
  success becomes `Right(entity)`. Do not silently swallow failures.
- Cubit states represent loading, loaded(progress, fetchedAt), and failure; retain
  selected student identity across retries and refreshes.
- Minimum loading time runs concurrently with the request, not an extra 800 ms
  after every response. Do not impose the prototype's 2.4-second artificial delay.
- Ignore stale results when selection changes; never emit after Cubit closes.
  Preserve the last known name only for the matching student ID.
- The timestamp is the client's successful fetch time; the API provides no date.

## Demo selection

- A **normal tap on the student name** opens the anchored
  `presentation/widgets/demo_student_menu.dart` popup in demo mode. Show a
  chevron beside the name and list only the other students, with their initials.
  This replaces the former student-selection bottom sheet.
- Keep the Class B badge visual-only. Do not add a long-press requirement.
- Demo configuration stores IDs `1`, `2`, `3` only. Load/cache missing names using
  the existing endpoint when the menu opens. Selection fetches fresh progress.
- Use `Fahrschüler {id}` until a name is available, including failed name lookups.
  A failed selector lookup must not prevent selecting another student.
- Current backend examples: ID 1 Tom (8/12, 1/2), ID 2 Julian (0/12, 0/2),
  ID 3 Oussama (12/12, 2/2). These names are documentation, not frontend constants.
- Only-one-section-complete has no current backend seed: verify using frontend
  fixtures. Do not modify the backend or present fixtures as live API data.
- Document how to enable the demo selector and how to configure the initial ID.

## Visual quality and assets

The user's approved task-4 UI refinements take precedence over the original gauge
and section screenshots: headline/subline above the gauge, plain colored status
text, lighter gauge shadow, compact section typography and segments, neutral
section borders, and a check icon with `Alles besucht`. Preserve these refinements
when integrating later tasks. Other components still follow the handoff.

- Match design colors, type, spacing, radii, shadow, and motion. Store them in
  `AppColors`, `AppText`, `AppDimensions`, `AppMotion`, and `AppTheme`. No literal
  colors, text styles, durations, or product strings inside widgets.
- Use centralized German strings and singular/plural formatting. Keep progress
  decision rules in domain, not in the string catalogue or widgets.
- Respect SafeArea, allow scrolling and text scaling, preserve accessible button
  semantics/tap targets. Concentrate on the two requested simulators, not a broad
  responsive layout system. Do not recreate the reference device frame/status bar.
- Gauge: 900 ms, `Cubic(.2, .8, .2, 1)`, 80 ms initial delay; color transitions 400 ms.
- Loading fade 300 ms; data fade 350 ms; sheet slide 320 ms; scrim fade 250 ms.
- Engine: use the supplied PNGs in a 240×210 assembly, inside the 228-high gradient
  panel. Preserve ±34° cylinders, 56 px piston travel, alternating half-cycle
  phases, sparks and pulley over a 1.2-second loop. Adapt the reference widget to
  our tokens, paths, German semantics, and lifecycle rather than copying blindly.
- RPM loop 2.4 s; spinner 900 ms; skeleton pulse 1.4 s. These animations stop when
  the loading widget is removed. Reuse static children where practical.
- Sheet dismisses through scrim, swipe, or close button. Booking toast fades/rises
  over 250 ms, stays for 2.2 s, and restarts on another tap without stacking.
- Honor reduced-motion preferences when adding animation controllers.
- Some screenshots captured stale gauge/segment colors. Use reference geometry
  with correct live-data fills: incomplete overall is blue, completed overall
  is green, and each completed section is independently green.
- Preserve the supplied palette; document contrast trade-offs in the final README.

## Tests and verification

Keep tests basic and meaningful: a compact domain scenario table, use-case
forwarding, JSON/failure mapping, Cubit success/retry/timing/stale-result behavior,
German progress text, completed-state booking toast, and error retry. Use small
fakes; avoid adding mocking/codegen packages or testing implementation details.

Golden tests and a dedicated integration suite are deferred. Manually compare
screenshots on iPhone 17 Pro Max and the available Android simulator, exercising
selection, refresh, sheet, toast, errors, and a larger text scale before handoff.
Never claim a check/device run that did not actually complete.

After every task:

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Formatting must be clean, analysis must have **zero issues**, and tests must pass.
Run formatter normally first if needed. Add target-device runs when relevant.
No build_runner or gen-l10n command: the user approved removing generation.

## Task sequence and approval workflow

Implement **one task at a time** in this order:

1. Foundation: this full AGENTS.md, Git initialization, layers, dependencies,
   tokens/theme, bundled fonts, German strings, app shell, basic startup test.
2. Shared failures and use-case base, domain entities/repository/use case, tests.
3. Static header/badge/section/next-step/error widgets using fixtures.
4. Gauge painter/animation and completed-state widget test.
5. Road bottom sheet and booking toast/interaction test.
6. Supplied engine assets and loader/RPM/checklist/skeleton animations.
7. API models/data source/repository, Cubit, GetIt wiring, configuration,
   refresh/errors, name-tap student selector, focused tests.
8. Target simulator visual polish and remaining basic checks.
9. CTO README with architecture diagram, backend/app commands, per-platform URLs,
   state screenshots/GIFs, decisions/trade-offs, test commands, and future work.

After completing a task, run its checks and present a short, reviewable summary
with the proposed conventional commit message. **Do not commit before the user
explicitly approves that task's commit.** This is the user's latest instruction
and applies to every step, including task 1. An approval to implement a task is
not permission to commit it. After an approved commit, wait for `next` before
starting the next task unless the user explicitly authorizes both actions.

Use small conventional messages (`feat:`, `fix:`, `test:`, `chore:`, `docs:`),
one coherent task per commit. No push, PR, or remote is configured by this plan.
Preserve unrelated user changes. Never modify global Git identity or the Flutter
SDK to make a task pass; explain a real toolchain blocker if one arises.
