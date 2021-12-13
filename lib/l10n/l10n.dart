import "package:intl/intl.dart";

// ----- general -----
List<String> exams() => Intl.message(
      "Test,Schularbeit,Prüfung",
      name: "exams",
      desc: "A comma-separated list of lesson contents that represent exams.\n"
          "This is used to mark exams differently in the calendar view and the homework page",
    ).split(
      ",",
    );
String grade() => Intl.message(
      "Bewertung",
      name: "grade",
      desc:
          "The title used by digitalesregister.it for grades in the homework view",
    );
String homework() => Intl.message(
      "Hausaufgabe",
      name: "homework",
      desc:
          "The title used by digitalesregister.it for homework in the homework view",
    );
String observation() => Intl.message(
      "Beobachtung",
      name: "observation",
      desc:
          "The title used by digitalesregister.it for observations in the homework view",
    );

// ----- absences -----

String noAbsencesYet() => Intl.message(
      "Noch keine Absenzen",
      name: "noAbsencesYet",
      desc: "Displayed if there are no absences",
    );
String absencesStatistic() => Intl.message(
      "Statistik",
      name: "absencesStatistic",
      desc: "Title for statistics for absences",
    );
String absencesForSchool() => Intl.message(
      "Absenzen im Auftrag der Schule",
      name: "absencesForSchool",
      desc: "Subtitle for absences justified by the school",
    );
String absencesDelays() => Intl.message(
      "Verspätungen",
      name: "absencesDelays",
      desc: "Subtitle for absences where the student arrived too late",
    );
String absencesJustified() => Intl.message(
      "Entschuldigte Absenzen",
      name: "absencesJustified",
      desc: "Subtitle for absences that were justified",
    );
String absencesNotJustified() => Intl.message(
      "Nicht entschuldigte Absenzen",
      name: "absencesNotJustified",
      desc: "Subtitle for absences that are not justified",
    );
String absencesPercentageTitle() => Intl.message(
      "Abwesenheit",
      name: "absencesPercentageTitle",
      desc: "Subtitle for the percentage of absences",
    );
String absenceDuration(
  String fromDate,
  int fromHour,
  String toDate,
  int toHour,
) =>
    Intl.message(
      "$fromDate $fromHour. Stunde – $toDate $toHour Stunde",
      name: "absenceDuration",
      args: [
        fromDate,
        fromHour,
        toDate,
        toHour,
      ],
      desc: "The dates will be formatted using DateFormat.Md() (e.g. 13.12.)",
    );
String absenceJustifiedBy(
  String date,
  String time,
  String justifyingUser,
) =>
    Intl.message("Am $date umd $time von $justifyingUser entschuldigt",
        name: "absenceJustifiedBy",
        args: [
          date,
          time,
          justifyingUser,
        ],
        desc: "Date will be formatted using DateFormat.");
String absenceJustified() => Intl.message(
      "entschuldigt",
      name: "absenceJustified",
    );
String absenceJustifiedBySchool() => Intl.message(
      "Im Auftrag der Schule (entschuldigt)",
      name: "absenceJustifiedBySchool",
    );
String absenceNotJustified() => Intl.message(
      "Nicht entschuldigt",
      name: "absenceNotJustified",
    );
String absenceNotYetJustified() => Intl.message(
      "Noch nicht entschuldigt",
      name: "absenceNotYetJustified",
    );
// ----- calendar -----
String lessonIndex(int hour) => Intl.message(
      "$hour. Stunde",
      name: "lessonIndex",
      args: [hour],
    );
String lessonSpan(int from, int to) => Intl.message(
      "$from. – $to. Stunde",
      name: "lessonSpan",
      args: [from, to],
    );
String teachers(int howMany) => Intl.plural(
      howMany,
      name: "teachers",
      args: [howMany],
      one: "Lehrer*in",
      other: "Lehrer*innen",
    );
String rooms(int howMany) => Intl.plural(
      howMany,
      name: "rooms",
      args: [howMany],
      other: "Räume",
      one: "Raum",
      desc: "The rooms that are booked for this lesson",
    );
String detailView() => Intl.message(
      "Detailansicht",
      name: "detailView",
      desc: "Displayed as the title of the calendar detail view in edge cases",
    );
