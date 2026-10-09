/// German product copy. Formatting stays here; progress rules stay in domain.
abstract final class AppStrings {
  static const appTitle = 'Theorie-Fortschritt';
  static const greeting = 'Guten Morgen,';
  static const switchStudent = 'Fahrschüler wechseln';
  static const dismissStudentMenu = 'Fahrschülerauswahl schließen';
  static const loadingStudentNames = 'Namen werden geladen…';
  static const loaderLabel = 'Motorstart';
  static const loaderEngine = 'V6';
  static const loaderTitle = 'Motor startet…';
  static const loaderRpm = 'U/MIN';
  static const loaderStep1 = 'Zündung an';
  static const loaderStep2 = 'Kraftstoffpumpe bereit';
  static const loaderStep3 = 'Theorie-Fortschritt wird geladen';
  static const errorTitle = 'Fortschritt nicht verfügbar';
  static const errorNetwork =
      'Der Server ist nicht erreichbar. Prüfe deine Verbindung und versuche es erneut.';
  static const errorNotFound = 'Dieser Fahrschüler wurde nicht gefunden.';
  static const errorServer =
      'Der Fortschritt konnte nicht geladen werden. Versuche es erneut.';
  static const retry = 'Erneut versuchen';
  static const heroLabel = 'Theorie-Fortschritt';
  static const pillNotStarted = 'Nicht begonnen';
  static const pillInProgress = 'In Arbeit';
  static const pillComplete = 'Erledigt';
  static const headlineDone = 'Theorie erledigt ✓';
  static const gaugeCompleteNextStep =
      'Du kannst jetzt deine Theorieprüfung buchen.';
  static const headlineEmpty = "Los geht's";
  static const subEmpty =
      'Besuche deinen ersten Theorieunterricht, um die Anzeige zu füllen.';
  static const subBasicDone =
      'Der Grundstoff ist erledigt. Nur noch ein Schritt bis zur fertigen Theorie.';
  static const subSpecialDone =
      'Der Spezialstoff ist erledigt. Schließe den Grundstoff ab, um die Theorie fertigzustellen.';
  static const bookExam = 'Theorieprüfung buchen →';
  static const bookToast =
      'Die Prüfungsbuchung ist nicht Teil dieses Prototyps';
  static const sectionBasic = 'Grundstoff';
  static const sectionSpecial = 'Spezialstoff';
  static const attended = 'besucht';
  static const attendedSuffix = ' besucht';
  static const errorMark = '!';
  static const nextStepNumber = '2';
  static const nextStepArrow = '→';
  static const chevron = '›';
  static const pillDone = 'Alles besucht';
  static const sectionProgress = 'Dein Fortschritt';
  static const sectionOpen = 'Details anzeigen';
  static const sectionRemainingQuestion = 'Was fehlt mir noch?';
  static const sectionTimetableQuestion =
      'Wo finde ich den nächsten Unterricht?';
  static const sectionCompletionQuestion = 'Wann ist meine Theorie erledigt?';
  static const sectionTimetableAnswer =
      'Prüfe den Unterrichtsplan deiner Fahrschule. Dort findest du Themen und Termine für deinen nächsten Unterricht.';
  static const sectionTheoryDoneAnswer =
      'Deine Theorie ist erledigt. Als Nächstes folgt die Theorieprüfung.';
  static const sectionAwaitingCompletion =
      'Beide Abschnitte sind vollständig besucht. Dein Gesamtabschluss ist noch nicht bestätigt.';
  static String sectionOtherAction(String title) => '$title ansehen →';
  static String sectionFinished(String title) => '$title ist abgeschlossen.';
  static String sectionOtherRemaining(String title, int remaining) =>
      'Im $title ${remaining == 1 ? 'fehlt' : 'fehlen'} noch $remaining '
      '${remaining == 1 ? 'Unterricht' : 'Unterrichte'}.';
  static String sectionRemainingAnswer(
    int attended,
    int required,
    int remaining,
  ) =>
      'Du hast $attended von $required Unterrichten besucht. Noch $remaining '
      '${remaining == 1 ? 'Unterricht fehlt' : 'Unterrichte fehlen'} in diesem Abschnitt.';
  static String sectionCompletionAnswer(
    int basicRemaining,
    int specialRemaining,
  ) =>
      'Für die fertige Theorie musst du beide Abschnitte abschließen. '
      'Noch $basicRemaining ${basicRemaining == 1 ? 'Grundstoffunterricht' : 'Grundstoffunterrichte'} '
      'und $specialRemaining ${specialRemaining == 1 ? 'Spezialstoffunterricht' : 'Spezialstoffunterrichte'} offen.';
  static const nextTitle = 'Als Nächstes: Theorieprüfung';
  static const nextLocked =
      'Wird freigeschaltet, sobald die Theorie erledigt ist';
  static const nextReady = 'Bereit zur Buchung';
  static const justNow = 'gerade eben';
  static const refresh = 'Fortschritt aktualisieren';
  static const roadTitle = 'Dein Weg zum Führerschein';
  static const close = 'Schließen';
  static const dismissSheet = 'Ansicht schließen';
  static const roadCurrent = 'Aktueller Schritt';
  static const roadLocked = 'Noch gesperrt';
  static const checkMark = '✓';
  static String roadStepSemantics(
    int number,
    String title,
    String meta,
    String status,
  ) => meta == status
      ? 'Schritt $number: $title. $status'
      : 'Schritt $number: $title. $meta. $status';
  static const step1Title = 'Theorieunterricht';
  static const step1Done = 'Abgeschlossen';
  static const step2Title = 'Theorieprüfung';
  static const step3Title = 'Fahrstunden';
  static const step3Meta = 'Inklusive Sonderfahrten';
  static const step4Title = 'Praktische Prüfung';
  static const step4Meta = 'Letzter Schritt zum Führerschein';

  static String studentFallback(String id) => 'Fahrschüler $id';
  static String classBadge(String licenseClass) => 'Klasse $licenseClass';
  static String studentGreeting(String name) => '$greeting $name';
  static String sectionSemantics(String title, String count, String status) =>
      '$title: $count $attended. $status';
  static String totalSuffix(int count) =>
      '/ $count ${count == 1 ? 'Unterricht' : 'Unterrichte'}';
  static String gaugeSemantics(int attended, int required, String status) =>
      '$heroLabel: $attended von $required Unterrichten besucht. $status';
  static String subDone(int count) => count == 1
      ? 'Der erforderliche Unterricht wurde besucht. Gut gemacht!'
      : 'Alle $count Unterrichte besucht. Gut gemacht!';
  static String headlineSpecialLeft(int count) =>
      'Noch $count ${count == 1 ? 'Spezialstoffthema' : 'Spezialstoffthemen'}';
  static String headlineBasicLeft(int count) =>
      'Noch $count ${count == 1 ? 'Grundstoffthema' : 'Grundstoffthemen'}';
  static String headlineLessonsLeft(int count) =>
      'Noch $count ${count == 1 ? 'Unterricht' : 'Unterrichte'}';
  static String subBothLeft(int basic, int special) =>
      'Noch $basic Grundstoff- und $special '
      '${special == 1 ? 'Spezialstoffthema' : 'Spezialstoffthemen'} offen.';
  static String attendedOf(int attended, int required) =>
      '$attended von $required';
  static String pillLeft(int count) => 'Noch $count';
  static String updated(String relativeTime) =>
      'Aktualisiert $relativeTime · Tippen zum Aktualisieren';
  static String minutesAgo(int count) => 'vor $count Min.';
  static String step1Meta(int attended, int required) =>
      '$attended von $required besucht';
}
