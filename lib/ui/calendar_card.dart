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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarCard extends StatelessWidget {
  final CalendarHour hour;
  final SubjectTheme theme;
  final bool selected;
  const CalendarCard({
    Key? key,
    required this.hour,
    required this.theme,
    required this.selected,
  }) : super(key: key);

  String formatTime(DateTime dateTime) {
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
      elevation: 5,
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
                    style: Theme.of(context).textTheme.headline6,
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
            for (final lessonContent in hour.lessonContents)
              _ContentItem(
                title: lessonContent.typeName,
                content: lessonContent.name,
                icon: Icons.school,
              ),
            for (HomeworkExam homeworkExam in hour.homeworkExams)
              if (estimateShouldWarn(homeworkExam.typeName))
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
            if (hour.teachers.isNotEmpty)
              _ContentItem(
                title: "Lehrer",
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
              )
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
    Key? key,
    required this.letter,
    required this.color,
  }) : super(key: key);

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
    Key? key,
    required this.title,
    required this.content,
    required this.icon,
    this.iconColor = Colors.grey,
  }) : super(key: key);

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
              Text(content),
            ],
          ),
        )
      ],
    );
  }
}