String noSchool() => Intl.message(
      "Keine Schule",
      name: "noSchool",
      desc: "Displayed in the calendar detail view for weekends",
    );
String noSchoolShort() => Intl.message(
      "Frei",
      name: "noSchoolShort",
      desc: "Displayed in the calendar master view for holidays",
    );
String currentWeek() => Intl.message(
      "Aktuelle Woche",
      name: "currentWeek",
      desc: "Label of the button to jump to the current week",
    );
String chooseADate() => Intl.message(
      "Wähle ein Datum",
      name: "chooseADate",
      desc: "The user can tap this button to select a date",
    );
String editNicks() => Intl.message(
      "Kürzel bearbeiten",
      name: "editNicks",
      desc: "The user can tap this button to edit subject nicks",
    );

// ----- settings -----
String changeEmail() => Intl.message(
      "Email-Adresse ändern",
      name: "changeEmail",
    );
String currentPassword() => Intl.message(
      "Aktuelles Passwort",
      name: "currentPassword",
    );
String newEmail() => Intl.message(
      "Neue Email-Adresse",
      name: "newEmail",
      desc: "The new email address",
    );
String save() => Intl.message(
      "Speichern",
      name: "save",
      desc: "Save changed settings",
    );
String profile() => Intl.message(
      "Profil",
      name: "profile",
    );
String sendEmailsForNotifications() => Intl.message(
      "Emails für Benachrichtigungen senden",
      name: "sendEmailsForNotifications",
      desc: "Whether to send emails for notifications",
    );
String changePassword() => Intl.message(
      "Passwort ändern",
      name: "changePassword",
    );
String loginSettings() => Intl.message(
      "Anmeldung",
      name: "loginSettings",
      desc: "Header for login-related settings",
    );
String stayLoggedIn() => Intl.message(
      "Angemeldet bleiben",
      name: "stayLoggedIn",
      desc: "Whether the user wants to stay logged in",
    );
String stayLoggedInDesc() => Intl.message(
      "Deine Zugangsdaten werden lokal gespeichert",
      name: "stayLoggedInDesc",
      desc:
          "Tell the user that their credentials will be saved locally if they choose to stay logged in",
    );
String saveData() => Intl.message(
      "Daten lokal speichern",
      name: "saveData",
      desc: "Whether the user wants to save data locally",
    );
String saveDataDesc() => Intl.message(
      "Sehen, wann etwas eingetragen wurde",
      name: "saveDataDesc",
      desc:
          "Tell the user that they'll see when new homework was added if they choose to enable saving data",
    );
String deleteDataOnLogout() => Intl.message(
      "Daten beim Ausloggen löschen",
      name: "deleteDataOnLogout",
      desc:
          "Whether the user wants to have their data deleted when they log out",
    );
String appearance() => Intl.message(
      "Aussehen",
      name: "appearance",
      desc: "Header for ui-related settings",
    );
String followDeviceTheme() => Intl.message(
      "Geräte-Theme folgen",
      name: "followDeviceTheme",
    );
String lightMode() => Intl.message(
      "Hell",
      name: "lightMode",
    );
String darkMode() => Intl.message(
      "Dunkel",
      name: "darkMode",
    );
String subjectColors() => Intl.message(
      "Fächerfarben",
      name: "subjectColors",
      desc:
          "Dropdown that allows user to choose a color for a specific subject",
    );
String colorHomework() => Intl.message(
      "Hausaufgaben mit diesen Farben umrahmen",
      name: "colorHomework",
      desc: "Whether to draw the border around homework in these colors",
    );
String testsAlwaysRed() => Intl.message(
      "Tests immer rot umrahmen",
      name: "testsAlwaysRed",
      desc:
          "Whether to draw the border around tests in red, even if colorHomework is enabled",
    );
String dashboardSettings() => Intl.message(
      "Merkheft",
      name: "dashboardSettings",
      desc: "Header for settings related to the homework view",
    );
String highlightNewOrChangedEntries() => Intl.message(
      "Neue oder geänderte Einträge markieren",
      name: "highlightNewOrChangedEntries",
      desc:
          "Whether to highlight new, changed or deleted entries in the homework view",
    );
