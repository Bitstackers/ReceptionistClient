import 'dart:html';

import 'package:web_ui/web_ui.dart';

import '../classes/environment.dart';
import '../classes/model.dart' as model;

@observable
class CompanyInfo extends WebComponent {
  model.Organization organization = model.nullOrganization;

  void created() {
    environment.onOrganizationChange.listen((value) => organization = value);
  }
}
