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

part of view;

class ReceptionAddresses {

  static const String className = '${libraryName}.ReceptionProduct';
  static const String NavShortcut = 'G';

  Context context;
  Element element;
  bool hasFocus = false;
  Element get header => this.element.querySelector('legend');
  model.Reception reception = model.nullReception;
  UListElement listElement;
  String title = 'Adresser';

  List<Element> get nudges => this.element.querySelectorAll('.nudge');
  void set nudgesHidden(bool hidden) => this.nudges.forEach((Element element) => element.hidden = hidden);

  ReceptionAddresses(Element this.element, Context this.context) {
    assert(element.attributes.containsKey(defaultElementId));
    
    listElement = element.querySelector('#${id.COMPANY_ADDRESSES_LIST}');
    header.children = [Icon.MapMarker,
                       new SpanElement()..text = title,
                       new Nudge(NavShortcut).element];

    ///Navigation shortcuts
    keyboardHandler.registerNavShortcut(NavShortcut, (_) => Controller.Context.changeLocation(new nav.Location(context.id, element.id, listElement.id)));

    _registerEventListeners();
  }

  void _registerEventListeners() {
    event.bus.on(event.receptionChanged).listen(render);

    event.bus.on(event.keyNav).listen((bool isPressed) => this.nudgesHidden = !isPressed);

    element.onClick.listen((_) {
      event.bus.fire(event.locationChanged, new nav.Location(context.id, element.id, listElement.id));
    });

    event.bus.on(event.locationChanged).listen((nav.Location location) {
      bool active = location.widgetId == element.id;
      element.classes.toggle(FOCUS, active);
      if (active) {
        listElement.focus();
      }
    });
  }

  void render(model.Reception reception) {
    listElement.children.clear();

    for (var value in reception.addressList) {
      listElement.children.add(new LIElement()..text = value.value);
    }
  }
}