String ignoreDuplicateEntries() => Intl.message(
      "Doppelte Einträge ignorieren",
      name: "ignoreDuplicateEntries",
      desc: "Whether to ignore duplicated entries in the homework view",
    );
String askWhenDeletingReminders() => Intl.message(
      "Beim Löschen von Erinnerungen fragen",
      name: "askWhenDeletingReminders",
      desc: "Whether to show a confirmation dialog when deleting reminders",
    );
String gradesSettings() => Intl.message(
      "Noten",
      name: "gradesSettings",
      desc: "Header for settings related to grades",
    );
String showGradesChart() => Intl.message(
      "Noten in einem Diagramm darstellen",
      name: "showGradesChart",
    );
String showSubjectsAverage() => Intl.message(
      "Durchschnitt aller Fächer anzeigen",
      name: "showSubjectsAverage",
      desc: "Whether to show the average of all averages of all subjects",
    );
String excludeSubjectsFromAverage() => Intl.message(
      "Fächer aus dem Notendurchschnitt ausschließen",
      name: "excludeSubjectsFromAverage",
      desc: "Subjects not to consider for the average",
    );
String noSubjectExcluded() => Intl.message(
      "Kein Fach ausgeschlossen",
      name: "noSubjectExcluded",
    );
String calendarSettings() => Intl.message(
      "Kalender",
      name: "calendarSettings",
      desc: "Header for settings related to the calendar view",
    );
String subjectNicks() => Intl.message(
      "Fächerkürzel",
      name: "subjectNicks",
      desc: "Dropdown to edit subject nicks",
    );
String showEditNicksBar() => Intl.message(
      "Hinweis zum Bearbeiten von Kürzeln",
      name: "showEditNicksBar",
      desc:
          "Whether to show a hint to allow the user to edit subject nicks if some are missing",
    );
String showEditNicksBarDesc() => Intl.message(
      "Wird angezeigt, wenn für ein Fach kein Kürzel vorhanden ist",
      name: "showEditNicksBarDesc",
      desc: "Tell the user that the hint is shown if nicks are missing",
    );
String advancedSettings() => Intl.message(
      "Erweitert",
      name: "advancedSettings",
      desc: "Header for advanced settings",
    );
String iosMode() => Intl.message(
      "iOS-Mode",
      name: "iosMode",
    );
String iosModeDesc() => Intl.message(
      "Imitiere das Aussehen einer iOS-App (ein bisschen)",
      name: "iosModeDesc",
      desc: "iOS mode imitates the look and feel of an ios app (a bit)",
    );
String networkProtocol() => Intl.message(
      "Netzwerkprotokoll",
      name: "networkProtocol",
    );
String nothingThere() => Intl.message(
      "Nichts vorhanden",
      name: "nothingThere",
    );
String params() => Intl.message(
      "Parameter",
      name: "params",
    );
String response() => Intl.message(
      "Antwort",
      name: "response",
    );
String copiedToClipboard() => Intl.message(
      "In die Zwischenablage kopiert",
      name: "copiedToClipboard",
    );
String supportUs() => Intl.message(
      "Unterstütze uns jetzt!",
      name: "supportUs",
    );
String giveFeedback() => Intl.message(
      "Feedback geben",
      name: "giveFeedback",
    );
String openSourceCode() => Intl.message(
      "Zum Quellcode",
      name: "openSourceCode",
      desc: "Opens a link to github",
    );
String about() => Intl.message(
      "Über diese App",
      name: "about",
      desc: "Opens the about dialog",
    );
String registerClient() => Intl.message(
      "Digitales Register (Client)",
      name: "registerClient",
      desc:
          "App name shown in the about dialog, clarifying that this information is about the client",
    );
String aboutDesc() => Intl.message(
      """
Ein Client für das Digitale Register.
Großes Dankeschön an das Vinzentinum für die freundliche Unterstützung.""",
      name: "aboutDesc",
      desc:
          "Say that this is a client for the digital register. Thank my school for supporting this project",
    );
String addNick() => Intl.message(
      "Kürzel hinzufügen",
      name: "addNick",
      desc: "Add a subject nick",
    );
