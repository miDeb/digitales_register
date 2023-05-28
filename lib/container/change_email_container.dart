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

import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/profile_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/ui/change_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

class ChangeEmailContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, Object>(
      connect: (_) => Object(),
      builder: (context, state, api) {
        return ChangeEmail(
          changeEmail: (pass, email) => api.profileActions.changeEmail(
            ChangeEmailPayload(
              (b) => b
                ..pass = pass
                ..email = email,
            ),
          ),
        );
      },
    );
  }
}
