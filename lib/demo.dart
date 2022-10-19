// ignore_for_file:implicit_dynamic_list_literal,implicit_dynamic_map_literal

import 'package:intl/intl.dart';

dynamic getDemoResponse(String url, dynamic args) {
  dynamic response = _demoRequestsAndResponses[url];
  if (response is Function) {
    response = response(args);
  }
  return response;
}

final _demoRequestsAndResponses = <String, dynamic>{
  "api/student/subject_detail":
      "{\"grades\":[{\"id\":1202,\"grade\":\"9.00\",\"weight\":100,\"typeId\":7,\"typeName\":\"Sonstige Bewertung\",\"name\":\"Ausdauertest\",\"description\":\"\",\"date\":\"2022-10-11\",\"cancelled\":0,\"created\":\"Von Gernot Wachtler am 17.10.2022 eingetragen\",\"subjectId\":17,\"classId\":60,\"studentId\":6619,\"createdTimeStamp\":\"2022-10-17 12:34:12\",\"cancelledTimeStamp\":null,\"competences\":[]}],\"absences\":[],\"observations\":[{\"id\":980,\"note\":\"\",\"date\":\"2022-10-11\",\"typeId\":19,\"typeName\":\"Plus\",\"cancelled\":0,\"created\":\"Von Gernot Wachtler am 17.10.2022 eingetragen\",\"subjectId\":17,\"classId\":60,\"studentId\":6619,\"hidden\":0}],\"averageSemester\":0,\"averageYear\":0,\"showGrades\":2,\"showGradesStudentView\":2,\"isClassHasNoGrades\":false,\"countCompetences\":0,\"countDescriptions\":0,\"countObservations\":1}",
  "api/student/dashboard/save_reminder": {
    "id": -1,
    "title": "test entry",
    "subtitle": "demo value",
    "warning": false,
    "deleteable": false,
    "type": "homework",
  },
  "api/student/dashboard/toggle_reminder": {"success": true},
  "api/student/dashboard/dashboard": [
    {"items": [], "date": "2022-10-19"},
    {
      "items": [
        {
          "id": 1338,
          "category": 1338,
          "type": "gradeGroup",
          "title": "Hausaufgabe Schriftlich",
          "subtitle":
              "Completare gli esercizi iniziati in classe; studiare con cura gli appunti.",
          "label": "Italienisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-20 07:45:00",
          "deadlineFormatted": "Donnerstag, 20.10.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 1,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-10-20"
    },
    {
      "items": [
        {
          "id": 794,
          "category": 794,
          "type": "gradeGroup",
          "title": "Mündliche Prüfung",
          "subtitle":
              "Historismus, Nazarener, Biedermeier, Realismus, Impressionismus",
          "label": "Kunstgeschichte",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": true,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-21 11:10:00",
          "deadlineFormatted": "Freitag, 21.10.2022, 11:10",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 5,
          "done": 6619,
          "gradeGroupSubmissions": null
        },
        {
          "id": 942,
          "category": 942,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "1. Schularbeit",
          "label": "Griechisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-21 07:45:00",
          "deadlineFormatted": "Freitag, 21.10.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-10-21"
    },
    {"items": [], "date": "2022-10-22"},
    {"items": [], "date": "2022-10-23"},
    {
      "items": [
        {
          "id": 1329,
          "category": 1329,
          "type": "gradeGroup",
          "title": "Hausaufgabe Mündlich",
          "subtitle":
              "Lernen der Inhalte zum 1. Weltkrieg (bis inklusive Kriegsjahr 1916)",
          "label": "Geschichte",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-24 11:10:00",
          "deadlineFormatted": "Montag, 24.10.2022, 11:10",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 3,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-10-24"
    },
    {
      "items": [
        {
          "id": 611,
          "category": 611,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "1. Schularbeit",
          "label": "Deutsch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-25 07:45:00",
          "deadlineFormatted": "Dienstag, 25.10.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        },
        {
          "id": 1353,
          "category": 1353,
          "type": "gradeGroup",
          "title": "Hausaufgabe Schriftlich",
          "subtitle": "Arbeitsblatt zu den Proteinen bearbeiten",
          "label": "Naturwissenschaften",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-25 09:20:00",
          "deadlineFormatted": "Dienstag, 25.10.2022, 09:20",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 1,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-10-25"
    },
    {
      "items": [
        {
          "id": 943,
          "category": 943,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "1. Testarbeit",
          "label": "Latein",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-26 09:20:00",
          "deadlineFormatted": "Mittwoch, 26.10.2022, 09:20",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-10-26"
    },
    {
      "items": [
        {
          "id": 651,
          "category": 651,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "Compito in classe",
          "label": "Italienisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-27 07:45:00",
          "deadlineFormatted": "Donnerstag, 27.10.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-10-27"
    },
    {
      "items": [
        {
          "id": 932,
          "category": 932,
          "type": "gradeGroup",
          "title": "Mündliche Prüfung",
          "subtitle":
              "Historismus, Nazarener, Biedermeier, Realismus, Impressionismus",
          "label": "Kunstgeschichte",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-28 11:10:00",
          "deadlineFormatted": "Freitag, 28.10.2022, 11:10",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 5,
          "done": null,
          "gradeGroupSubmissions": null
        },
        {
          "id": 1273,
          "category": 1273,
          "type": "gradeGroup",
          "title": "Hausaufgabe Schriftlich",
          "subtitle": "Fertigstellen Nr. 24.13; 24.16",
          "label": "Physik",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-10-28 15:15:00",
          "deadlineFormatted": "Freitag, 28.10.2022, 15:15",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 1,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-10-28"
    },
    {"items": [], "date": "2022-10-29"},
    {"items": [], "date": "2022-10-30"},
    {"items": [], "date": "2022-10-31"},
    {"items": [], "date": "2022-11-01"},
    {"items": [], "date": "2022-11-02"},
    {"items": [], "date": "2022-11-03"},
    {"items": [], "date": "2022-11-04"},
    {"items": [], "date": "2022-11-05"},
    {"items": [], "date": "2022-11-06"},
    {"items": [], "date": "2022-11-07"},
    {
      "items": [
        {
          "id": 1308,
          "category": 1308,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "2. Test",
          "label": "Naturwissenschaften",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-08 09:20:00",
          "deadlineFormatted": "Dienstag, 08.11.2022, 09:20",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-08"
    },
    {"items": [], "date": "2022-11-09"},
    {
      "items": [
        {
          "id": 1153,
          "category": 1153,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "Leopardi e Manzoni",
          "label": "Italienisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-10 07:45:00",
          "deadlineFormatted": "Donnerstag, 10.11.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-10"
    },
    {
      "items": [
        {
          "id": 944,
          "category": 944,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "1. Testarbeit",
          "label": "Griechisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-11 07:45:00",
          "deadlineFormatted": "Freitag, 11.11.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-11"
    },
    {"items": [], "date": "2022-11-12"},
    {"items": [], "date": "2022-11-13"},
    {
      "items": [
        {
          "id": 441,
          "category": 441,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "Schularbeit",
          "label": "Englisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-14 07:45:00",
          "deadlineFormatted": "Montag, 14.11.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        },
        {
          "id": 1276,
          "category": 1276,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "2. Test in Geschichte",
          "label": "Geschichte",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-14 11:10:00",
          "deadlineFormatted": "Montag, 14.11.2022, 11:10",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-14"
    },
    {
      "items": [
        {
          "id": 612,
          "category": 612,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "Testarbeit",
          "label": "Deutsch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-15 07:45:00",
          "deadlineFormatted": "Dienstag, 15.11.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-15"
    },
    {"items": [], "date": "2022-11-16"},
    {"items": [], "date": "2022-11-17"},
    {"items": [], "date": "2022-11-18"},
    {"items": [], "date": "2022-11-19"},
    {"items": [], "date": "2022-11-20"},
    {
      "items": [
        {
          "id": 506,
          "category": 506,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "Schularbeit",
          "label": "Mathematik",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-21 09:20:00",
          "deadlineFormatted": "Montag, 21.11.2022, 09:20",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-21"
    },
    {"items": [], "date": "2022-11-22"},
    {
      "items": [
        {
          "id": 945,
          "category": 945,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "2. Schularbeit",
          "label": "Latein",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-23 09:20:00",
          "deadlineFormatted": "Mittwoch, 23.11.2022, 09:20",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-23"
    },
    {"items": [], "date": "2022-11-24"},
    {"items": [], "date": "2022-11-25"},
    {"items": [], "date": "2022-11-26"},
    {"items": [], "date": "2022-11-27"},
    {
      "items": [
        {
          "id": 1039,
          "category": 1039,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "Test",
          "label": "Physik",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-28 09:20:00",
          "deadlineFormatted": "Montag, 28.11.2022, 09:20",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-28"
    },
    {
      "items": [
        {
          "id": 613,
          "category": 613,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "2. Schularbeit",
          "label": "Deutsch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-11-29 07:45:00",
          "deadlineFormatted": "Dienstag, 29.11.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-11-29"
    },
    {"items": [], "date": "2022-11-30"},
    {"items": [], "date": "2022-12-01"},
    {
      "items": [
        {
          "id": 946,
          "category": 946,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "2. Schularbeit",
          "label": "Griechisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-12-02 07:45:00",
          "deadlineFormatted": "Freitag, 02.12.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-12-02"
    },
    {"items": [], "date": "2022-12-03"},
    {"items": [], "date": "2022-12-04"},
    {"items": [], "date": "2022-12-05"},
    {
      "items": [
        {
          "id": 1156,
          "category": 1156,
          "type": "gradeGroup",
          "title": "Mündliche Prüfung",
          "subtitle": "inizio interrogazioni",
          "label": "Italienisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-12-06 11:10:00",
          "deadlineFormatted": "Dienstag, 06.12.2022, 11:10",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 5,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-12-06"
    },
    {
      "items": [
        {
          "id": 846,
          "category": 846,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "2. Test",
          "label": "Philosophie",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-12-07 07:45:00",
          "deadlineFormatted": "Mittwoch, 07.12.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-12-07"
    },
    {"items": [], "date": "2022-12-08"},
    {"items": [], "date": "2022-12-09"},
    {"items": [], "date": "2022-12-10"},
    {"items": [], "date": "2022-12-11"},
    {"items": [], "date": "2022-12-12"},
    {"items": [], "date": "2022-12-13"},
    {
      "items": [
        {
          "id": 947,
          "category": 947,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "2. Testarbeit",
          "label": "Latein",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-12-14 09:20:00",
          "deadlineFormatted": "Mittwoch, 14.12.2022, 09:20",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-12-14"
    },
    {
      "items": [
        {
          "id": 652,
          "category": 652,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "Compito in classe",
          "label": "Italienisch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-12-15 07:45:00",
          "deadlineFormatted": "Donnerstag, 15.12.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-12-15"
    },
    {
      "items": [
        {
          "id": 795,
          "category": 795,
          "type": "gradeGroup",
          "title": "Testarbeit",
          "subtitle": "Jugendstil, Wegbereiter der Moderne, Expressionismus",
          "label": "Kunstgeschichte",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-12-16 11:10:00",
          "deadlineFormatted": "Freitag, 16.12.2022, 11:10",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-12-16"
    },
    {"items": [], "date": "2022-12-17"},
    {"items": [], "date": "2022-12-18"},
    {
      "items": [
        {
          "id": 508,
          "category": 508,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "Schularbeit",
          "label": "Mathematik",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-12-19 09:20:00",
          "deadlineFormatted": "Montag, 19.12.2022, 09:20",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-12-19"
    },
    {
      "items": [
        {
          "id": 614,
          "category": 614,
          "type": "gradeGroup",
          "title": "Schularbeit",
          "subtitle": "3. Schularbeit",
          "label": "Deutsch",
          "warning": false,
          "0": true,
          "checkable": true,
          "checked": false,
          "online": 0,
          "submission": null,
          "deadline": "2022-12-20 07:45:00",
          "deadlineFormatted": "Dienstag, 20.12.2022, 07:45",
          "deadlineStart": null,
          "deadlineStartFormatted": "Donnerstag, 01.01.1970, 01:00",
          "submissionAllowed": 0,
          "submissionResigned": false,
          "submissionIsNowInOvertime": false,
          "homework": 0,
          "done": null,
          "gradeGroupSubmissions": null
        }
      ],
      "date": "2022-12-20"
    }
  ],
  "api/notification/unread": [],
  "api/student/all_subjects": {
    "subjects": [
      {
        "subject": {"id": 17, "name": "Bewegung und Sport"},
        "absences": 0,
        "grades": [
          {
            "grade": "9.00",
            "weight": 100,
            "date": "2022-10-11",
            "type": "Sonstige Bewertung",
            "typeId": 7,
            "studentId": 6619,
            "cancelled": 0,
            "subjectId": 17,
            "semester": 1,
            "createdTimeStamp": "2022-10-17 12:34:12",
            "cancelledTimeStamp": null,
            "description": ""
          }
        ],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 17,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 1
      },
      {
        "subject": {"id": 6, "name": "Deutsch"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 6,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 8, "name": "Englisch"},
        "absences": 0,
        "grades": [
          {
            "grade": "9.50",
            "weight": 100,
            "date": "2022-10-03",
            "type": "Schularbeit",
            "typeId": 3,
            "studentId": 6619,
            "cancelled": 0,
            "subjectId": 8,
            "semester": 1,
            "createdTimeStamp": "2022-10-12 23:49:08",
            "cancelledTimeStamp": null,
            "description": ""
          }
        ],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 8,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 24, "name": "FÜ"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 24,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 10, "name": "Geschichte"},
        "absences": 0,
        "grades": [
          {
            "grade": "9.75",
            "weight": 50,
            "date": "2022-10-07",
            "type": "Testarbeit",
            "typeId": 2,
            "studentId": 6619,
            "cancelled": 0,
            "subjectId": 10,
            "semester": 1,
            "createdTimeStamp": "2022-10-18 12:09:50",
            "cancelledTimeStamp": null,
            "description": ""
          }
        ],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 10,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 106, "name": "Gesellschaftliche Bildung"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 106,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 20, "name": "Griechisch"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 20,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 7, "name": "Italienisch"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 7,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 103, "name": "Kunstgeschichte"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 103,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 19, "name": "Latein"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 19,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 13, "name": "Mathematik"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 13,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 22, "name": "Naturwissenschaften"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 22,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 21, "name": "Philosophie"},
        "absences": 0,
        "grades": [
          {
            "grade": "8.75",
            "weight": 100,
            "date": "2022-10-12",
            "type": "Testarbeit",
            "typeId": 2,
            "studentId": 6619,
            "cancelled": 0,
            "subjectId": 21,
            "semester": 1,
            "createdTimeStamp": "2022-10-13 13:35:35",
            "cancelledTimeStamp": null,
            "description": ""
          }
        ],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 21,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 14, "name": "Physik"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 14,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 5, "name": "Religion"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 5,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      },
      {
        "subject": {"id": 29, "name": "Z-Klassenlehrerstunde"},
        "absences": 0,
        "grades": [],
        "averageSemester": 0,
        "averageYear": 0,
        "subjectId": 29,
        "student": {"id": 6619, "firstName": "Michael", "lastName": "Debertol"},
        "countCompetences": 0,
        "countDescriptions": 0,
        "countObservations": 0
      }
    ],
    "averageSemester": "-",
    "averageYear": "-",
    "negativeSubjectsSemester": "-",
    "negativeSubjectsYear": "-",
    "showGrades": 2
  },
  "api/student/dashboard/absences": {
    "absences": [],
    "futureAbsences": [],
    "canEdit": true,
    "statistics": {
      "counter": 0,
      "counterForSchool": 0,
      "percentage": 0,
      "justified": 0,
      "notJustified": 0,
      "delayed": 0
    },
    "selfDeclarationsList": [
      {
        "id": 14,
        "title": "SITUATION 0: Nichtgesundheitliche Gründe",
        "text":
            "<p><strong>Erkl&auml;rung f&uuml;r die Wiederaufnahme in die Schulgemeinschaft bei Abwesenheit aus NICHT gesundheitlichen Gr&uuml;nden</strong></p>\n<p>&nbsp;</p>\n<p>Der/die Unterfertigte <strong>erkl&auml;rt</strong> zum Zweck der Wiederaufnahme in die Schulgemeinschaft im Sinne der diesbez&uuml;glich geltenden Gesetze und im Bewusstsein, dass jede Falscherkl&auml;rung nach dem Strafgesetzbuch und den einschl&auml;gigen Gesetzen (gem&auml;&szlig; Art. 46 des DPR Nr. 445/2000) bestraft wird, dass die Abwesenheit einem <strong>nichtgesundheitlichen Grund </strong>geschuldet war.</p>",
        "version": "VER-2021-10-18",
        "active": 0,
        "inputmandatory": 0,
        "inputexplain": null
      },
      {
        "id": 19,
        "title":
            "SITUATION 1: Krankheit bis zu 3 Schultage - nicht im Zusammenhang mit SARS CoV2",
        "text":
            "<p><strong>Abwesenheit aus gesundheitlichen Gr&uuml;nden von drei Tagen oder weniger, die NICHT im Zusammenhang mit einer m&ouml;glichen SARS-CoV-2-Infektion steht (kein &auml;rztliches Attest erforderlich) </strong></p>\n<p>&nbsp;</p>\n<p>Der/die Unterfertigte <strong>erkl&auml;rt</strong> zum Zweck der Wiederaufnahme in die Schulgemeinschaft im Sinne der diesbez&uuml;glich geltenden Gesetze und im Bewusstsein, dass jede Falscherkl&auml;rung nach dem Strafgesetzbuch und den einschl&auml;gigen Gesetzen (gem&auml;&szlig; Art. 46 des DPR Nr. 445/2000) bestraft wird, dass die <strong>krankheitsbedingte</strong> Abwesenheit <strong>nicht mit Symptomen </strong><strong>einer m&ouml;glichen SARS-CoV-2-Infektion</strong> zusammenh&auml;ngt, sondern mit anderen nicht verd&auml;chtigen klinischen Zust&auml;nden.</p>",
        "version": "VER-2021-10-18",
        "active": 0,
        "inputmandatory": 0,
        "inputexplain": null
      },
      {
        "id": 20,
        "title":
            "SITUATION 2: Krankheit bis zu 3 Schultagen - mögliche Infektion mit SARS-CoV2",
        "text":
            "<p><strong>Erkl&auml;rung f&uuml;r die Wiederaufnahme in die Schulgemeinschaft nach einer bis zu 3-t&auml;gigen Abwesenheit aus gesundheitlichen Gr&uuml;nden, die m&ouml;glicherweise in Verbindung mit einer SARS-CoV-2-Infektion stehen (kein &auml;rztliches Zeugnis erforderlich)</strong></p>\n<p>&nbsp;</p>\n<p>Der/die Unterfertigte <strong>erkl&auml;rt </strong>zum Zweck der Wiederaufnahme in die Schulgemeinschaft im Sinne der diesbez&uuml;glich geltenden Gesetze und im Bewusstsein, dass jede Falscherkl&auml;rung nach dem Strafgesetzbuch und den einschl&auml;gigen Gesetzen (gem&auml;&szlig; Art. 46 des DPR Nr. 445/2000) bestraft wird, dass <strong>(a)</strong> die unten angef&uuml;hrte &Auml;rztin / der unten angef&uuml;hrte <strong>Arzt</strong> <strong>konsultiert</strong> wurde, <strong>(b)</strong> die Erkrankung laut deren / dessen Einsch&auml;tzung <strong>nicht auf eine Infektion mit Sars-CoV-2</strong> zur&uuml;ckzuf&uuml;hren ist.</p>",
        "version": "VER-2021-10-18",
        "active": 0,
        "inputmandatory": 1,
        "inputexplain": "Name der Ärztin / des Arztes"
      },
      {
        "id": 21,
        "title":
            "SITUATION 3: Krankheit mehr als 3 Schultagen - mögliche Infektion mit SARS-CoV2",
        "text":
            "<p><strong>Erkl&auml;rung f&uuml;r die Wiederaufnahme in die Schulgemeinschaft nach Abwesenheiten von mehr als 3 Schultagen aus gesundheitlichen Gr&uuml;nden, die auch auf eine m&ouml;gliche SARS-CoV-2-Infektion zur&uuml;ckzuf&uuml;hren sind</strong></p>\n<p>&nbsp;</p>\n<p>Der/die Unterfertigte <strong>erkl&auml;rt</strong> zum Zweck der Wiederaufnahme in die Schulgemeinschaft im Sinne der diesbez&uuml;glich geltenden Gesetze und im Bewusstsein, dass jede Falscherkl&auml;rung nach dem Strafgesetzbuch und den einschl&auml;gigen Gesetzen (gem&auml;&szlig; Art. 46 des DPR Nr. 445/2000) bestraft wird, dass die unten angef&uuml;hrte <strong>&Auml;rztin</strong> / der unten angef&uuml;hrte <strong>Arzt konsultiert</strong> und deren / dessen <strong>Anweisungen befolgt</strong> wurde. Zum Nachweis dieser Erkl&auml;rung wird dem Schulsekretariat (<a href=\"mailto:schule@vinzentinum.it\">schule@vinzentinum.it</a>) die <strong>&auml;rztliche Best&auml;tigung</strong> zugemailt.</p>",
        "version": "VER-2021-10-11",
        "active": 0,
        "inputmandatory": 0,
        "inputexplain": null
      },
      {
        "id": 22,
        "title": "SITUATION 4: Ende der Quarantäne",
        "text":
            "<p>Der/die Unterfertigte <strong>beantragt</strong> die Wiederaufnahme in die schulische Einrichtung und &uuml;bermittelt zu diesem Zweck dem Schulsekretariat des Vinzentinums (<a href=\"mailto:schule@vinzentinum.it\">schule@vinzentinum.it</a>) die schriftliche <strong>Mitteilung</strong> der epidemiologischen &Uuml;berwachungseinheit &uuml;ber die <strong>Beendigung der Quarant&auml;ne</strong>.</p>",
        "version": "VER-2021-10-18",
        "active": 0,
        "inputmandatory": 0,
        "inputexplain": null
      },
      {
        "id": 23,
        "title": "SITUATION 5: Ende der Isolation",
        "text":
            "<p>Der/die Unterfertigte <strong>beantragt</strong> die Wiederaufnahme in die schulische Einrichtung und &uuml;bermittelt zu diesem Zweck dem Schulsekretariat des Vinzentinums (<a href=\"mailto:schule@vinzentinum.it\">schule@vinzentinum.it</a>) die schriftliche <strong>Best&auml;tigung der Negativit&auml;t</strong>, die von der epidemiologischen &Uuml;berwachungseinheit ausgestellt wurde.</p>",
        "version": "VER-2021-10-18",
        "active": 0,
        "inputmandatory": 0,
        "inputexplain": null
      }
    ],
    "selfDeclarationsActiveList": [],
    "isAbsencesSelfDeclarationActive": false,
    "isAbsencesSelfDeclarationMandatory": true
  },
  "api/calendar/student": (dynamic args) {
    final dateFormat = DateFormat("yyyy-MM-dd");

    final date = DateTime.parse(args["startDate"] as String);
    final dates = [
      dateFormat.format(date),
      dateFormat.format(date.add(const Duration(days: 1))),
      dateFormat.format(date.add(const Duration(days: 2))),
      dateFormat.format(date.add(const Duration(days: 3))),
      dateFormat.format(date.add(const Duration(days: 4)))
    ];

    return {
      dates[0]: {
        "1": {
          "1": {
            "1": {
              "isLesson": 1,
              "lesson": {
                "id": 3539,
                "date": dates[0],
                "hour": 1,
                "toHour": 2,
                "timeStart": 24300,
                "timeEnd": 27000,
                "timeToEnd": 29700,
                "timeStartObject": {
                  "h": "07",
                  "m": "45",
                  "ts": 24300,
                  "text": "07:45",
                  "html": "07<sup>45</sup>"
                },
                "timeEndObject": {
                  "h": "08",
                  "m": "30",
                  "ts": 27000,
                  "text": "08:30",
                  "html": "08<sup>30</sup>"
                },
                "timeToEndObject": {
                  "h": "09",
                  "m": "15",
                  "ts": 29700,
                  "text": "09:15",
                  "html": "09<sup>15</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {
                    "id": 5971,
                    "firstName": "Barbara",
                    "lastName": "Mitterrutzner"
                  }
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 8,
                  "name": "Englisch",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1672,
                    "name":
                        "Writing conference formal email, post-it-note feedback about book so far, workbook exercises Unit 1, worksheet: Commonly mispronounced words",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [
                  {"id": 13, "name": "8"}
                ],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3540,
                    "date": dates[0],
                    "hour": 2,
                    "toHour": 2,
                    "timeStart": 27000,
                    "timeEnd": 29700,
                    "timeToEnd": 29700,
                    "timeStartObject": {
                      "h": "08",
                      "m": "30",
                      "ts": 27000,
                      "text": "08:30",
                      "html": "08<sup>30</sup>"
                    },
                    "timeEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeToEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {
                        "id": 5971,
                        "firstName": "Barbara",
                        "lastName": "Mitterrutzner"
                      }
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 8,
                      "name": "Englisch",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [
                      {"id": 13, "name": "8"}
                    ],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 1,
              "linkedHoursCount": 1
            },
            "3": {
              "isLesson": 1,
              "lesson": {
                "id": 2813,
                "date": dates[0],
                "hour": 3,
                "toHour": 4,
                "timeStart": 30000,
                "timeEnd": 32700,
                "timeToEnd": 35700,
                "timeStartObject": {
                  "h": "09",
                  "m": "20",
                  "ts": 30000,
                  "text": "09:20",
                  "html": "09<sup>20</sup>"
                },
                "timeEndObject": {
                  "h": "10",
                  "m": "05",
                  "ts": 32700,
                  "text": "10:05",
                  "html": "10<sup>05</sup>"
                },
                "timeToEndObject": {
                  "h": "10",
                  "m": "55",
                  "ts": 35700,
                  "text": "10:55",
                  "html": "10<sup>55</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1643, "firstName": "Manuel", "lastName": "Winkler"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 14,
                  "name": "Physik",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [
                  {
                    "id": 1038,
                    "name": "1. Test 1. Semester",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": "2022-10-17 09:20:00",
                    "deadlineOvertime": null,
                    "hasGrades": false,
                    "hasGradeGroupSubmissions": false,
                    "typeId": 2,
                    "typeName": "Testarbeit",
                    "gradeGroupSubmissions": [],
                    "gradeGroupStudents": [],
                    "gradeGroupStudentsPercentage": 100
                  }
                ],
                "lessonContents": [
                  {
                    "id": 1642,
                    "name": "Test",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 2814,
                    "date": dates[0],
                    "hour": 4,
                    "toHour": 4,
                    "timeStart": 33000,
                    "timeEnd": 35700,
                    "timeToEnd": 35700,
                    "timeStartObject": {
                      "h": "10",
                      "m": "10",
                      "ts": 33000,
                      "text": "10:10",
                      "html": "10<sup>10</sup>"
                    },
                    "timeEndObject": {
                      "h": "10",
                      "m": "55",
                      "ts": 35700,
                      "text": "10:55",
                      "html": "10<sup>55</sup>"
                    },
                    "timeToEndObject": {
                      "h": "10",
                      "m": "55",
                      "ts": 35700,
                      "text": "10:55",
                      "html": "10<sup>55</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {"id": 1643, "firstName": "Manuel", "lastName": "Winkler"}
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 14,
                      "name": "Physik",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 3,
              "linkedHoursCount": 1
            },
            "5": {
              "isLesson": 1,
              "lesson": {
                "id": 3530,
                "date": dates[0],
                "hour": 5,
                "toHour": 6,
                "timeStart": 36600,
                "timeEnd": 39300,
                "timeToEnd": 42300,
                "timeStartObject": {
                  "h": "11",
                  "m": "10",
                  "ts": 36600,
                  "text": "11:10",
                  "html": "11<sup>10</sup>"
                },
                "timeEndObject": {
                  "h": "11",
                  "m": "55",
                  "ts": 39300,
                  "text": "11:55",
                  "html": "11<sup>55</sup>"
                },
                "timeToEndObject": {
                  "h": "12",
                  "m": "45",
                  "ts": 42300,
                  "text": "12:45",
                  "html": "12<sup>45</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1628, "firstName": "Christof", "lastName": "Obkircher"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 10,
                  "name": "Geschichte",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1665,
                    "name":
                        "Der 1. Weltkrieg: das Epochenjahr 1917 (Kriegseintritt der USA, Oktoberrevolution in Russland), die Kriegswirtschaft (Arbeitsblatt, PPP)",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3531,
                    "date": dates[0],
                    "hour": 6,
                    "toHour": 6,
                    "timeStart": 39600,
                    "timeEnd": 42300,
                    "timeToEnd": 42300,
                    "timeStartObject": {
                      "h": "12",
                      "m": "00",
                      "ts": 39600,
                      "text": "12:00",
                      "html": "12<sup>00</sup>"
                    },
                    "timeEndObject": {
                      "h": "12",
                      "m": "45",
                      "ts": 42300,
                      "text": "12:45",
                      "html": "12<sup>45</sup>"
                    },
                    "timeToEndObject": {
                      "h": "12",
                      "m": "45",
                      "ts": 42300,
                      "text": "12:45",
                      "html": "12<sup>45</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {
                        "id": 1628,
                        "firstName": "Christof",
                        "lastName": "Obkircher"
                      }
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 10,
                      "name": "Geschichte",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 5,
              "linkedHoursCount": 1
            },
            "7": {
              "isLesson": 1,
              "lesson": {
                "id": 3566,
                "date": dates[0],
                "hour": 7,
                "toHour": 7,
                "timeStart": 42600,
                "timeEnd": 45300,
                "timeToEnd": 45300,
                "timeStartObject": {
                  "h": "12",
                  "m": "50",
                  "ts": 42600,
                  "text": "12:50",
                  "html": "12<sup>50</sup>"
                },
                "timeEndObject": {
                  "h": "13",
                  "m": "35",
                  "ts": 45300,
                  "text": "13:35",
                  "html": "13<sup>35</sup>"
                },
                "timeToEndObject": {
                  "h": "13",
                  "m": "35",
                  "ts": 45300,
                  "text": "13:35",
                  "html": "13<sup>35</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 3808, "firstName": "Konrad", "lastName": "Willeit"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 5,
                  "name": "Religion",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1692,
                    "name":
                        "Wiederholungen in Vorbereitung auf den Test am 20. Okt. 2022",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [
                  {"id": 13, "name": "8"}
                ],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 7,
              "linkedHoursCount": 0
            },
            "8": {
              "isLesson": 0,
              "lesson": null,
              "hour": 8,
              "linkedHoursCount": 0
            },
            "9": {
              "isLesson": 0,
              "lesson": null,
              "hour": 9,
              "linkedHoursCount": 0
            },
            "10": {
              "isLesson": 0,
              "lesson": null,
              "hour": 10,
              "linkedHoursCount": 0
            }
          }
        }
      },
      dates[1]: {
        "1": {
          "1": {
            "1": {
              "isLesson": 1,
              "lesson": {
                "id": 3459,
                "date": dates[1],
                "hour": 1,
                "toHour": 2,
                "timeStart": 24300,
                "timeEnd": 27000,
                "timeToEnd": 29700,
                "timeStartObject": {
                  "h": "07",
                  "m": "45",
                  "ts": 24300,
                  "text": "07:45",
                  "html": "07<sup>45</sup>"
                },
                "timeEndObject": {
                  "h": "08",
                  "m": "30",
                  "ts": 27000,
                  "text": "08:30",
                  "html": "08<sup>30</sup>"
                },
                "timeToEndObject": {
                  "h": "09",
                  "m": "15",
                  "ts": 29700,
                  "text": "09:15",
                  "html": "09<sup>15</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1628, "firstName": "Christof", "lastName": "Obkircher"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 6,
                  "name": "Deutsch",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1699,
                    "name":
                        "Der 1. Weltkrieg: die Oktoberrevolution, Friedensbemühungen und das Problem des Friedensschließens, das Ende des 1. Weltkrieges (Buch, Arbeitsblatt,  Lehrvideo, PPP)",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3460,
                    "date": dates[1],
                    "hour": 2,
                    "toHour": 2,
                    "timeStart": 27000,
                    "timeEnd": 29700,
                    "timeToEnd": 29700,
                    "timeStartObject": {
                      "h": "08",
                      "m": "30",
                      "ts": 27000,
                      "text": "08:30",
                      "html": "08<sup>30</sup>"
                    },
                    "timeEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeToEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {
                        "id": 1628,
                        "firstName": "Christof",
                        "lastName": "Obkircher"
                      }
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 6,
                      "name": "Deutsch",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 1,
              "linkedHoursCount": 1
            },
            "3": {
              "isLesson": 1,
              "lesson": {
                "id": 2735,
                "date": dates[1],
                "hour": 3,
                "toHour": 3,
                "timeStart": 30000,
                "timeEnd": 32700,
                "timeToEnd": 32700,
                "timeStartObject": {
                  "h": "09",
                  "m": "20",
                  "ts": 30000,
                  "text": "09:20",
                  "html": "09<sup>20</sup>"
                },
                "timeEndObject": {
                  "h": "10",
                  "m": "05",
                  "ts": 32700,
                  "text": "10:05",
                  "html": "10<sup>05</sup>"
                },
                "timeToEndObject": {
                  "h": "10",
                  "m": "05",
                  "ts": 32700,
                  "text": "10:05",
                  "html": "10<sup>05</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1639, "firstName": "Verena", "lastName": "Steinmair"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 22,
                  "name": "Naturwissenschaften",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [
                  {
                    "id": 1003,
                    "name": "1. Test (Wiederholung Grundwissen Chemie)",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": "2022-10-18 09:20:00",
                    "deadlineOvertime": null,
                    "hasGrades": false,
                    "hasGradeGroupSubmissions": false,
                    "typeId": 2,
                    "typeName": "Testarbeit",
                    "gradeGroupSubmissions": [],
                    "gradeGroupStudents": [],
                    "gradeGroupStudentsPercentage": 100
                  },
                  {
                    "id": 1005,
                    "name": "lernen für Test (Grundwissenheft S. 14-26)",
                    "homework": 3,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": "2022-10-18 09:20:00",
                    "deadlineOvertime": null,
                    "hasGrades": false,
                    "hasGradeGroupSubmissions": false,
                    "typeId": 60,
                    "typeName": "Hausaufgabe Mündlich",
                    "gradeGroupSubmissions": [],
                    "gradeGroupStudents": [],
                    "gradeGroupStudentsPercentage": 100
                  }
                ],
                "lessonContents": [
                  {
                    "id": 1701,
                    "name":
                        "Test; Exkurs Gesellschaftliche Bildung: Zivilschutz; Proteine: Tertiär- und Quartärstruktur (Film, AB)",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 3,
              "linkedHoursCount": 0
            },
            "4": {
              "isLesson": 1,
              "lesson": {
                "id": 2736,
                "date": dates[1],
                "hour": 4,
                "toHour": 4,
                "timeStart": 33000,
                "timeEnd": 35700,
                "timeToEnd": 35700,
                "timeStartObject": {
                  "h": "10",
                  "m": "10",
                  "ts": 33000,
                  "text": "10:10",
                  "html": "10<sup>10</sup>"
                },
                "timeEndObject": {
                  "h": "10",
                  "m": "55",
                  "ts": 35700,
                  "text": "10:55",
                  "html": "10<sup>55</sup>"
                },
                "timeToEndObject": {
                  "h": "10",
                  "m": "55",
                  "ts": 35700,
                  "text": "10:55",
                  "html": "10<sup>55</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1639, "firstName": "Verena", "lastName": "Steinmair"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 22,
                  "name": "Naturwissenschaften",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1729,
                    "name":
                        "Test; Exkurs Gesellschaftliche Bildung: Zivilschutz; Proteine: Tertiär- und Quartärstruktur (Film, AB)",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [
                  {"id": 14, "name": "Chemieraum"}
                ],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 4,
              "linkedHoursCount": 0
            },
            "5": {
              "isLesson": 1,
              "lesson": {
                "id": 3601,
                "date": dates[1],
                "hour": 5,
                "toHour": 6,
                "timeStart": 36600,
                "timeEnd": 39300,
                "timeToEnd": 42300,
                "timeStartObject": {
                  "h": "11",
                  "m": "10",
                  "ts": 36600,
                  "text": "11:10",
                  "html": "11<sup>10</sup>"
                },
                "timeEndObject": {
                  "h": "11",
                  "m": "55",
                  "ts": 39300,
                  "text": "11:55",
                  "html": "11<sup>55</sup>"
                },
                "timeToEndObject": {
                  "h": "12",
                  "m": "45",
                  "ts": 42300,
                  "text": "12:45",
                  "html": "12<sup>45</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 5256, "firstName": "Vania", "lastName": "Vidotto"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 7,
                  "name": "Italienisch",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1715,
                    "name":
                        "Lingua, stile e parti dell'edizione quarantana ; brevi letture/ ascolti dai capp. I e II : le figure di Don Abbondio e Renzo;  esercizi scritti  di comprensione, in piccoli gruppi.",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3602,
                    "date": dates[1],
                    "hour": 6,
                    "toHour": 6,
                    "timeStart": 39600,
                    "timeEnd": 42300,
                    "timeToEnd": 42300,
                    "timeStartObject": {
                      "h": "12",
                      "m": "00",
                      "ts": 39600,
                      "text": "12:00",
                      "html": "12<sup>00</sup>"
                    },
                    "timeEndObject": {
                      "h": "12",
                      "m": "45",
                      "ts": 42300,
                      "text": "12:45",
                      "html": "12<sup>45</sup>"
                    },
                    "timeToEndObject": {
                      "h": "12",
                      "m": "45",
                      "ts": 42300,
                      "text": "12:45",
                      "html": "12<sup>45</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {"id": 5256, "firstName": "Vania", "lastName": "Vidotto"}
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 7,
                      "name": "Italienisch",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 5,
              "linkedHoursCount": 1
            },
            "7": {
              "isLesson": 1,
              "lesson": {
                "id": 3633,
                "date": dates[1],
                "hour": 7,
                "toHour": 7,
                "timeStart": 42600,
                "timeEnd": 45300,
                "timeToEnd": 45300,
                "timeStartObject": {
                  "h": "12",
                  "m": "50",
                  "ts": 42600,
                  "text": "12:50",
                  "html": "12<sup>50</sup>"
                },
                "timeEndObject": {
                  "h": "13",
                  "m": "35",
                  "ts": 45300,
                  "text": "13:35",
                  "html": "13<sup>35</sup>"
                },
                "timeToEndObject": {
                  "h": "13",
                  "m": "35",
                  "ts": 45300,
                  "text": "13:35",
                  "html": "13<sup>35</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1642, "firstName": "Gernot", "lastName": "Wachtler"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 17,
                  "name": "Bewegung und Sport",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1724,
                    "name": "Pantherball",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [
                  {"id": 26, "name": "Turnhalle"}
                ],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 7,
              "linkedHoursCount": 0
            },
            "8": {
              "isLesson": 0,
              "lesson": null,
              "hour": 8,
              "linkedHoursCount": 0
            },
            "9": {
              "isLesson": 0,
              "lesson": null,
              "hour": 9,
              "linkedHoursCount": 0
            },
            "10": {
              "isLesson": 0,
              "lesson": null,
              "hour": 10,
              "linkedHoursCount": 0
            }
          }
        }
      },
      dates[2]: {
        "1": {
          "1": {
            "1": {
              "isLesson": 1,
              "lesson": {
                "id": 3645,
                "date": dates[2],
                "hour": 1,
                "toHour": 2,
                "timeStart": 24300,
                "timeEnd": 27000,
                "timeToEnd": 29700,
                "timeStartObject": {
                  "h": "07",
                  "m": "45",
                  "ts": 24300,
                  "text": "07:45",
                  "html": "07<sup>45</sup>"
                },
                "timeEndObject": {
                  "h": "08",
                  "m": "30",
                  "ts": 27000,
                  "text": "08:30",
                  "html": "08<sup>30</sup>"
                },
                "timeToEndObject": {
                  "h": "09",
                  "m": "15",
                  "ts": 29700,
                  "text": "09:15",
                  "html": "09<sup>15</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1655, "firstName": "Andres", "lastName": "Pizzinini"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 21,
                  "name": "Philosophie",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1739,
                    "name":
                        "Verzweigung des Denkens nach Kant. G. F. Hegel: dialektische Grundstruktur unter Einbeziehung der Zeit",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3646,
                    "date": dates[2],
                    "hour": 2,
                    "toHour": 2,
                    "timeStart": 27000,
                    "timeEnd": 29700,
                    "timeToEnd": 29700,
                    "timeStartObject": {
                      "h": "08",
                      "m": "30",
                      "ts": 27000,
                      "text": "08:30",
                      "html": "08<sup>30</sup>"
                    },
                    "timeEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeToEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {
                        "id": 1655,
                        "firstName": "Andres",
                        "lastName": "Pizzinini"
                      }
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 21,
                      "name": "Philosophie",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 1,
              "linkedHoursCount": 1
            },
            "3": {
              "isLesson": 1,
              "lesson": {
                "id": 3675,
                "date": dates[2],
                "hour": 3,
                "toHour": 4,
                "timeStart": 30000,
                "timeEnd": 32700,
                "timeToEnd": 35700,
                "timeStartObject": {
                  "h": "09",
                  "m": "20",
                  "ts": 30000,
                  "text": "09:20",
                  "html": "09<sup>20</sup>"
                },
                "timeEndObject": {
                  "h": "10",
                  "m": "05",
                  "ts": 32700,
                  "text": "10:05",
                  "html": "10<sup>05</sup>"
                },
                "timeToEndObject": {
                  "h": "10",
                  "m": "55",
                  "ts": 35700,
                  "text": "10:55",
                  "html": "10<sup>55</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1624, "firstName": "Otmar", "lastName": "Kollmann"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 19,
                  "name": "Latein",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [
                  {
                    "id": 1763,
                    "name":
                        "Hymnus auf die Leistungen der Philosophie: \"O vitae philosophia dux\" (Cicero, Tusc. disp. V, 5): Z. 16-20: sprachliche Analyse, Übersetzung, Stilmittel;  Strukturanalyse nach \"religiösen Kategorien\"; Erschließungsfragen zum Text; Ciceros Schrift: \"Tusculanae disputationes\": Einführung (Teil 1).",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": null,
                    "deadlineOvertime": null,
                    "hasLessonContentSubmissions": false,
                    "typeId": 1,
                    "typeName": "Fachunterricht",
                    "lessonContentSubmissions": [],
                    "lessonContentStudents": [],
                    "lessonContentStudentsPercentage": 100
                  }
                ],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3676,
                    "date": dates[2],
                    "hour": 4,
                    "toHour": 4,
                    "timeStart": 33000,
                    "timeEnd": 35700,
                    "timeToEnd": 35700,
                    "timeStartObject": {
                      "h": "10",
                      "m": "10",
                      "ts": 33000,
                      "text": "10:10",
                      "html": "10<sup>10</sup>"
                    },
                    "timeEndObject": {
                      "h": "10",
                      "m": "55",
                      "ts": 35700,
                      "text": "10:55",
                      "html": "10<sup>55</sup>"
                    },
                    "timeToEndObject": {
                      "h": "10",
                      "m": "55",
                      "ts": 35700,
                      "text": "10:55",
                      "html": "10<sup>55</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {"id": 1624, "firstName": "Otmar", "lastName": "Kollmann"}
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 19,
                      "name": "Latein",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 3,
              "linkedHoursCount": 1
            },
            "5": {
              "isLesson": 1,
              "lesson": {
                "id": null,
                "date": dates[2],
                "hour": 5,
                "toHour": 7,
                "timeStart": 36600,
                "timeEnd": 39300,
                "timeToEnd": 45300,
                "timeStartObject": {
                  "h": "11",
                  "m": "10",
                  "ts": 36600,
                  "text": "11:10",
                  "html": "11<sup>10</sup>"
                },
                "timeEndObject": {
                  "h": "11",
                  "m": "55",
                  "ts": 39300,
                  "text": "11:55",
                  "html": "11<sup>55</sup>"
                },
                "timeToEndObject": {
                  "h": "13",
                  "m": "35",
                  "ts": 45300,
                  "text": "13:35",
                  "html": "13<sup>35</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1623, "firstName": "Harald", "lastName": "Knoflach"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 106,
                  "name": "Gesellschaftliche Bildung",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": null,
                    "date": dates[2],
                    "hour": 6,
                    "toHour": 6,
                    "timeStart": 39600,
                    "timeEnd": 42300,
                    "timeToEnd": 42300,
                    "timeStartObject": {
                      "h": "12",
                      "m": "00",
                      "ts": 39600,
                      "text": "12:00",
                      "html": "12<sup>00</sup>"
                    },
                    "timeEndObject": {
                      "h": "12",
                      "m": "45",
                      "ts": 42300,
                      "text": "12:45",
                      "html": "12<sup>45</sup>"
                    },
                    "timeToEndObject": {
                      "h": "12",
                      "m": "45",
                      "ts": 42300,
                      "text": "12:45",
                      "html": "12<sup>45</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {
                        "id": 1623,
                        "firstName": "Harald",
                        "lastName": "Knoflach"
                      }
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 106,
                      "name": "Gesellschaftliche Bildung",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  },
                  {
                    "id": null,
                    "date": dates[2],
                    "hour": 7,
                    "toHour": 7,
                    "timeStart": 42600,
                    "timeEnd": 45300,
                    "timeToEnd": 45300,
                    "timeStartObject": {
                      "h": "12",
                      "m": "50",
                      "ts": 42600,
                      "text": "12:50",
                      "html": "12<sup>50</sup>"
                    },
                    "timeEndObject": {
                      "h": "13",
                      "m": "35",
                      "ts": 45300,
                      "text": "13:35",
                      "html": "13<sup>35</sup>"
                    },
                    "timeToEndObject": {
                      "h": "13",
                      "m": "35",
                      "ts": 45300,
                      "text": "13:35",
                      "html": "13<sup>35</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {
                        "id": 1623,
                        "firstName": "Harald",
                        "lastName": "Knoflach"
                      }
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 106,
                      "name": "Gesellschaftliche Bildung",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 5,
              "linkedHoursCount": 2
            },
            "8": {
              "isLesson": 0,
              "lesson": null,
              "hour": 8,
              "linkedHoursCount": 0
            },
            "9": {
              "isLesson": 0,
              "lesson": null,
              "hour": 9,
              "linkedHoursCount": 0
            },
            "10": {
              "isLesson": 0,
              "lesson": null,
              "hour": 10,
              "linkedHoursCount": 0
            }
          }
        }
      },
      dates[3]: {
        "1": {
          "1": {
            "1": {
              "isLesson": 1,
              "lesson": {
                "id": 3603,
                "date": dates[3],
                "hour": 1,
                "toHour": 2,
                "timeStart": 24300,
                "timeEnd": 27000,
                "timeToEnd": 29700,
                "timeStartObject": {
                  "h": "07",
                  "m": "45",
                  "ts": 24300,
                  "text": "07:45",
                  "html": "07<sup>45</sup>"
                },
                "timeEndObject": {
                  "h": "08",
                  "m": "30",
                  "ts": 27000,
                  "text": "08:30",
                  "html": "08<sup>30</sup>"
                },
                "timeToEndObject": {
                  "h": "09",
                  "m": "15",
                  "ts": 29700,
                  "text": "09:15",
                  "html": "09<sup>15</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 5256, "firstName": "Vania", "lastName": "Vidotto"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 7,
                  "name": "Italienisch",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [
                  {
                    "id": 1338,
                    "name":
                        "Completare gli esercizi iniziati in classe; studiare con cura gli appunti.",
                    "homework": 1,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": "2022-10-20 07:45:00",
                    "deadlineOvertime": null,
                    "hasGrades": false,
                    "hasGradeGroupSubmissions": false,
                    "typeId": 57,
                    "typeName": "Hausaufgabe Schriftlich",
                    "gradeGroupSubmissions": [],
                    "gradeGroupStudents": [],
                    "gradeGroupStudentsPercentage": 100
                  }
                ],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3604,
                    "date": dates[3],
                    "hour": 2,
                    "toHour": 2,
                    "timeStart": 27000,
                    "timeEnd": 29700,
                    "timeToEnd": 29700,
                    "timeStartObject": {
                      "h": "08",
                      "m": "30",
                      "ts": 27000,
                      "text": "08:30",
                      "html": "08<sup>30</sup>"
                    },
                    "timeEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeToEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {"id": 5256, "firstName": "Vania", "lastName": "Vidotto"}
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 7,
                      "name": "Italienisch",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 1,
              "linkedHoursCount": 1
            },
            "3": {
              "isLesson": 1,
              "lesson": {
                "id": null,
                "date": dates[3],
                "hour": 3,
                "toHour": 3,
                "timeStart": 30000,
                "timeEnd": 32700,
                "timeToEnd": 32700,
                "timeStartObject": {
                  "h": "09",
                  "m": "20",
                  "ts": 30000,
                  "text": "09:20",
                  "html": "09<sup>20</sup>"
                },
                "timeEndObject": {
                  "h": "10",
                  "m": "05",
                  "ts": 32700,
                  "text": "10:05",
                  "html": "10<sup>05</sup>"
                },
                "timeToEndObject": {
                  "h": "10",
                  "m": "05",
                  "ts": 32700,
                  "text": "10:05",
                  "html": "10<sup>05</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {
                    "id": 5971,
                    "firstName": "Barbara",
                    "lastName": "Mitterrutzner"
                  }
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 8,
                  "name": "Englisch",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 3,
              "linkedHoursCount": 0
            },
            "4": {
              "isLesson": 1,
              "lesson": {
                "id": null,
                "date": dates[3],
                "hour": 4,
                "toHour": 4,
                "timeStart": 33000,
                "timeEnd": 35700,
                "timeToEnd": 35700,
                "timeStartObject": {
                  "h": "10",
                  "m": "10",
                  "ts": 33000,
                  "text": "10:10",
                  "html": "10<sup>10</sup>"
                },
                "timeEndObject": {
                  "h": "10",
                  "m": "55",
                  "ts": 35700,
                  "text": "10:55",
                  "html": "10<sup>55</sup>"
                },
                "timeToEndObject": {
                  "h": "10",
                  "m": "55",
                  "ts": 35700,
                  "text": "10:55",
                  "html": "10<sup>55</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 3808, "firstName": "Konrad", "lastName": "Willeit"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 5,
                  "name": "Religion",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 4,
              "linkedHoursCount": 0
            },
            "5": {
              "isLesson": 1,
              "lesson": {
                "id": null,
                "date": dates[3],
                "hour": 5,
                "toHour": 5,
                "timeStart": 36600,
                "timeEnd": 39300,
                "timeToEnd": 39300,
                "timeStartObject": {
                  "h": "11",
                  "m": "10",
                  "ts": 36600,
                  "text": "11:10",
                  "html": "11<sup>10</sup>"
                },
                "timeEndObject": {
                  "h": "11",
                  "m": "55",
                  "ts": 39300,
                  "text": "11:55",
                  "html": "11<sup>55</sup>"
                },
                "timeToEndObject": {
                  "h": "11",
                  "m": "55",
                  "ts": 39300,
                  "text": "11:55",
                  "html": "11<sup>55</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1642, "firstName": "Gernot", "lastName": "Wachtler"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 17,
                  "name": "Bewegung und Sport",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 5,
              "linkedHoursCount": 0
            },
            "6": {
              "isLesson": 1,
              "lesson": {
                "id": 3532,
                "date": dates[3],
                "hour": 6,
                "toHour": 7,
                "timeStart": 39600,
                "timeEnd": 42300,
                "timeToEnd": 45300,
                "timeStartObject": {
                  "h": "12",
                  "m": "00",
                  "ts": 39600,
                  "text": "12:00",
                  "html": "12<sup>00</sup>"
                },
                "timeEndObject": {
                  "h": "12",
                  "m": "45",
                  "ts": 42300,
                  "text": "12:45",
                  "html": "12<sup>45</sup>"
                },
                "timeToEndObject": {
                  "h": "13",
                  "m": "35",
                  "ts": 45300,
                  "text": "13:35",
                  "html": "13<sup>35</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1643, "firstName": "Manuel", "lastName": "Winkler"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 13,
                  "name": "Mathematik",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3533,
                    "date": dates[3],
                    "hour": 7,
                    "toHour": 7,
                    "timeStart": 42600,
                    "timeEnd": 45300,
                    "timeToEnd": 45300,
                    "timeStartObject": {
                      "h": "12",
                      "m": "50",
                      "ts": 42600,
                      "text": "12:50",
                      "html": "12<sup>50</sup>"
                    },
                    "timeEndObject": {
                      "h": "13",
                      "m": "35",
                      "ts": 45300,
                      "text": "13:35",
                      "html": "13<sup>35</sup>"
                    },
                    "timeToEndObject": {
                      "h": "13",
                      "m": "35",
                      "ts": 45300,
                      "text": "13:35",
                      "html": "13<sup>35</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {"id": 1643, "firstName": "Manuel", "lastName": "Winkler"}
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 13,
                      "name": "Mathematik",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 6,
              "linkedHoursCount": 1
            },
            "8": {
              "isLesson": 0,
              "lesson": null,
              "hour": 8,
              "linkedHoursCount": 0
            },
            "9": {
              "isLesson": 0,
              "lesson": null,
              "hour": 9,
              "linkedHoursCount": 0
            },
            "10": {
              "isLesson": 0,
              "lesson": null,
              "hour": 10,
              "linkedHoursCount": 0
            }
          }
        }
      },
      dates[4]: {
        "1": {
          "1": {
            "1": {
              "isLesson": 1,
              "lesson": {
                "id": 2578,
                "date": dates[4],
                "hour": 1,
                "toHour": 2,
                "timeStart": 24300,
                "timeEnd": 27000,
                "timeToEnd": 29700,
                "timeStartObject": {
                  "h": "07",
                  "m": "45",
                  "ts": 24300,
                  "text": "07:45",
                  "html": "07<sup>45</sup>"
                },
                "timeEndObject": {
                  "h": "08",
                  "m": "30",
                  "ts": 27000,
                  "text": "08:30",
                  "html": "08<sup>30</sup>"
                },
                "timeToEndObject": {
                  "h": "09",
                  "m": "15",
                  "ts": 29700,
                  "text": "09:15",
                  "html": "09<sup>15</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1624, "firstName": "Otmar", "lastName": "Kollmann"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 20,
                  "name": "Griechisch",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [
                  {
                    "id": 942,
                    "name": "1. Schularbeit",
                    "homework": 0,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": "2022-10-21 07:45:00",
                    "deadlineOvertime": null,
                    "hasGrades": false,
                    "hasGradeGroupSubmissions": false,
                    "typeId": 3,
                    "typeName": "Schularbeit",
                    "gradeGroupSubmissions": [],
                    "gradeGroupStudents": [],
                    "gradeGroupStudentsPercentage": 100
                  }
                ],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 2579,
                    "date": dates[4],
                    "hour": 2,
                    "toHour": 2,
                    "timeStart": 27000,
                    "timeEnd": 29700,
                    "timeToEnd": 29700,
                    "timeStartObject": {
                      "h": "08",
                      "m": "30",
                      "ts": 27000,
                      "text": "08:30",
                      "html": "08<sup>30</sup>"
                    },
                    "timeEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeToEndObject": {
                      "h": "09",
                      "m": "15",
                      "ts": 29700,
                      "text": "09:15",
                      "html": "09<sup>15</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {"id": 1624, "firstName": "Otmar", "lastName": "Kollmann"}
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 20,
                      "name": "Griechisch",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 1,
              "linkedHoursCount": 1
            },
            "3": {
              "isLesson": 1,
              "lesson": {
                "id": null,
                "date": dates[4],
                "hour": 3,
                "toHour": 3,
                "timeStart": 30000,
                "timeEnd": 32700,
                "timeToEnd": 32700,
                "timeStartObject": {
                  "h": "09",
                  "m": "20",
                  "ts": 30000,
                  "text": "09:20",
                  "html": "09<sup>20</sup>"
                },
                "timeEndObject": {
                  "h": "10",
                  "m": "05",
                  "ts": 32700,
                  "text": "10:05",
                  "html": "10<sup>05</sup>"
                },
                "timeToEndObject": {
                  "h": "10",
                  "m": "05",
                  "ts": 32700,
                  "text": "10:05",
                  "html": "10<sup>05</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1628, "firstName": "Christof", "lastName": "Obkircher"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 10,
                  "name": "Geschichte",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 3,
              "linkedHoursCount": 0
            },
            "4": {
              "isLesson": 1,
              "lesson": {
                "id": null,
                "date": dates[4],
                "hour": 4,
                "toHour": 4,
                "timeStart": 33000,
                "timeEnd": 35700,
                "timeToEnd": 35700,
                "timeStartObject": {
                  "h": "10",
                  "m": "10",
                  "ts": 33000,
                  "text": "10:10",
                  "html": "10<sup>10</sup>"
                },
                "timeEndObject": {
                  "h": "10",
                  "m": "55",
                  "ts": 35700,
                  "text": "10:55",
                  "html": "10<sup>55</sup>"
                },
                "timeToEndObject": {
                  "h": "10",
                  "m": "55",
                  "ts": 35700,
                  "text": "10:55",
                  "html": "10<sup>55</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1624, "firstName": "Otmar", "lastName": "Kollmann"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 19,
                  "name": "Latein",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 4,
              "linkedHoursCount": 0
            },
            "5": {
              "isLesson": 1,
              "lesson": {
                "id": 2179,
                "date": dates[4],
                "hour": 5,
                "toHour": 6,
                "timeStart": 36600,
                "timeEnd": 39300,
                "timeToEnd": 42300,
                "timeStartObject": {
                  "h": "11",
                  "m": "10",
                  "ts": 36600,
                  "text": "11:10",
                  "html": "11<sup>10</sup>"
                },
                "timeEndObject": {
                  "h": "11",
                  "m": "55",
                  "ts": 39300,
                  "text": "11:55",
                  "html": "11<sup>55</sup>"
                },
                "timeToEndObject": {
                  "h": "12",
                  "m": "45",
                  "ts": 42300,
                  "text": "12:45",
                  "html": "12<sup>45</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1616, "firstName": "Eva", "lastName": "Gadner"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 103,
                  "name": "Kunstgeschichte",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [
                  {
                    "id": 794,
                    "name":
                        "Historismus, Nazarener, Biedermeier, Realismus, Impressionismus",
                    "homework": 5,
                    "online": 0,
                    "deadlineStart": null,
                    "deadline": "2022-10-21 11:10:00",
                    "deadlineOvertime": null,
                    "hasGrades": false,
                    "hasGradeGroupSubmissions": false,
                    "typeId": 1,
                    "typeName": "Mündliche Prüfung",
                    "gradeGroupSubmissions": [],
                    "gradeGroupStudents": [],
                    "gradeGroupStudentsPercentage": 100
                  }
                ],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 2180,
                    "date": dates[4],
                    "hour": 6,
                    "toHour": 6,
                    "timeStart": 39600,
                    "timeEnd": 42300,
                    "timeToEnd": 42300,
                    "timeStartObject": {
                      "h": "12",
                      "m": "00",
                      "ts": 39600,
                      "text": "12:00",
                      "html": "12<sup>00</sup>"
                    },
                    "timeEndObject": {
                      "h": "12",
                      "m": "45",
                      "ts": 42300,
                      "text": "12:45",
                      "html": "12<sup>45</sup>"
                    },
                    "timeToEndObject": {
                      "h": "12",
                      "m": "45",
                      "ts": 42300,
                      "text": "12:45",
                      "html": "12<sup>45</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {"id": 1616, "firstName": "Eva", "lastName": "Gadner"}
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 103,
                      "name": "Kunstgeschichte",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 5,
              "linkedHoursCount": 1
            },
            "7": {
              "isLesson": 0,
              "lesson": null,
              "hour": 7,
              "linkedHoursCount": 0
            },
            "8": {
              "isLesson": 1,
              "lesson": {
                "id": null,
                "date": dates[4],
                "hour": 8,
                "toHour": 8,
                "timeStart": 46800,
                "timeEnd": 50400,
                "timeToEnd": 50400,
                "timeStartObject": {
                  "h": "14",
                  "m": "00",
                  "ts": 46800,
                  "text": "14:00",
                  "html": "14<sup>00</sup>"
                },
                "timeEndObject": {
                  "h": "15",
                  "m": "00",
                  "ts": 50400,
                  "text": "15:00",
                  "html": "15<sup>00</sup>"
                },
                "timeToEndObject": {
                  "h": "15",
                  "m": "00",
                  "ts": 50400,
                  "text": "15:00",
                  "html": "15<sup>00</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1624, "firstName": "Otmar", "lastName": "Kollmann"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 24,
                  "name": "FÜ",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 8,
              "linkedHoursCount": 0
            },
            "9": {
              "isLesson": 1,
              "lesson": {
                "id": 3415,
                "date": dates[4],
                "hour": 9,
                "toHour": 10,
                "timeStart": 51300,
                "timeEnd": 54000,
                "timeToEnd": 56700,
                "timeStartObject": {
                  "h": "15",
                  "m": "15",
                  "ts": 51300,
                  "text": "15:15",
                  "html": "15<sup>15</sup>"
                },
                "timeEndObject": {
                  "h": "16",
                  "m": "00",
                  "ts": 54000,
                  "text": "16:00",
                  "html": "16<sup>00</sup>"
                },
                "timeToEndObject": {
                  "h": "16",
                  "m": "45",
                  "ts": 56700,
                  "text": "16:45",
                  "html": "16<sup>45</sup>"
                },
                "timeShowEnabled": true,
                "classId": 60,
                "className": "8K",
                "classComment": "",
                "description": "",
                "note": "",
                "lessonShow": true,
                "teachers": [
                  {"id": 1643, "firstName": "Manuel", "lastName": "Winkler"}
                ],
                "teachersToNotify": [],
                "teacherMyself": null,
                "isAutoNotify": false,
                "isLessonTypeNotifyOn": false,
                "exp_lt_default": false,
                "isSecretary": false,
                "subject": {
                  "id": 13,
                  "name": "Mathematik",
                  "lernfeld": 0,
                  "defaultLessonContent": "",
                  "defaultLessonContentType": 0
                },
                "homeworkExams": [],
                "lessonContents": [],
                "rooms": [
                  {"id": 15, "name": "Physikraum"},
                  {"id": 25, "name": "Physikpraktikumsraum"}
                ],
                "readOnly": true,
                "isSubstitute": 0,
                "linkToPreviousHour": 0,
                "linkedHours": [
                  {
                    "id": 3416,
                    "date": dates[4],
                    "hour": 10,
                    "toHour": 10,
                    "timeStart": 54000,
                    "timeEnd": 56700,
                    "timeToEnd": 56700,
                    "timeStartObject": {
                      "h": "16",
                      "m": "00",
                      "ts": 54000,
                      "text": "16:00",
                      "html": "16<sup>00</sup>"
                    },
                    "timeEndObject": {
                      "h": "16",
                      "m": "45",
                      "ts": 56700,
                      "text": "16:45",
                      "html": "16<sup>45</sup>"
                    },
                    "timeToEndObject": {
                      "h": "16",
                      "m": "45",
                      "ts": 56700,
                      "text": "16:45",
                      "html": "16<sup>45</sup>"
                    },
                    "timeShowEnabled": true,
                    "classId": 60,
                    "className": "8K",
                    "classComment": "",
                    "description": "",
                    "note": "",
                    "lessonShow": true,
                    "teachers": [
                      {"id": 1643, "firstName": "Manuel", "lastName": "Winkler"}
                    ],
                    "teachersToNotify": [],
                    "teacherMyself": null,
                    "isAutoNotify": false,
                    "isLessonTypeNotifyOn": false,
                    "exp_lt_default": false,
                    "isSecretary": false,
                    "subject": {
                      "id": 13,
                      "name": "Mathematik",
                      "lernfeld": 0,
                      "defaultLessonContent": "",
                      "defaultLessonContentType": 0
                    },
                    "homeworkExams": [],
                    "lessonContents": [],
                    "rooms": [
                      {"id": 25, "name": "Physikpraktikumsraum"},
                      {"id": 15, "name": "Physikraum"}
                    ],
                    "readOnly": true,
                    "isSubstitute": 0,
                    "linkToPreviousHour": 1,
                    "linkedHours": [],
                    "criticalObservations": [],
                    "missingStudents": [],
                    "students": [],
                    "grades": [],
                    "observations": [],
                    "absenceOpenAbsencesStudents": []
                  }
                ],
                "criticalObservations": [],
                "missingStudents": [],
                "students": [],
                "grades": [],
                "observations": [],
                "absenceOpenAbsencesStudents": []
              },
              "hour": 9,
              "linkedHoursCount": 1
            }
          }
        }
      }
    };
  },
  "student/certificate":
      "<div class=\"student-subject-list\"><div class=\"default-page-container\"><h2 class=\"h2 margin-top\">Zeugnis Debertol Michael</h2>Zeugnis noch nicht verfügbar</div></div>",
  "api/message/getMyMessages": [],
};
