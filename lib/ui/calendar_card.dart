// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/ui/animated_linear_progress_indicator.dart';
import 'package:dr/utc_date_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef SubmissionCallback = void Function(LessonContentSubmission submission);

class CalendarCard extends StatelessWidget {
  final CalendarHour hour;
  final SubjectTheme theme;
  final bool selected;
  final SubmissionCallback onOpenFile;
  final bool noInternet;

  const CalendarCard({
    super.key,
    required this.hour,
    required this.theme,
    required this.selected,
    required this.onOpenFile,
    required this.noInternet,
  });

  String formatTime(UtcDateTime dateTime) {
    return DateFormat.Hm("de").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: selected
            ? BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              )
            : BorderSide.none,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (name + teacher)
            Row(
              children: [
                CircledLetter(
                  letter: hour.subject.characters.first,
                  color: Color(theme.color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hour.subject,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            // Time (index and time)
            _ContentItem(
              title: hour.fromHour == hour.toHour
                  ? "${hour.fromHour}. Stunde"
                  : "${hour.fromHour}. – ${hour.toHour}. Stunde",
              content: hour.timeSpans
                  .map((span) =>
                      "${formatTime(span.from)} – ${formatTime(span.to)}")
                  .join(", "),
              icon: Icons.schedule,
            ),

            // Content
            if (hour.teachers.isNotEmpty)
              _ContentItem(
                title: hour.teachers.length == 1 ? "Lehrer*in" : "Lehrer*innen",
                content: hour.teachers
                    .map((t) => "${t.firstName} ${t.lastName}")
                    .join(", "),
                icon: hour.teachers.length == 1 ? Icons.person : Icons.people,
              ),
            if (hour.rooms.isNotEmpty)
              _ContentItem(
                title: "Räume",
                content: hour.rooms.join(", "),
                icon: Icons.meeting_room,
              ),
            for (final lessonContent in hour.lessonContents) ...[
              _ContentItem(
                title: lessonContent.typeName,
                content: lessonContent.name,
                icon: Icons.school,
              ),
              for (final submission in lessonContent.submissions)
                _SubmissionWidget(
                  submission: submission,
                  noInternet: noInternet,
                  onOpenFile: onOpenFile,
                )
            ],
            for (final HomeworkExam homeworkExam in hour.homeworkExams)
              if (homeworkExam.warning)
                _ContentItem(
                  title: homeworkExam.typeName,
                  content: homeworkExam.name,
                  icon: Icons.grade,
                  iconColor: Colors.red,
                )
              else
                _ContentItem(
                  title: homeworkExam.typeName,
                  content: homeworkExam.name,
                  icon: Icons.assignment,
                ),
          ]
              .expand(
                (element) => [
                  const SizedBox(height: 8),
                  element,
                ],
              )
              .toList(),
        ),
      ),
    );
  }
}

/// A letter in a colored circle
class CircledLetter extends StatelessWidget {
  final String letter;
  final Color color;
  const CircledLetter({
    super.key,
    required this.letter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black;
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ContentItem extends StatelessWidget {
  final String title, content;
  final IconData icon;
  final Color iconColor;
  const _ContentItem({
    required this.title,
    required this.content,
    required this.icon,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(content),
            ],
          ),
        )
      ],
    );
  }
}

class _SubmissionWidget extends StatelessWidget {
  final LessonContentSubmission submission;
  final bool noInternet;
  final SubmissionCallback onOpenFile;
  const _SubmissionWidget({
    required this.submission,
    required this.noInternet,
    required this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(
            Icons.attachment,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Anhang",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                submission.originalName,
              ),
              AnimatedLinearProgressIndicator(show: submission.downloading),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: !submission.fileAvailable && noInternet
                      ? null
                      : () {
                          onOpenFile(submission);
                        },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Öffnen"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
