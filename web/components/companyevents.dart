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

part of components;

class CompanyEvents {
  Box                     box;
  Context                 context;
  DivElement              element;
  SpanElement             header;
  model.Reception         reception = model.nullReception;
  model.CalendarEventList calendar;
  String                  title     = 'Kalender';
  UListElement            ul;

  bool hasFocus = false;

  CompanyEvents(DivElement this.element, Context this.context) {
    String defaultElementId = 'data-default-element';
    assert(element.attributes.containsKey(defaultElementId));
    
    ul = element.querySelector('#${element.attributes[defaultElementId]}');

    header = new SpanElement()
      ..text = title;

    box = new Box.withHeader(element, header)
      ..addBody(ul);

    _registerEventListeners();
  }

  void _registerEventListeners() {
    event.bus.on(event.receptionChanged).listen((model.Reception value) {
      protocol.getReceptionCalendar(value.id).then((protocol.Response<model.CalendarEventList> events) {
        calendar = events.data;
        render();
      });
      reception = value;
    });

//    ul.onFocus.listen((_) {
//      hasFocus = true;
//      event.bus.fire(event.locationChanged, new nav.Location(context.id, ul.id));
//      //setFocus(ul.id);
//    });

    element.onClick.listen((_) {
//      setFocus(ul.id);
      event.bus.fire(event.locationChanged, new nav.Location(context.id, element.id));
    });

//    event.bus.on(event.focusChanged).listen((Focus value) {
//      hasFocus = handleFocusChange(value, [ul], element);
//    });
    
    event.bus.on(event.locationChanged).listen((nav.Location location) {
      bool active = location.widgetId == element.id;
      element.classes.toggle(focusClassName, active);
      if(active) {
        ul.focus();
      }
    });

    context.registerFocusElement(ul);
  }

  String getClass(model.CalendarEvent event) {
    return event.active ? 'company-events-active' : '';
  }

  void render() {
    ul.children.clear();

    for(model.CalendarEvent event in calendar) {
      print(event);
      print(event.active);
      print(event.start);
      print(event.stop);
      String html = '''
        <li class="${event.active ? 'company-events-active': ''}">
          <table class="calendar-event-table">
            <tbody>
              <tr>
                <td class="calendar-event-content ${event.active ? '' : 'calendar-event-notactive'}">
                  ${event}
                <td>
              </tr>
            </tbody>
            <tfoot>
              <tr>
                <td class="calendar-event-timestamp ${event.active ? '' : 'calendar-event-notactive'}">
                  ${event.start} - ${event.stop}
                <td>
              </tr>
            </tfoot>
          </table>
        </li>
      ''';

      ul.children.add(new DocumentFragment.html(html).children.first);
    }
  }
}
