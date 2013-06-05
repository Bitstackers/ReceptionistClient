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

library protocol;

import 'dart:async';
import 'dart:html';
import 'dart:json' as json;

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'common.dart';
import 'configuration.dart';
import 'logger.dart';
import 'model.dart' as model;

part 'protocol.agent.dart';
part 'protocol.call.dart';
part 'protocol.debug.dart';
part 'protocol.log.dart';
part 'protocol.message.dart';
part 'protocol.organization.dart';

const String GET = "GET";
const String POST = "POST";

/**
 * Makes a complete url from [base], [path] and the [fragments].
 * Output: base + path + ? + fragment[0] + & + fragment[1] ...
 */
String _buildUrl(String base, String path, [List<String> fragments]){
  var SB = new StringBuffer();
  var url = '${base}${path}';

  if (?fragments && fragments != null && !fragments.isEmpty){
    SB.write('?${fragments.first}');
    fragments.skip(1).forEach((fragment) => SB.write('&${fragment}'));
  }

  log.debug('buildurl: ${url}${SB.toString()}');
  return '${url}${SB.toString()}';
}

/**
 * Validates and parses String in JSON format to a Map.
 */
Map _parseJson(String responseText) {
  try {
    return json.parse(responseText);
  } catch(e) {
    log.critical('Protocol.toJSON exception: ${e}');
    return null;
  }
}

void _logError(HttpRequest request, String url) {
  log.critical('Protocol failed. Status: [${request.status}] URL: ${url}');
}

/**
 * Class to contains the basics about a Protocol element,
 *  like [_url], and the HttpRequest [_request].
 */
//abstract class Protocol {
//  const String GET = "GET";
//  const String POST = "POST";
//
//  String _url;
//  HttpRequest _request;
//  bool _notSent = true;
//
//  /**
//   * Sends the request.
//   */
//  void send(){
//    if (_notSent) {
//      _request.send();
//      _notSent = false;
//    }
//  }
//
//  /**
//   * Makes a complete url from [base], [path] and the [fragments].
//   * Output: base + path + ? + fragment[0] + & + fragment[1] ...
//   */
//  String _buildUrl(String base, String path, [List<String> fragments]){
//    var SB = new StringBuffer();
//    var url = '${base}${path}';
//
//    if (?fragments && fragments != null && !fragments.isEmpty){
//      SB.write('?${fragments.first}');
//      fragments.skip(1).forEach((fragment) => SB.write('&${fragment}'));
//    }
//
//    log.debug('buildurl: ${url}${SB.toString()}');
//    return '${url}${SB.toString()}';
//  }
//
//  /**
//   * Validates and parses String in JSON format to a Map.
//   */
//  Map parseJson(String responseText) {
//    try {
//      return json.parse(responseText);
//    } catch(e) {
//      log.critical('Protocol.toJSON exception: ${e}');
//      return null;
//    }
//  }
//
//  void _logError() {
//    log.critical('Protocol.${this.runtimeType} failed. Status: [${_request.status}] URL: ${_url}');
//  }
//
//  void onResponse(responseCallback callback);
//}

/**
 * TODO comment.
 * Something about response from the protocol.
 */
class Response {
  static const int CRITICALERROR = -2;
  static const int ERROR = -1;
  static const int OK = 0;
  static const int NOTFOUND = 1;

  Map data;
  int status;
  String statusText;

  Response(this.status, this.data);
  Response.error(this.status, this.statusText);
}
