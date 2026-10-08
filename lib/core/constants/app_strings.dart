/// German product copy. Formatting stays here; progress rules stay in domain.
abstract final class AppStrings {
  static const appTitle = 'Theorie-Fortschritt';
  static const greeting = 'Guten Morgen,';
  static const selectStudent = 'Fahrschüler auswählen';
  static const switchStudent = 'Fahrschüler wechseln';
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
  static const pillDone = 'Fertig ✓';
  static const nextTitle = 'Als Nächstes: Theorieprüfung';
  static const nextLocked =
      'Wird freigeschaltet, sobald die Theorie erledigt ist';
  static const nextReady = 'Bereit zur Buchung';
  static const justNow = 'gerade eben';
  static const refresh = 'Fortschritt aktualisieren';
  static const roadTitle = 'Dein Weg zum Führerschein';
  static const close = 'Schließen';
  static const dismissSheet = 'Ansicht schließen';
  static const step1Title = 'Theorieunterricht';
  static const step1Done = 'Abgeschlossen';
  static const step2Title = 'Theorieprüfung';
  static const step3Title = 'Fahrstunden';
  static const step3Meta = 'Inklusive Sonderfahrten';
  static const step4Title = 'Praktische Prüfung';
  static const step4Meta = 'Letzter Schritt zum Führerschein';

  static String studentFallback(String id) => 'Fahrschüler $id';
  static String classBadge(String licenseClass) => 'Klasse $licenseClass';
  static String totalSuffix(int count) =>
      '/ $count ${count == 1 ? 'Unterricht' : 'Unterrichte'}';
  static String subDone(int count) => count == 1
      ? 'Der erforderliche Unterricht wurde besucht. Du kannst jetzt deine Theorieprüfung buchen.'
      : 'Alle $count Unterrichte besucht. Du kannst jetzt deine Theorieprüfung buchen.';
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