String editNick() => Intl.message(
      "Kürzel hinzufügen",
      name: "editNick",
      desc: "Edit a subject nick",
    );
String subject() => Intl.message(
      "Fach",
      name: "subject",
    );
String nick() => Intl.message(
      "Kürzel",
      name: "nick",
    );
String cancel() => Intl.message(
      "Abbrechen",
      name: "cancel",
    );
String addSubject() => Intl.message(
      "Fach hinzufügen",
      name: "addSubject",
    );
String chooseColor() => Intl.message(
      "Farbe auswählen",
      name: "chooseColor",
    );
String select() => Intl.message(
      "Auswählen",
      name: "select",
    );

// ----- dashboard -----
String noEntries() => Intl.message(
      "Keine Einträge vorhanden",
      name: "noEntries",
    );
String newEntries() => Intl.message(
      "Neue Einträge",
      name: "newEntries",
    );
String register() => Intl.message(
      "Register",
      name: "register",
      desc: "The app name",
    );
String past() => Intl.message(
      "Vergangenheit",
      name: "past",
      desc: "Button that allows to view past homework",
    );
String future() => Intl.message(
      "Zukunft",
      name: "future",
      desc: "Button that allows to view future homework",
    );
String reminder() => Intl.message(
      "Erinnerung",
      name: "reminder",
    );
String deletedEntries() => Intl.message(
      "Gelöschte Einträge",
      name: "deletedEntries",
    );
String neverAsk() => Intl.message(
      "Nie fragen",
      name: "neverAsk",
      desc: "Toggle to disable the confirmation dialog when deleting reminders",
    );
String deleteReminderQ() => Intl.message(
      "Erinnerung löschen?",
      name: "deleteReminderQ",
    );
String delete() => Intl.message(
      "Löschen",
      name: "delete",
    );
String versions() => Intl.message(
      "Versionen",
      name: "versions",
    );
String current() => Intl.message(
      "aktuell",
      name: "current",
    );
String isNew() => Intl.message(
      "neu",
      name: "isNew",
    );
String added() => Intl.message(
      "eingetragen",
      name: "added",
    );
String deleted() => Intl.message(
      "gelöscht",
      name: "deleted",
    );
String changed() => Intl.message(
      "geändert",
      name: "changed",
    );
String reAdded() => Intl.message(
      "wiederhergestellt",
      name: "reAdded",
    );
String beforeDateTime(
  String date,
  String time,
  String action,
) =>
    Intl.message(
      "Vor $date um $time $action.",
      name: "beforeDateTime",
      args: [
        date,
        time,
        action,
      ],
      desc: "action is either added, deleted, changed or reAdded.",
    );
String onDateBetweenTimes(
  String date,
  String timeFrom,
  String timeTo,
  String action,
) =>
    Intl.message(
      "Am $date zwischen $timeFrom und $timeTo $action.",
      name: "onDateBetweenTimes",
      args: [
        date,
        timeFrom,
        timeTo,
        action,
      ],
      desc: "action is either added, deleted, changed or reAdded.",
    );
String betweenDateTimes(
  String dateFrom,
  String timeFrom,
  String dateTo,
  String timeTo,
  String action,
) =>
    Intl.message(
      "Zwischen $dateFrom um $timeFrom und $dateTo um $timeTo $action.",
      name: "betweenDateTimes",
      args: [
        dateFrom,
        timeFrom,
        dateTo,
        timeTo,
        action,
      ],
      desc: "action is either added, deleted, changed or reAdded.",
    );
String attachments(int howMany) => Intl.plural(
      howMany,
      args: [howMany],
      one: "Anhang",
      other: "Anhänge",
      name: "attachments",
    );
String download() => Intl.message(
      "Herunterladen",
      name: "download",
    );
String downloadAgain() => Intl.message(
      "Erneut herunterladen",
      name: "downloadAgain",
    );
String openFile() => Intl.message(
      "Öffnen",
      name: "openFile",
    );
String gradesAndTests() => Intl.message(
      "Noten & Tests",
      name: "gradesAndTests",
    );
String homeworkAndReminders() => Intl.message(
      "Hausaufgaben & Erinnerungen",
      name: "homeworkAndReminders",
    );
