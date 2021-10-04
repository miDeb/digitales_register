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

import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'profile_actions.g.dart';

abstract class ProfileActions extends ReduxActions {
  factory ProfileActions() => _$ProfileActions();
  ProfileActions._();

  abstract final VoidActionDispatcher load;
  abstract final ActionDispatcher<Object> loaded;
  abstract final ActionDispatcher<bool> sendNotificationEmails;
  abstract final ActionDispatcher<ChangeEmailPayload> changeEmail;
}

abstract class ChangeEmailPayload
    implements Built<ChangeEmailPayload, ChangeEmailPayloadBuilder> {
  factory ChangeEmailPayload(
          [void Function(ChangeEmailPayloadBuilder)? updates]) =
      _$ChangeEmailPayload;
  ChangeEmailPayload._();

  String get pass;
  String get email;

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChangeEmailPayload')
          //..add('pass', pass) // do not include the pass
          ..add('email', email))
        .toString();
  }
}
