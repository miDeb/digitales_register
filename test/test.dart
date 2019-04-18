import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

main() {
  int readUserId(String source) {
    var substringFromId = source
        .substring(source.indexOf("currentUserId=") + "currentUserId=".length);
    return int.parse(
        substringFromId.substring(0, substringFromId.indexOf(";")).trim());
  }

  String readAfterImgId(String source) {
    return source
        .substring(source.indexOf("navigationProfilePicture") +
            "navigationProfilePicture".length)
        .trim();
  }

  String readFullName(String source) {
    final afterImgId = readAfterImgId(source);
    return afterImgId
        .substring(afterImgId.indexOf(">") + 1, afterImgId.indexOf("<"))
        .trim();
  }

  String readImgSource(String source) {
    final afterImgId = readAfterImgId(source);
    final afterStart =
        afterImgId.substring(afterImgId.indexOf('src="') + "src='".length);
    return afterStart.substring(0, afterStart.indexOf('"')).trim();
  }

  int readAutoLogoutSeconds(String source) {
    var substringFromId = source.substring(
        source.indexOf("auto_logout_seconds: ") +
            "auto_logout_seconds: ".length);
    return int.parse(
        substringFromId.substring(0, substringFromId.indexOf(",")).trim());
  }

  test('test', () {
    expect(readUserId(source), 3539);
    expect(readFullName(source), "Michael Debertol");
    expect(readImgSource(source),
        "https://vinzentinum.digitalesregister.it/v2/theme/icons/profile_empty.png");
    expect(readAutoLogoutSeconds(source), 300);
  });

  test("cookies", () {
    print(Cookie.fromSetCookieValue(headers));
  });
}

String headers =
    r"PHPSESSID=88e7ae2e1ae0aa0154e239c76e0c38ce; path=/; domain=vinzentinum.digitalesregister.it; secure; HttpOnly,registerSession=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; Max-Age=0; registerSession=510397aa6e20160559685f88507805e035f92d5e; path=/; domain=vinzentinum.digitalesregister.it; secure; HttpOnly";