String observations() => Intl.message(
      "Beobachtungen",
      name: "observations",
    );
String today() => Intl.message(
      "Heute",
      name: "today",
    );
String tomorrow() => Intl.message(
      "Morgen",
      name: "tomorrow",
    );
String yesterday() => Intl.message(
      "Gestern",
      name: "yesterday",
    );

// ----- navigation -----
String logoutTitle() => Intl.message(
      "Abmelden",
      name: "logoutTitle",
    );
String settingsTitle() => Intl.message(
      "Einstellungen",
      name: "settingsTitle",
    );
String dasboardTitle() => Intl.message(
      "Hausaufgaben",
      name: "dasboardTitle",
    );
String gradesTitle() => Intl.message(
      "Noten",
      name: "gradesTitle",
    );
String absencesTitle() => Intl.message(
      "Absenzen",
      name: "absencesTitle",
    );
String calendarTitle() => Intl.message(
      "Kalender",
      name: "calendarTitle",
    );
String certificateTitle() => Intl.message(
      "Zeugnis",
      name: "certificateTitle",
    );
String messagesTitle() => Intl.message(
      "Mitteilungen",
      name: "messagesTitle",
    );
String collapse() => Intl.message(
      "Einklappen",
      name: "collapse",
    );
String expand() => Intl.message(
      "Ausklappen",
      name: "expand",
    );
String addAccount() => Intl.message(
      "Account hinzufügen",
      name: "addAccount",
    );
String changeAccount() => Intl.message(
      "Account wechseln",
      name: "changeAccount",
    );

// ----- grades -----
String gradeCalculator() => Intl.message(
      "Notenrechner",
      name: "gradeCalculator",
    );
String createNewGrade() => Intl.message(
      "Neue Note erstellen",
      name: "createNewGrade",
    );
String add() => Intl.message(
      "Hinzufügen",
      name: "add",
    );
String average() => Intl.message(
      "Durchschnitt",
      name: "average",
    );
String grades(int howMany) => Intl.plural(
      howMany,
      args: [howMany],
      name: "grades",
      other: "Noten",
      one: "Note",
    );
String gradeCalculatorHint() => Intl.message(
      "Um zu beginnen, importiere entweder bestehende Noten aus einem Fach\noder füge eine erste Note hinzu.",
      name: "gradeCalculatorHint",
    );
String importGrades() => Intl.message(
      "Noten importieren",
      name: "importGrades",
    );
String addGrade() => Intl.message(
      "Note hinzufügen",
      name: "addGrade",
    );
String selectSubject() => Intl.message(
      "Fach auswählen",
      name: "selectSubject",
    );
String firstSemester() => Intl.message(
      "Erstes Semester",
      name: "firstSemester",
    );
String secondSemester() => Intl.message(
      "Zweites Semester",
      name: "secondSemester",
    );
String bothSemester() => Intl.message(
      "Beide Semester",
      name: "bothSemester",
    );
String import() => Intl.message(
      "Importieren",
      name: "import",
    );
String noGradesAvailable() => Intl.message(
      "Für dieses Fach sind in diesem Zeitraum keine Noten verfügbar",
      name: "noGradesAvailable",
    );
String invalidValue() => Intl.message(
      "Ungültiger Wert",
      name: "invalidValue",
    );
String weighting() => Intl.message(
      "Gewichtung",
      name: "weighting",
    );
String chartLegend() => Intl.message(
      "Legende",
      name: "chartLegend",
    );
String gradesChart() => Intl.message(
      "Notendiagramm",
      name: "gradesChart",
    );
String chartTapHint() => Intl.message(
      "Tippe auf das Diagramm, um Details zu sehen",
      name: "chartTapHint",
    );
String gradeAverage() => Intl.message(
      "Notendurchschnitt",
      name: "gradeAverage",
    );
String sortGradesByType() => Intl.message(
      "Noten nach Art sortieren",
      name: "sortGradesByType",
    );
String showDeletedGrades() => Intl.message(
      "Gelöschte Noten anzeigen",
      name: "showDeletedGrades",
    );
