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

part of model;

final CalendarEventList nullCalendarEventList = new CalendarEventList._null();

/**
 * A list of [CalendarEvent] objects.
 */
class CalendarEventList extends IterableBase<CalendarEvent>{
  List<CalendarEvent> _list = <CalendarEvent>[];

  Iterator<CalendarEvent> get iterator => _list.iterator;

  /**
   * [CalendarEventList] constructor. Builds a list of [CalendarEvent] objects
   * from the contents of json[key].
   */
  factory CalendarEventList.fromJson(Map json, String key) {
    CalendarEventList calendarEventList;

    if (json.containsKey(key)) {
      calendarEventList = new CalendarEventList._internal(json[key]);
    } else {
      calendarEventList = nullCalendarEventList;
    }

    return calendarEventList;
  }

  /**
   * [CalendarEventList] internal constructor.
   */
  CalendarEventList._internal(List list) {
    list.forEach((item) => _list.add(new CalendarEvent.fromJson(item)));
    _list.sort();
  }

  /**
   * [CalendarEventList] null constructor.
   */
  CalendarEventList._null();
}
