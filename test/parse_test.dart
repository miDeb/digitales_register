import 'dart:convert';

import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:flutter_test/flutter_test.dart';

// client-subbmitted (name changed)
const absencesJson = {
  "absences": [
    {
      "group": [
        {
          "id": 3044,
          "minutes": 50,
          "minutes_begin": 0,
          "minutes_end": 0,
          "justified": 1,
          "note": null,
          "date": "2021-02-02",
          "hour": 5,
          "reason": "Laura ist noch immer nicht ganz fit",
          "reason_signature": null,
          "reason_timestamp": null,
          "reason_user": 1768,
          "selfdecl_id": null,
          "selfdecl_input": null
        },
        {
          "id": 3032,
          "minutes": 50,
          "minutes_begin": 0,
          "minutes_end": 0,
          "justified": 1,
          "note": null,
          "date": "2021-02-02",
          "hour": 4,
          "reason": "Laura ist noch immer nicht ganz fit",
          "reason_signature": null,
          "reason_timestamp": null,
          "reason_user": 1768,
          "selfdecl_id": null,
          "selfdecl_input": null
        },
        {
          "id": 3026,
          "minutes": 50,
          "minutes_begin": 0,
          "minutes_end": 0,
          "justified": 1,
          "note": null,
          "date": "2021-02-02",
          "hour": 3,
          "reason": "Laura ist noch immer nicht ganz fit",
          "reason_signature": null,
          "reason_timestamp": null,
          "reason_user": 1768,
          "selfdecl_id": null,
          "selfdecl_input": null
        },
        {
          "id": 3012,
          "minutes": 50,
          "minutes_begin": 0,
          "minutes_end": 0,
          "justified": 1,
          "note": null,
          "date": "2021-02-02",
          "hour": 2,
          "reason": "Laura ist noch immer nicht ganz fit",
          "reason_signature": null,
          "reason_timestamp": null,
          "reason_user": 1768,
          "selfdecl_id": null,
          "selfdecl_input": null
        }
      ],
      "date": "2021-02-02",
      "note": null,
      "reason": "Laura ist noch immer nicht ganz fit",
      "reason_signature": null,
      "reason_timestamp": null,
      "reason_user": 1768,
      "justified": 1,
      "selfdecl_id": null,
      "selfdecl_input": null
    },
    {
      "group": [
        {
          "id": 2985,
          "minutes": 50,
          "minutes_begin": 0,
          "minutes_end": 0,
          "justified": 1,
          "note": null,
          "date": "2021-02-01",
          "hour": 5,
          "reason":
              "Laura fühlt sich nicht ganz wohl, sie bleibt sicherheitshalber zu Hause",
          "reason_signature": null,
          "reason_timestamp": null,
          "reason_user": 1768,
          "selfdecl_id": null,
          "selfdecl_input": null
        },
        {
          "id": 3002,
          "minutes": 50,
          "minutes_begin": 0,
          "minutes_end": 0,
          "justified": 1,
          "note": null,
          "date": "2021-02-01",
          "hour": 4,
          "reason":
              "Laura fühlt sich nicht ganz wohl, sie bleibt sicherheitshalber zu Hause",
          "reason_signature": null,
          "reason_timestamp": null,
          "reason_user": 1768,
          "selfdecl_id": null,
          "selfdecl_input": null
        }
      ],
      "date": "2021-02-01",
      "note": null,
      "reason":
          "Laura fühlt sich nicht ganz wohl, sie bleibt sicherheitshalber zu Hause",
      "reason_signature": null,
      "reason_timestamp": null,
      "reason_user": 1768,
      "justified": 1,
      "selfdecl_id": null,
      "selfdecl_input": null
    }
  ],
  "futureAbsences": <dynamic>[],
  "canEdit": true,
  "statistics": {
    "counter": "",
    "counterForSchool": "",
    "percentage": "",
    "justified": 0,
    "notJustified": 0,
    "delayed": 0
  },
  "selfDeclarationsList": [
    {
      "id": 1,
      "title": "Familiäre Gründe",
      "text":
          "<strong>Erklärung für die Wiederaufnahme in die Schulgemeinschaft nach Abwesenheit aus NICHT gesundheitlichen Gründen</strong><br>\r\nDer/die Unterfertigte ERKLÄRT im Bewusstsein aller zivil- und strafrechtlichen Folgen im Falle einer Falscherklärung und im vollen Bewusstsein der Wichtigkeit einer uneingeschränkten Befolgung der Maßnahmen zur Verhinderung der Ausbreitung der SARS-CoV-2-Infektion und folglich zum Schutz der kollektiven Gesundheit, dass diese Abwesenheit <strong>nicht im Zusammenhang mit Gesundheitsproblemen steht, sondern auf andere Gründe zurückzuführen ist.</strong>\r\n",
      "version": "MOD 1 05.10.2020",
      "active": 1,
      "inputmandatory": 0,
      "inputexplain": null,
      "isSelfDeclarationUsed": 1
    },
    {
      "id": 2,
      "title": "Krankheit bis zu 3 Tagen - mögliche Infektion mit SARS-CoV2",
      "text":
          "<strong>Formblatt 2A/3A: Erklärung  für die Wiederaufnahme in die Schulgemeinschaft nach einer bis zu 3-tägigen Abwesenheit <u>aus gesundheitlichen Gründen, die in Verbindung mit einer möglichen SARS-CoV-2- Infektion stehen</u></strong><br><br>\r\n\r\nDer/die Unterfertigte ERKLÄRT<br>\r\n<ul>\r\n<li>im Bewusstsein aller zivil- und strafrechtlichen Folgen im Falle einer Falscherklärung und im vollen Bewusstsein der Wichtigkeit einer uneingeschränkten Befolgung der Maßnahmen zur Verhinderung der Ausbreitung der SARS-CoV-2-Infektion und folglich zum Schutz der kollektiven Gesundheit\r\n<li>in Bezug auf die obige Abwesenheit\r\n<li>und zum Zwecke der Wiederaufnahme in die Schulgemeinschaft, den untenstehenden Kinderarzt der freien Wahl/den Allgemeinmediziner kontaktiert und die erhaltenen Hinweise befolgt zu haben.\r\n</ul>",
      "version": "MOD 2A/3A 05.10.2020",
      "active": 1,
      "inputmandatory": 1,
      "inputexplain": "Name Arzt/Ärztin",
      "isSelfDeclarationUsed": 1
    },
    {
      "id": 3,
      "title": "Krankheit bis zu 3 Tagen - nicht im Zusammenhang mit SARS-CoV2",
      "text":
          "<strong>Formblatt 2B/3B: Erklärung des Elternteils/Vormundes für die Wiederaufnahme in die Schulgemeinschaft nach einer bis zu 3-tägigen Abwesenheit <u> aus gesundheitlichen Gründen, die NICHT in Verbindung mit einer möglichen SARS-CoV-2- Infektion stehen</u></strong><br>\r\nDer/die Unterfertigte ERKLÄRT<br>\r\n<ul>\r\n<li>im Bewusstsein aller zivil- und strafrechtlichen Folgen im Falle einer Falscherklärung und im vollen Bewusstsein der Wichtigkeit einer uneingeschränkten Befolgung der Maßnahmen zur Verhinderung der Ausbreitung der SARS-CoV-2-Infektion und folglich zum Schutz der kollektiven Gesundheit\r\n\r\n<li>in Bezug auf obige Abwesenheit\r\n\r\n<li>und zum Zwecke der Wiederaufnahme in den Kindergarten/in die Schulgemeinschaft, dass die Abwesenheit nicht durch Symptome begründet war, die auf eine mögliche Infektion mit SARS-CoV-2 hinweisen, sondern dass die Abwesenheit durch eine Krankheit begründet war, die keinen Covid-19-Verdacht aufkommen lässt.\r\n</ul>",
      "version": "MOD 2B/3B 05.10.2020",
      "active": 1,
      "inputmandatory": 0,
      "inputexplain": null,
      "isSelfDeclarationUsed": 1
    },
    {
      "id": 4,
      "title": "Krankheit ab 4 Tagen",
      "text":
          "<strong>Formblatt 4: Abwesenheit von mehr als 3 Tagen aus gesundheitlichen Gründen</strong>\r\n\r\nDer/die Unterfertigte ERKLÄRT,\r\n<ul>\r\n<li>im Bewusstsein aller zivil- und strafrechtlichen Folgen im Falle einer Falscherklärung und im vollen Bewusstsein der Wichtigkeit einer uneingeschränkten Befolgung der Maßnahmen zur Verhinderung der Ausbreitung der SARS-CoV-2-Infektion und folglich zum Schutz der kollektiven Gesundheit\r\n<li>in Bezug auf obige Abwesenheit\r\nund zum Zwecke der Wiederaufnahme in die Schulgemeinschaft\r\n<li>der Schule eine schriftliche Bestätigung eines Kinderarztes freier Wahl/eines Arztes für Allgemeinmedizin mit Datum und Stempel/Unterschrift des Arztes/der Ärztin in digitaler oder in Papierform übermittelt zu haben, aus der hervorgeht, dass der Schüler/die Schülerin wieder in die Schule zurückkehren kann, da die diagnostisch-therapeutischen und präventiven Maßnahmen für Covid-19, wie von den Bestimmungen auf Staats- und Landesebene vorgesehen, vorgenommen wurden.\r\n</ul>",
      "version": "MOD 4 05.10.2020",
      "active": 1,
      "inputmandatory": 1,
      "inputexplain": "Name Arzt/Ärztin",
      "isSelfDeclarationUsed": 1
    }
  ],
  "selfDeclarationsActiveList": [
    {
      "id": 1,
      "title": "Familiäre Gründe",
      "text":
          "<strong>Erklärung für die Wiederaufnahme in die Schulgemeinschaft nach Abwesenheit aus NICHT gesundheitlichen Gründen</strong><br>\r\nDer/die Unterfertigte ERKLÄRT im Bewusstsein aller zivil- und strafrechtlichen Folgen im Falle einer Falscherklärung und im vollen Bewusstsein der Wichtigkeit einer uneingeschränkten Befolgung der Maßnahmen zur Verhinderung der Ausbreitung der SARS-CoV-2-Infektion und folglich zum Schutz der kollektiven Gesundheit, dass diese Abwesenheit <strong>nicht im Zusammenhang mit Gesundheitsproblemen steht, sondern auf andere Gründe zurückzuführen ist.</strong>\r\n",
      "inputmandatory": 0,
      "inputexplain": null
    },
    {
      "id": 2,
      "title": "Krankheit bis zu 3 Tagen - mögliche Infektion mit SARS-CoV2",
      "text":
          "<strong>Formblatt 2A/3A: Erklärung  für die Wiederaufnahme in die Schulgemeinschaft nach einer bis zu 3-tägigen Abwesenheit <u>aus gesundheitlichen Gründen, die in Verbindung mit einer möglichen SARS-CoV-2- Infektion stehen</u></strong><br><br>\r\n\r\nDer/die Unterfertigte ERKLÄRT<br>\r\n<ul>\r\n<li>im Bewusstsein aller zivil- und strafrechtlichen Folgen im Falle einer Falscherklärung und im vollen Bewusstsein der Wichtigkeit einer uneingeschränkten Befolgung der Maßnahmen zur Verhinderung der Ausbreitung der SARS-CoV-2-Infektion und folglich zum Schutz der kollektiven Gesundheit\r\n<li>in Bezug auf die obige Abwesenheit\r\n<li>und zum Zwecke der Wiederaufnahme in die Schulgemeinschaft, den untenstehenden Kinderarzt der freien Wahl/den Allgemeinmediziner kontaktiert und die erhaltenen Hinweise befolgt zu haben.\r\n</ul>",
      "inputmandatory": 1,
      "inputexplain": "Name Arzt/Ärztin"
    },
    {
      "id": 3,
      "title": "Krankheit bis zu 3 Tagen - nicht im Zusammenhang mit SARS-CoV2",
      "text":
          "<strong>Formblatt 2B/3B: Erklärung des Elternteils/Vormundes für die Wiederaufnahme in die Schulgemeinschaft nach einer bis zu 3-tägigen Abwesenheit <u> aus gesundheitlichen Gründen, die NICHT in Verbindung mit einer möglichen SARS-CoV-2- Infektion stehen</u></strong><br>\r\nDer/die Unterfertigte ERKLÄRT<br>\r\n<ul>\r\n<li>im Bewusstsein aller zivil- und strafrechtlichen Folgen im Falle einer Falscherklärung und im vollen Bewusstsein der Wichtigkeit einer uneingeschränkten Befolgung der Maßnahmen zur Verhinderung der Ausbreitung der SARS-CoV-2-Infektion und folglich zum Schutz der kollektiven Gesundheit\r\n\r\n<li>in Bezug auf obige Abwesenheit\r\n\r\n<li>und zum Zwecke der Wiederaufnahme in den Kindergarten/in die Schulgemeinschaft, dass die Abwesenheit nicht durch Symptome begründet war, die auf eine mögliche Infektion mit SARS-CoV-2 hinweisen, sondern dass die Abwesenheit durch eine Krankheit begründet war, die keinen Covid-19-Verdacht aufkommen lässt.\r\n</ul>",
      "inputmandatory": 0,
      "inputexplain": null
    },
    {
      "id": 4,
      "title": "Krankheit ab 4 Tagen",
      "text":
          "<strong>Formblatt 4: Abwesenheit von mehr als 3 Tagen aus gesundheitlichen Gründen</strong>\r\n\r\nDer/die Unterfertigte ERKLÄRT,\r\n<ul>\r\n<li>im Bewusstsein aller zivil- und strafrechtlichen Folgen im Falle einer Falscherklärung und im vollen Bewusstsein der Wichtigkeit einer uneingeschränkten Befolgung der Maßnahmen zur Verhinderung der Ausbreitung der SARS-CoV-2-Infektion und folglich zum Schutz der kollektiven Gesundheit\r\n<li>in Bezug auf obige Abwesenheit\r\nund zum Zwecke der Wiederaufnahme in die Schulgemeinschaft\r\n<li>der Schule eine schriftliche Bestätigung eines Kinderarztes freier Wahl/eines Arztes für Allgemeinmedizin mit Datum und Stempel/Unterschrift des Arztes/der Ärztin in digitaler oder in Papierform übermittelt zu haben, aus der hervorgeht, dass der Schüler/die Schülerin wieder in die Schule zurückkehren kann, da die diagnostisch-therapeutischen und präventiven Maßnahmen für Covid-19, wie von den Bestimmungen auf Staats- und Landesebene vorgesehen, vorgenommen wurden.\r\n</ul>",
      "inputmandatory": 1,
      "inputexplain": "Name Arzt/Ärztin"
    }
  ],
  "isAbsencesSelfDeclarationActive": true,
  "isAbsencesSelfDeclarationMandatory": true
};

void main() {
  final store = Store<AppState, AppStateBuilder, AppActions>(
    appReducerBuilder.build(),
    AppState(),
    AppActions(),
    middleware: middleware(includeErrorMiddleware: false),
  );
  test('parse absences', () {
    // should not throw
    store.actions.absencesActions.loaded(absencesJson);
    store.actions.absencesActions.loaded(json.encode(absencesJson));
    store.actions.absencesActions.loaded(json.decode(json.encode(absencesJson)));
  });
}