String subjectExcluded() => Intl.message(
      "Du hast dieses Fach aus dem Notendurchschnitt ausgeschlossen",
      name: "subjectExcluded",
    );
String gradeCalculatorDesc() => Intl.message(
      "Berechne den Durchschnitt von beliebigen Noten",
      name: "gradeCalculatorDesc",
      desc:
          "The grade calculator allows calculating the average of arbitrary grades",
    );
String noGradeForAverage() => Intl.message(
      "keine Note eingetragen",
      name: "noGradeForAverage",
    );

// ----- no internet -----
String noConnection() => Intl.message(
      "Keine Verbindung",
      name: "noConnection",
    );
String offlineModeActive() => Intl.message(
      "Offline-Modus aktiv.",
      name: "offlineModeActive",
    );
String lastSynced() => Intl.message(
      "Zuletzt synchronisiert",
      name: "lastSynced",
    );
String formatDays(int howMany) => Intl.plural(
      howMany,
      name: "formatDays",
      args: [howMany],
      one: "Tag",
      other: "Tage",
    );
String formatHours(int howMany) => Intl.plural(
      howMany,
      name: "formatHours",
      args: [howMany],
      one: "Stunde",
      other: "Stunden",
    );
String formatMinutes(int howMany) => Intl.plural(
      howMany,
      name: "formatMinutes",
      args: [howMany],
      one: "Minute",
      other: "Minuten",
    );
String formatSeconds(int howMany) => Intl.plural(
      howMany,
      name: "formatSeconds",
      args: [howMany],
      one: "Sekunde",
      other: "Sekunden",
    );
String formatTimeAgo(int howMany, String unit) => Intl.message(
      "vor $howMany $unit",
      args: [
        howMany,
        unit,
      ],
      name: "formatTimeAgo",
    );

// ---- login -----
String school() => Intl.message(
      "Schule",
      name: "school",
    );
String differentSchool() => Intl.message(
      "Andere Schule",
      name: "differentSchool",
    );
String schoolNotFound() => Intl.message(
      "Schule nicht gefunden",
      name: "schoolNotFound",
    );
String enterSchoolName() => Intl.message(
      "Bitte gib den Namen der Schule ein",
      name: "enterSchoolName",
    );
String address() => Intl.message(
      "Adresse",
      name: "address",
    );
String username() => Intl.message(
      "Benutzername",
      name: "username",
    );
String resetPassword() => Intl.message(
      "Passwort zurücksetzen",
      name: "resetPassword",
    );
String password() => Intl.message(
      "Passwort",
      name: "password",
    );
String oldPassword() => Intl.message(
      "Altes Passwort",
      name: "oldPassword",
    );
String newPassword() => Intl.message(
      "Neues Passwort",
      name: "newPassword",
    );
String forgotPassword() => Intl.message(
      "Passwort vergessen",
      name: "forgotPassword",
    );
String forceChangePassword() => Intl.message(
      "Du musst dein Passwort ändern:",
      name: "forceChangePassword",
    );

String passwordRequirements() => Intl.message(
      "Das neue Passwort muss:\n"
      "- mindestens 10 Zeichen lang sein\n"
      "- mindestens einen Großbuchstaben enthalten\n"
      "- mindestens einen Kleinbuchstaben enthalten\n"
      "- mindestens eine Zahl enthalten\n"
      "- mindestens ein Sonderzeichen enthalten\n"
      "- nicht mit dem alten Passwort übereinstimmen",
      name: "passwordRequirements",
      desc: "Stupid password requirements",
    );
String repeatNewPassword() => Intl.message(
      "Neues Passwort wiederholen",
      name: "repeatNewPassword",
    );
String passwordsDontMatch() => Intl.message(
      "Die neuen Passwörter stimmen noch nicht überein",
      name: "passwordsDontMatch",
    );
String otherAccounts() => Intl.message(
      "Andere Accounts",
      name: "otherAccounts",
    );
String connectionFailed(String to) => Intl.message(
      'Keine Verbindung mit "$to" möglich. Bitte überprüfe deine Internetverbindung.\n'
      'Wenn du "Andere Schule" ausgewählt hast, musst du eine gültige Adresse eingeben.',
      name: "connectionFailed",
      args: [to],
    );
