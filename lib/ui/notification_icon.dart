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

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final int notifications;
  final VoidCallback onTap;

  const NotificationIcon(
      {super.key, required this.notifications, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return notifications != 0
        ? IconButton(
            visualDensity: VisualDensity.standard,
            icon: Badge(
              badgeContent: Text(
                notifications.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              position: BadgePosition.bottomEnd(),
              child: const Icon(Icons.notifications),
            ),
            onPressed: onTap,
          )
        : const SizedBox();
  }
}
