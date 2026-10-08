# Target simulator verification

Task 8 verification used Flutter 3.35.4 / Dart 3.9.2 in debug mode, the existing
backend on port 8080, and the user's approved gauge/section refinements as the
current visual reference. Backend files were not changed.

## Devices and coverage

| Check | iPhone 17 Pro Max, iOS 26.5 | Medium Phone, Android API 36 |
| --- | --- | --- |
| Default API URL | `http://localhost:8080` | `http://10.0.2.2:8080` |
| Progress: 8/12 and 1/2 | Live API, inspected | Live API, inspected |
| Complete: 12/12 and 2/2 | Live API, inspected | Live API, inspected |
| Zero attendance | Live API, inspected | Covered by widget tests |
| Only basic complete | Covered by widget tests | Frontend fixture, inspected in task 8 |
| Unknown student | Live API 404; retry and selector recovery exercised | Live API 404; message and retry button inspected |
| Unreachable API | Unused local port; error and retry exercised | Failure mapping and UI covered by tests |
| Student selector | Live names, selection and recovery exercised | Covered by widget tests |
| Refresh | Timestamp action exercised against API | Covered by widget tests |
| Road sheet and booking toast | Open/close and booking exercised | Covered by widget tests |
| Larger system text | Accessibility Extra Large: progress, selector, sheet and toast | Font scale 2.0: completed screen |

The one-section-complete scenario uses `example/main.dart` with
`PREVIEW_SCENARIO=partial`. It is deliberately a frontend fixture because the
backend's three students do not include that case. Its overall status stays
`In Arbeit`, the basic section shows `Alles besucht`, and the special section
still shows `1 von 2`.

## Accessibility and visual findings

- Headings now have their own semantic nodes instead of merging with surrounding
  copy. The loaded screen preserves separate child nodes for reading order.
- Error heading, explanation, and retry button have separate labels. The error
  explanation is a live region. The existing error widget test checks these
  labels independently.
- Inspected layouts wrap at larger text sizes without Flutter overflow errors.
  Both simulators were returned to their original system text sizes afterward.
- The user's approved typography, spacing, gauge, plain status labels, and
  compact section indicators were retained. This is a manual visual comparison,
  not an automated pixel-diff certification.

## Automated checks

```sh
dart format --output=none --set-exit-if-changed lib example test
flutter analyze
flutter test
```

Task 8 result: clean formatting, zero analyzer issues, and all 34 tests passing.
The existing suite covers the German complete state, partial/zero attendance,
retry, selection, pull-to-refresh, sheet dismissal, repeated booking taps,
reduced motion, animation disposal, API failures, and Cubit timing/stale results.
No new test package or large test suite was added.

## Coverage limits

Native pointer gestures were unavailable through the simulator automation used
for this review. Pull-to-refresh and sheet drag dismissal were exercised by
widget tests; they were not manually swiped on either device. Android review used
actual builds and screenshots with launch configuration changes, rather than
native tapping through the selector, sheet, and toast.

Accessibility labels and reading order were inspected through the iOS
accessibility tree and widget tests; a full VoiceOver/TalkBack listening session
was not performed. Debug startup logs are not a frame-time benchmark; profile
mode performance measurements, golden tests, and a dedicated integration suite
remain future work.