String login() => Intl.message(
      "Login",
      name: "login",
    );
String sendPassResetRequest() => Intl.message(
      "Anfrage zum Zurücksetzen senden",
      name: "sendPassResetRequest",
    );
String emailAddress() => Intl.message(
      "Email-Adresse",
      name: "emailAddress",
    );
String ok() => Intl.message(
      "Ok",
      name: "ok",
    );

// ----- messages -----
String noMessages() => Intl.message(
      "Noch keine Mitteilungen",
      name: "noMessages",
    );
String sent() => Intl.message(
      "Gesendet",
      name: "sent",
      desc: "Label for the datetime the message was sent",
    );
String from() => Intl.message(
      "Von",
      name: "from",
    );
String to() => Intl.message(
      "An",
      name: "to",
    );

// ---- notifications -----
String notifications() => Intl.message(
      "Benachrichtigungen",
      name: "notifications",
    );
String noNotifications() => Intl.message(
      "Keine Benachrichtigungen",
      name: "noNotifications",
    );
String readAll() => Intl.message(
      "Alle gelesen",
      name: "readAll",
      desc: "Button that allows the user to mark all notifications as read",
    );

// ---- misc messages -----
String failedToSave() => Intl.message(
      "Beim Speichern ist ein Fehler aufgetreten",
      name: "failedToSave",
    );
String downloaded() => Intl.message(
      "Heruntergeladen",
      name: "downloaded",
    );
String failedToDownload() => Intl.message(
      "Download fehlgeschlagen",
      name: "failedToDownload",
    );
String enterSomething() => Intl.message(
      "Bitte gib etwas ein",
      name: "enterSomething",
      desc: "Shown when the user tries to login without a password/username",
    );
String sorry() => Intl.message(
      "Tut uns leid!",
      name: "sorry",
    );
String userKindNotSupported() => Intl.message(
      "Dieser Benutzertyp wird nicht unterstützt.",
      name: "userKindNotSupported",
      desc: "Shown when a teacher tries to log in",
    );
String userKindNotSupportedDesc() => Intl.message(
      "Diese App ist ausschließlich für Schüler*innen und Eltern geeignet.",
      name: "userKindNotSupportedDesc",
    );
String back() => Intl.message(
      "Zurück",
      name: "back",
    );
String goToWebClient() => Intl.message(
      "Hier geht's zur Website",
      name: "goToWebClient",
    );
String passwordChanged() => Intl.message(
      "Passwort erfolgreich geändert",
      name: "passwordChanged",
      desc: "Shown when a teacher tries to log in",
    );
String unexpectedError() => Intl.message(
      "Ein Fehler ist aufgetreten.",
      name: "unexpectedError",
    );
String unexpectedLogout() => Intl.message(
      """
Dieser Fehler kann auftreten, wenn zwei Geräte gleichzeitig auf dasselbe Konto zugreifen.
In diesem Fall kannst du versuchen, die App zu schließen und erneut zu öffnen.

Falls dies nicht zutrifft, bitte benachrichtige uns, damit wir diesen Fehler beheben können.""",
      name: "unexpectedLogout",
    );
String parseError() => Intl.message(
      """
Beim Einlesen der Daten ist ein Fehler aufgetreten.
Bitte benachrichtige uns, damit wir diesen Fehler beheben können.
Bitte beachte, dass das Fehlerprotokoll möglicherweise private Daten enthält.""",
      name: "parseError",
    );
String generalErrorMessage() => Intl.message(
      """
Eine Funktion wird eventuell noch nicht unterstützt.
Bitte benachrichtige uns, damit wir diesen Fehler beheben können:""",
      name: "generalErrorMessage",
    );
String errorLog() => Intl.message(
      "Fehlerprotokoll",
      name: "errorLog",
    );
String failedLoadingData() => Intl.message(
      "Fehler beim Laden der gespeicherten Daten",
      name: "failedLoadingData",
    );
String tryReinstalling() => Intl.message(
      "Bitte versuche, die App neu zu installieren.",
      name: "tryReinstalling",
    );
String failedOpeningLink() => Intl.message(
      "Dieser Link konnte nicht geöffnet werden",
      name: "failedOpeningLink",
    );
