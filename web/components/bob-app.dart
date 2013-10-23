/*                     This file is part of Bob
                   Copyright (C) 2012-, AdaHeads K/S

  This is free software;  you can redistribute it and/or modify it
  under terms of the  GNU General Public License  as published by the
  Free Software  Foundation;  either version 3,  or (at your  option) any
  later version. This software is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  You should have received a copy of the GNU General Public License along with
  this program; see the file COPYING3. If not, see http://www.gnu.org/licenses.
*/

import 'package:polymer/polymer.dart';

import '../classes/common.dart';
import '../classes/events.dart' as event;
import '../classes/logger.dart';
import '../classes/state.dart';

@CustomTag('bob-app')
class BobApp extends PolymerElement with ApplyAuthorStyle {
  @observable BobState state;

  BobApp.created() : super.created() {}

  void enteredView() {
    log.info('Bob is ready to serve. Welcome!', toUserLog: true);
    event.bus.on(event.stateUpdated).listen((BobState value) => state = value);
  }
}
