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

library Common;

import 'dart:async';

/**
 * A simple timeout exception. MUST be used wherever we throw exceptions due
 * to timeout issues.
 */
class TimeoutException implements Exception {
  final String message;

  const TimeoutException(this.message);

  String toString() => message;
}

typedef bool boolFunc ();

/**
 * Repeats asking [check] every [repeatTime], at a maximum of [maxRepeat] times, if not [maxRepeat] is zero.
 * If [maxRepeat] is exceded then a [TimeoutException] is raised with [timeoutMessage].
 */
Future<bool> repeatCheck(boolFunc check, int maxRepeat, Duration repeatTime, {String timeoutMessage}) {
  assert(maxRepeat != null);
  assert(maxRepeat >= 0);
  assert(repeatTime.inMilliseconds > 0);

  print('PRINTING common.repeatCheck is started');

  final Completer completer = new Completer();
        int       count     = 0;

  if (check()) {
    completer.complete(true);
  } else {
    new Timer.periodic(repeatTime, (timer) {
      count += 1;
      if (check()) {
        timer.cancel();
        completer.complete(true);
      } else if (count > maxRepeat && maxRepeat != 0) {
        timer.cancel();
        completer.completeError(new TimeoutException(timeoutMessage));
      }
    });
  }

  return completer.future;
}