String source = r"""<!DOCTYPE html>

<html class="no-js linen" lang="de">

<head class=" js no-flexbox no-touch hashchange rgba hsla multiplebgs backgroundsize borderradius boxshadow textshadow opacity cssanimations cssgradients csstransforms csstransforms3d csstransitions fontface generatedcontent boxsizing pointerevents no-details">
	<meta charset="utf-8">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

	<title>Klassenbuch des Vinzentinums</title>

	<meta name="HandheldFriendly" content="True">
	<meta name="MobileOptimized" content="320">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">


	<script>
		var currentUserId=3539;var currentUserName="st-debmic-03";var teachers = [];var rooms = [{"id":"1","name":"Werkraum"},{"id":"2","name":"3A"},{"id":"3","name":"3B"},{"id":"4","name":"1A"},{"id":"5","name":"1B"},{"id":"6","name":"2A"},{"id":"7","name":"2B"},{"id":"9","name":"4"},{"id":"10","name":"5"},{"id":"11","name":"6"},{"id":"12","name":"7"},{"id":"13","name":"8"},{"id":"14","name":"Chemieraum"},{"id":"15","name":"Physikraum"},{"id":"16","name":"Musikraum"},{"id":"17","name":"Biologieraum"},{"id":"18","name":"EDV-Raum 1"},{"id":"19","name":"Mittelschulbibliothek"},{"id":"20","name":"Oberschulbibliothek"},{"id":"21","name":"Festsaal"},{"id":"22","name":"Theatersaal"},{"id":"23","name":"Ausweichklasse"},{"id":"24","name":"Kunstraum"},{"id":"25","name":"Physikpraktikumsraum"},{"id":"26","name":"Turnhalle"},{"id":"27","name":"Chorproberaum KCH"},{"id":"28","name":"EDV-Raum 2 Tiefparterre"},{"id":"29","name":"Laptop 1"},{"id":"30","name":"Laptop 2"},{"id":"31","name":"Beamer 1"},{"id":"32","name":"Beamer 2"},{"id":"33","name":"Oberheadprojektor 1"},{"id":"34","name":"Oberheadprojektor 2"},{"id":"35","name":"Sportplatz"},{"id":"36","name":"Gruppenraum Turnhalle"},{"id":"37","name":"Fitnessraum"},{"id":"38","name":"Film-Kamera"},{"id":"39","name":"Fotoapparat"},{"id":"40","name":"Chorproberaum MCH"},{"id":"41","name":"Gruppenraum Tiefparterre T14"},{"id":"42","name":"Gruppenraum 1. Stock"}];var subjects = [{"id":"88","name":"Antike Mythologie","choiceSubject":"75","weight":"100"},{"id":"1","name":"Betragen","choiceSubject":"0","weight":"1"},{"id":"17","name":"Bewegung und Sport","choiceSubject":"0","weight":"2"},{"id":"86","name":"Bewegungsspass mit kleinen Spielen","choiceSubject":"73","weight":"100"},{"id":"6","name":"Deutsch","choiceSubject":"0","weight":"3"},{"id":"83","name":"Elektronikwerkstatt","choiceSubject":"70","weight":"0"},{"id":"84","name":"Elektronikwerkstatt 2","choiceSubject":"71","weight":"100"},{"id":"8","name":"Englisch","choiceSubject":"0","weight":"4"},{"id":"81","name":"Faszination Spielen","choiceSubject":"68","weight":"0"},{"id":"24","name":"F\u00dc","choiceSubject":"0","weight":"5"},{"id":"11","name":"Geografie","choiceSubject":"0","weight":"7"},{"id":"10","name":"Geschichte","choiceSubject":"0","weight":"6"},{"id":"20","name":"Griechisch","choiceSubject":"0","weight":"8"},{"id":"23","name":"IKT","choiceSubject":"0","weight":"9"},{"id":"82","name":"Italiano per tutti i giorni","choiceSubject":"69","weight":"0"},{"id":"87","name":"Italiano per tutti i giorni 2","choiceSubject":"74","weight":"100"},{"id":"7","name":"Italienisch","choiceSubject":"0","weight":"10"},{"id":"79","name":"KUGE-Schwerpunkt","choiceSubject":"0","weight":"0"},{"id":"15","name":"Kunst","choiceSubject":"0","weight":"11"},{"id":"19","name":"Latein","choiceSubject":"0","weight":"12"},{"id":"80","name":"Legomindstorms","choiceSubject":"67","weight":"0"},{"id":"85","name":"Legomindstorms 2","choiceSubject":"72","weight":"100"},{"id":"18","name":"Lernberatung","choiceSubject":"0","weight":"13"},{"id":"13","name":"Mathematik","choiceSubject":"0","weight":"14"},{"id":"16","name":"Musik","choiceSubject":"0","weight":"15"},{"id":"22","name":"Naturwissenschaften","choiceSubject":"0","weight":"16"},{"id":"78","name":"NATWI-Schwerpunkt","choiceSubject":"0","weight":"0"},{"id":"21","name":"Philosophie","choiceSubject":"0","weight":"17"},{"id":"14","name":"Physik","choiceSubject":"0","weight":"18"},{"id":"25","name":"Recht und Wirtschaft","choiceSubject":"0","weight":"19"},{"id":"5","name":"Religion","choiceSubject":"0","weight":"20"},{"id":"43","name":"Technik","choiceSubject":"0","weight":"21"},{"id":"56","name":"Z-Chor","choiceSubject":"0","weight":"0"},{"id":"53","name":"Z-Einkehrtag","choiceSubject":"0","weight":"0"},{"id":"68","name":"Z-Elternsprechtag","choiceSubject":"0","weight":"0"},{"id":"51","name":"Z-Herbstausflug","choiceSubject":"0","weight":"0"},{"id":"29","name":"Z-Klassenlehrerstunde","choiceSubject":"0","weight":"0"},{"id":"52","name":"Z-Lehrfahrt","choiceSubject":"0","weight":"0"},{"id":"58","name":"Z-Lernstunde","choiceSubject":"0","weight":"0"},{"id":"50","name":"Z-Maiausflug","choiceSubject":"0","weight":"0"},{"id":"54","name":"Z-Osterdienstag","choiceSubject":"0","weight":"0"},{"id":"77","name":"Z-PISA-Pr\u00fcfung","choiceSubject":"0","weight":"0"},{"id":"63","name":"Z-Projektunterricht","choiceSubject":"0","weight":"0"},{"id":"57","name":"Z-Schueleraustausch","choiceSubject":"0","weight":"0"},{"id":"64","name":"Z-Weihnachtsfeier","choiceSubject":"0","weight":"0"},{"id":"49","name":"Z-Wintersporttag","choiceSubject":"0","weight":"0"}];var classes = [{"id":"52","name":"1A","choiceSubject":"0","belongsTo":"0"},{"id":"53","name":"1B","choiceSubject":"0","belongsTo":"0"},{"id":"54","name":"2A","choiceSubject":"0","belongsTo":"0"},{"id":"55","name":"2B","choiceSubject":"0","belongsTo":"0"},{"id":"56","name":"3A","choiceSubject":"0","belongsTo":"0"},{"id":"57","name":"3B","choiceSubject":"0","belongsTo":"0"},{"id":"58","name":"4K","choiceSubject":"0","belongsTo":"0"},{"id":"59","name":"5K","choiceSubject":"0","belongsTo":"0"},{"id":"60","name":"6K","choiceSubject":"0","belongsTo":"0"},{"id":"61","name":"7K","choiceSubject":"0","belongsTo":"0"},{"id":"66","name":"7K KUGE-Schwerpunkt","choiceSubject":"0","belongsTo":"61"},{"id":"65","name":"7K NATWI-Schwerpunkt","choiceSubject":"0","belongsTo":"61"},{"id":"62","name":"8K","choiceSubject":"0","belongsTo":"0"},{"id":"75","name":"Antike Mythologie","choiceSubject":"1","belongsTo":"0"},{"id":"73","name":"Bewegungsspass mit kleinen Spielen","choiceSubject":"1","belongsTo":"0"},{"id":"70","name":"Elektronikwerkstatt 1","choiceSubject":"1","belongsTo":"0"},{"id":"71","name":"Elektronikwerkstatt 2","choiceSubject":"1","belongsTo":"0"},{"id":"68","name":"Faszination Spielen","choiceSubject":"1","belongsTo":"0"},{"id":"69","name":"Italiano per tutti i giorni 1","choiceSubject":"1","belongsTo":"0"},{"id":"74","name":"Italiano per tutti i giorni 2","choiceSubject":"1","belongsTo":"0"},{"id":"67","name":"Legomindstorms 1","choiceSubject":"1","belongsTo":"0"},{"id":"72","name":"Legomindstorms 2","choiceSubject":"1","belongsTo":"0"}];var gradeTypes = [{"id":7,"name":"anderes"},{"id":4,"name":"Hausaufgabe"},{"id":6,"name":"Mitarbeit"},{"id":55,"name":"Online Hausaufgabe"},{"id":12,"name":"Praktische Arbeit"},{"id":1,"name":"Pr\u00fcfung"},{"id":5,"name":"Referat"},{"id":3,"name":"Schularbeit"},{"id":2,"name":"Test"}];var observationTypes = [{"id":14,"name":"abgelenkt - anderweitig besch\u00e4ftigt","oneclick":1},{"id":1,"name":"Anmerkung zum Verhalten","oneclick":0},{"id":5,"name":"Aussprachen, Pers\u00f6nliche Sprechstunden","oneclick":0},{"id":15,"name":"Begr\u00fcndung der negativen Endbewertung","oneclick":0},{"id":9,"name":"Bemerkung zur Vorbereitung","oneclick":0},{"id":8,"name":"Beobachtung","oneclick":0},{"id":6,"name":"Disziplinarvermerke","oneclick":0},{"id":17,"name":"f\u00fcr Pr\u00fcfung entschuldigt","oneclick":1},{"id":10,"name":"gute Mitarbeit","oneclick":1},{"id":16,"name":"Hausaufgabe vergessen","oneclick":1},{"id":13,"name":"Lernunterlagen vergessen","oneclick":1},{"id":3,"name":"Lernvereinbarungen","oneclick":0},{"id":20,"name":"Minus","oneclick":1},{"id":19,"name":"Plus","oneclick":1},{"id":2,"name":"R\u00fcckmeldung zum Lernfortschritt","oneclick":0},{"id":11,"name":"schlechte Mitarbeit","oneclick":1},{"id":18,"name":"st\u00f6rendes Verhalten","oneclick":1},{"id":4,"name":"St\u00fctz-, Aufhol-, F\u00f6rderma\u00dfnahmen","oneclick":0}];var config = {
					number_of_hours: 9,
					days_in_week: 5,
					competence_stars_enabled: true,
					competence_stars_scale: 5,
					competence_grade_decimals: false,
					minimum_grade: 3,
					auto_logout_seconds: 300,
				};var WWW = "https://vinzentinum.digitalesregister.it/v2/";var JSCOMPILER_PRESERVE = function() {};		var strings = {};
		strings["error.unknown"] = "Ein unbekannter Fehler ist aufgetreten.";strings["error.login_missing_data"] = "Bitte Benutzernamen und Passwort angeben.";strings["glossary.grade"] = "Bewertung";strings["navigation.auto_logout"] = "Automatisch um {time}";strings["absence.student_early"] = "Geht {minutes} Minuten früher";strings["absence.student_late"] = "{minutes} Minuten verspätet";strings["absence.student_late_early"] = "{minutes1} Minuten verspätet und geht {minutes2} Minuten früher";strings["absence.student_missing"] = "Abwesend";strings["absence.student_present"] = "Anwesend";strings["greeting.morning"] = "Guten Morgen";strings["greeting.day"] = "Guten Tag";strings["greeting.afternoon"] = "Guten Nachmittag";strings["greeting.evening"] = "Schönen Abend";strings["greeting.night"] = "Gute Nacht";strings["greeting.welcome"] = "Willkommen";strings["absence.justified"] = "Entschuldigt";strings["absence.not_justified"] = "Nicht entschuldigt";strings["absence.not_edited"] = "Noch nicht entschuldigt";strings["grade.group.date.flexible"] = "Unterschiedliche Daten";strings["glossary.reminder"] = "Erinnerung";strings["absence.minutes"] = "Minuten";strings["absence.lesson"] = "Eine Stunde";strings["absence.lessons"] = "Stunden";strings["student.absence.error"] = "Bitte Begründung und Name eingeben";strings["absence.for_school"] = "Im Auftrag";strings["absence.future.error"] = "Bitte füllen Sie alle Felder vollständig aus.";strings["oauth.authentication.description"] = "Durch Klicken auf \"Zugriff Erlauben\" gewähren Sie {name} Zugriff auf Ihre Daten im Digitalen Register.";strings["teacher.competences.no_subject"] = "Nur für mich";strings["course_content.text.write"] = "Text verfassen...";strings["homework.online.inactive"] = "Nicht aktiviert";strings["homework.online.active"] = "Möglich bis";strings["course_content.remove_warning"] = "Thema {topic} und alle Inhalte löschen?";strings["admin.defaults.show_per_page"] = "{count} Einträge pro Seite anzeigen";strings["admin.defaults.show_from_to"] = "Zeige Einträge von {start} bis {end} von insgesamt {total}";strings["admin.log.empty"] = "Keine Einträge gefunden";strings["admin.defaults.filtered"] = "(gefiltert von insgesamt {total} Einträgen)";strings["admin.defaults.first_page"] = "Erste Seite";strings["glossary.back"] = "Zurück";strings["glossary.next"] = "Weiter";strings["admin.defaults.last_page"] = "Letzte Seite";strings["glossary.search"] = "Suche";
	</script>



	<!-- media query dependent stylesheets for backward compatibility -->
	<link rel="stylesheet" href="https://vinzentinum.digitalesregister.it/v2/theme/css/style.css?v=1">
	<link rel="stylesheet" media="only all and (min-width: 480px)" href="https://vinzentinum.digitalesregister.it/v2/theme/css/480.css?v=1">
	<link rel="stylesheet" media="only all and (min-width: 768px)" href="https://vinzentinum.digitalesregister.it/v2/theme/css/768.css?v=1">
	<link rel="stylesheet" media="only all and (min-width: 992px)" href="https://vinzentinum.digitalesregister.it/v2/theme/css/992.css?v=1">
	<link rel="stylesheet" media="only all and (min-width: 1200px)" href="https://vinzentinum.digitalesregister.it/v2/theme/css/1200.css?v=1">

	<link rel="stylesheet" href="https://vinzentinum.digitalesregister.it/v2/theme/css/main-old.min.css?v=59"><link rel="stylesheet" href="https://vinzentinum.digitalesregister.it/v2/theme/css/v2/main-new.min.css?v=59"><script type="text/javascript" src="https://vinzentinum.digitalesregister.it/v2/scripts/main.min.js?v=59"></script>
	<script type="text/javascript">
	  var WWW="https://vinzentinum.digitalesregister.it/v2/";
	  var KOMPETENZENZUNOTEN=true;
	  var KOPETENZENSKALA=5;
	</script>

	<!-- For Modern Browsers -->
	<link rel="shortcut icon" href="https://vinzentinum.digitalesregister.it/v2/theme/img/favicons/favicon.png">
	<!-- For everything else -->
	<link rel="shortcut icon" href="https://vinzentinum.digitalesregister.it/v2/theme/img/favicons/favicon.ico">
	<!-- For retina screens -->
	<link rel="apple-touch-icon-precomposed" sizes="114x114" href="https://vinzentinum.digitalesregister.it/v2/theme/img/favicons/apple-touch-icon-retina.png">
	<!-- For iPad 1-->
	<link rel="apple-touch-icon-precomposed" sizes="72x72" href="https://vinzentinum.digitalesregister.it/v2/theme/img/favicons/apple-touch-icon-ipad.png">
	<!-- For iPhone 3G, iPod Touch and Android -->
	<link rel="apple-touch-icon-precomposed" href="https://vinzentinum.digitalesregister.it/v2/theme/img/favicons/apple-touch-icon.png">

	<!-- iOS web-app metas -->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">

	<!-- Startup image for web apps -->
	<link rel="apple-touch-startup-image" href="https://vinzentinum.digitalesregister.it/v2/theme/img/splash/ipad-landscape.png" media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:landscape)">
	<link rel="apple-touch-startup-image" href="https://vinzentinum.digitalesregister.it/v2/theme/img/splash/ipad-portrait.png" media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:portrait)">
	<link rel="apple-touch-startup-image" href="https://vinzentinum.digitalesregister.it/v2/theme/img/splash/iphone.png" media="screen and (max-device-width: 320px)">

	<!-- Microsoft clear type rendering -->
	<meta http-equiv="cleartype" content="on">

	<!-- IE9 Pinned Sites: http://msdn.microsoft.com/en-us/library/gg131029.aspx -->
	<meta name="application-name" content="Digitales Register">
	<meta name="msapplication-tooltip" content="Digitales Register">
	<meta name="msapplication-starturl" content="">

	<script>
		moment.updateLocale('en', {
		    calendar : {
		        lastDay : '[Yesterday], D. MMMM',
		        sameDay : '[Today], D. MMMM',
		        nextDay : '[Tomorrow], D. MMMM',
		        lastWeek : '[last] dddd, D. MMMM',
		        nextWeek : 'dddd, D. MMMM',
		        sameElse : 'dddd, D. MMMM'
		    }
		});
		moment.updateLocale('de', {
		    calendar : {
		        lastDay : '[Gestern], D. MMMM',
		        sameDay : '[Heute], D. MMMM',
		        nextDay : '[Morgen], D. MMMM',
		        lastWeek : '[Letzter] dddd, D. MMMM',
		        nextWeek : 'dddd, D. MMMM',
		        sameElse : 'dddd, D. MMMM'
		    }
		});
		moment.updateLocale('it', {
				calendar : {
						lastDay : '[ieri], D MMMM',
						sameDay : '[oggi], D MMMM',
						nextDay : '[domani], D MMMM',
						lastWeek : 'dddd, D MMMM',
						nextWeek : 'dddd, D MMMM',
						sameElse : 'dddd, D MMMM'
				}
		});
		moment.locale('de');

	</script>

</head>
<body class="reversed clearfix with-menu --main-navigation-show-mobile ">
<section role="main" id="main">
<div id="maincontent" class="thin">

<div id='notificationApp' class='notification-list notification-list-small-margin' ng-controller='NotificationController' ng-init='initUnreadNotifications()'>
  <div class="notification-header" ng-if='notifications.length > 0'>
    <span class='h2'>Neue Benachrichtigungen</span>
    <a class="notification-all-read-button" ng-click="markAllAsRead()" ng-show="showMarkAllAsRead()">Alle Gelesen</a>
  </div>
  <notification ng-repeat='notification in notifications'
                data='notification'></notification>
</div>

<div id="studentDashboardApp" class="student-dashboard-list" ng-controller="StudentDashboardController" ng-init="init()">
  <div class="timeline"></div>
  <div class='student-dashboard-day' ng-repeat='day in days track by $index'>
    <div class="h2">
      <span>{{day.dateFormatted}}</span>
      <a class="student-dashboard-switch" ng-show="viewFuture==false && $index==0" ng-click="showFuture()" style="">Zukunft Anzeigen</a>
      <a class="student-dashboard-switch" ng-show="viewFuture==true && $index==0" ng-click="showPast()">Vergangenheit Anzeigen</a>
    </div>
    <div class='student-dashboard-item' ng-repeat='item in day.items'>
      <div class='student-dashboard-item-left'>
        <span ng-class="{'student-dashboard-item-done': item.checked}"><strong>{{item.title}}</strong> {{item.subtitle}}</span>
        <grade value='item.grade' ng-show='item.grade>0'></grade>
      </div>
      <span class='class-label student-dashboard-item-right' ng-show='item.label'>{{item.label}}</span>
      <div class='item-status item-status-checkable' ng-class='{"item-status-done": item.checked}'
          ng-show='item.checkable || item.checked'
          ng-click='toggleEntry(item)'></div>
      <div class='item-status item-status-warning' ng-show='item.warning'></div>
      <div class='item-status item-status-done' ng-show='item.grade'></div>
      <span class='item-delete' ng-show='item.deleteable === true' ng-click='removeEntry(day, item)'>Entfernen</span>
      <div class="item-submission" ng-show="item.online">
        <span class="item-submission-cta btn" ng-click="newSubmission(item)" ng-if="item.submission==null && item.submissionAllowed">Abgabe hinzufügen</span>
        <div ng-show="item.submission != null">
            <a class="item-submission-file" ng-click="openSubmission(item.submission)">{{item.submission.typeName}}</a>
            <a class="item-submission-update" ng-click="newSubmission(item)" ng-if="item.submissionAllowed">Abgabe Aktualisieren</a>
            <span class="item-submission-deadline">Abgabe bis {{item.deadlineFormatted}}</span>
        </div>
        <span class="item-submission-over" ng-if="item.submission == null && !item.submissionAllowed">Abgabe vorbei</span>
        <span class="item-submission-deadline" ng-if="item.submission == null">Abgabe bis {{item.deadlineFormatted}}</span>
      </div>
    </div>

    <span class='add-homework'
      ng-show='day.showAddEntry===false'
      ng-click='day.showAddEntry=true'
      >Erinnerung hinzufügen (z.B. Hausaufgabe)</span>
    <form class='student-dashboard-item add-entry-item' ng-show='day.showAddEntry===true' ng-submit='addEntry(day)'>
      <input ng-model='day.newEntryText' type='text' class='input' placeholder='Text eingeben'>
      <input type='submit' class='btn' value='Speichern'>
      <span class='add-entry-item-close' ng-click='day.showAddEntry=false'>X</span>
    </form>

  </div>
</div>

<script type="text/javascript">
	if(typeof angular != 'undefined') {
		var dashboard = document.getElementById('studentDashboardApp');
		angular.bootstrap(dashboard, ["studentApp"]);
    var notification = document.getElementById('notificationApp');
    angular.bootstrap(notification, ["notificationApp"]);
	} else {
		console.log('failed to start angular StudentDashboardController');
	}
</script>
</div></section><div class="navigation-toggle" onclick="showMenu()"><a class="navigation-toggle-link" href="javascript:showMenu()"></a><h1 id="mobile-navigation-title"></h1></div><div class="v2-main-navigation main-navigation-show-mobile"><a class="navigation-close-link" href="javascript:hideMenu()">Menü schließen</a><a href="#profile/view" class="hashlink item item-primary item-profile">
    <img id="navigationProfilePicture" src="https://vinzentinum.digitalesregister.it/v2/theme/icons/profile_empty.png">

    Michael Debertol<br><small>Profil bearbeiten</small>
    </a><a class="item item-active" href="#dashboard/student">Merkheft</a><a class="item" href="#student/absences">Absenzen</a><a class="item" href="#calendar/student">Kalender</a><a class="item" href="#student/subjects">Bewertungen</a><div class="item-group item-group-no-margin"><a class="item" href="#courseContent/viewer?course=12">Unterrichtsmaterialien</a><a class="item item-secondary" href="#courseContent/viewer?course=12">Italienisch</a><a class="item item-secondary" href="#courseContent/viewer?course=2">Latein</a><a class="item item-secondary" href="#courseContent/viewer?course=4">Mathematik</a></div><a class="item item-icon item-icon-messages" href="#message/list">Mitteilungen</a><a class="item" href="#register/student" class="hashlink item">Klassenbuch</a><a class="item" href="#student/certificate">Zeugnis</a><a class="item" href="https://vinzentinum.digitalesregister.it/v2/?semesterWechsel=1">Zu 1. Semester wechseln</a><div class="space"></div><a class="item item-icon item-icon-logout" href="https://vinzentinum.digitalesregister.it/v2/logout">Abmelden<br><span id="logouttime"></span></a></div>




  
  <script>
    $.template.init();
    var currentpage = "dashboard/content";
  </script>
  <link rel="stylesheet" href="https://vinzentinum.digitalesregister.it/v2/theme/plugins/rateit/rateit.css">
  <script type="text/javascript" src="https://vinzentinum.digitalesregister.it/v2/theme/plugins/rateit/jquery.rateit.min.js"></script>
</body>
</html>
""";
