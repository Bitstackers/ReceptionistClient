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

library context;

import 'dart:async';
import 'dart:html';

import 'package:web_ui/web_ui.dart';

import 'keyboardhandler.dart';
import 'logger.dart';

final StreamController<Context> _contextActivationStream = new StreamController<Context>.broadcast();
final Stream<Context> _onChange = _contextActivationStream.stream;

/**
 * A [Context] is a top-level GUI container. It represents a collection of 0
 * or more widgets that are hidden/unhidden depending on the [isActive] state
 * of the [Context].
*
 * A [Context] can be activated by calling the [activate()] method. Activating
 * one [Context] automatically deactivates every other [Context]. A [Context]
 * listens for data on the [KeyboardHandler] stream named [Context.id] and
 * activates itself if an event is detected.
 *
 * A [Context] can be set in alert by calling [increaseAlert()] and alerts can
 * be negated by [decreaseAlert()]. The alert system is a simple counter, so
 * 3 calls to [increaseAlert()] puts the [Context] alert counter at 3, meaning
 * 3 calls to [decreaseAlert()] is required to move the [Context] out of alert.
 */
class Context {
  @observable int  _alertCounter = 0;
  @observable bool isActive      = false;

  Element _element;

  int    get alertCounter => _alertCounter;
  bool   get alertMode    => alertCounter > 0;
  String get id           => _element.id;

  /**
   * [Context] constructor. Takes a DOM element from where it derives its [id]
   * and on which the .hidden class is toggled according to the activation state
   * of the [Context].
   */
  Context(Element this._element) {
    assert(_element != null);

    isActive = _element.classes.contains('hidden') ? false : true;

    _registerEventListeners();
  }

  /**
   * Activate this [Context].
   */
  void activate() {
    _contextActivationStream.sink.add(this);
  }

  /**
   * Decrease the alert level for this [Context].
   */
  void decreaseAlert() {
    if (_alertCounter > 0) {
      _alertCounter--;
      log.debug('Context.decreaseAlert - ${id} level now at ${alertCounter}');
    }
  }

  /**
   * Increase the alert level for this [Context].
   */
  void increaseAlert() {
    _alertCounter++;
    log.debug('Context.increaseAlert - ${id} level now at ${alertCounter}');
  }

  /**
   * Toogle this [Context] ON/OFF.
   *
   * Toggling ON means removing the .hidden class from the [Context] DOM element
   * (see the constructor comment) and setting [isActive] to true.
   *
   * Toggline OFF means adding the .hidden class from the [Context] DOM element
   * (see the constructor comment) and setting [isActive] to false.
   */
  void _toggle(Context context) {
    if (context == this) {
      isActive = true;
      _element.classes.remove('hidden');
      log.debug('Context._toggle activating ${this.id}');
    } else if (isActive) {
      isActive = false;
      _element.classes.add('hidden');
    }
  }

  /**
   * Registers the event listeners needed by the [Context].
   */
  void _registerEventListeners() {
    // Keep track of which Context is active.
    _onChange.listen(_toggle);

    // Keep track of keyboardshortcuts.
    keyboardHandler.onKeyName(id).listen((_) => activate());
  }
}
