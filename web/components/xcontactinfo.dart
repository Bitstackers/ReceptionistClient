import 'dart:html';

import 'package:web_ui/web_ui.dart';

import '../classes/environment.dart' as environment;
import '../classes/model.dart' as model;

@observable
class ContactInfo extends WebComponent {
  model.Organization organization = model.nullOrganization;

  void created() {
    environment.organization.onChange.listen((value) => organization = value);
  }
}
