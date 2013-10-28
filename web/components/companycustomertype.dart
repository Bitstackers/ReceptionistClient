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

class CompanyCustomerType {
  DivElement        body;
  Box                box;
  DivElement         element;
  SpanElement        header;
  model.Organization organization = model.nullOrganization;
  String             title        = 'Kundetype';

  CompanyCustomerType(DivElement this.element) {
    element.classes.add('minibox');

    //TODO ??? FIXME XXX WARNING ERROR TL LØCKE ALERT
    body = new DivElement();

    header = new SpanElement()
      ..text = title;

    box = new Box.withHeader(element, header, body);

    event.bus.on(event.organizationChanged).listen((model.Organization value) {
      organization = value;
      body.text = value.customerType;
    });
  }
}
