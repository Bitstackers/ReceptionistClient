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

part of protocol;

/**
 * Get a list of every active call.
 *
 * Completes with:
 *  On success: [Response] object with status OK
 *  On error  : [Response] object with status ERROR or CRITICALERROR
 */
Future<Response> callList(){
  final String    base      = configuration.aliceBaseUrl.toString();
  final Completer completer = new Completer<Response>();
  final String    path      = '/call/list';
  HttpRequest     request;
  final String    url       = _buildUrl(base, path);

  request = new HttpRequest()
    ..open(GET, url)
    ..onLoad.listen((_){
      switch(request.status) {
        case 200:
          Map data = _parseJson(request.responseText);
          completer.complete(new Response(Response.OK, data));
          break;

        case 204:
          completer.complete(new Response(Response.OK, null));
          break;

        default:
          completer.completeError(new Response.error(Response.CRITICALERROR, '${url} [${request.status}] ${request.statusText}'));
      }
    })
    ..onError.listen((e) {
      _logError(request, url);
      completer.completeError(new Response.error(Response.CRITICALERROR, e.toString()));

    })
    ..send();

  return completer.future;
}

/**
 * Get a list of waiting calls.
 */
Future<Response> callQueue(){
  final String    base      = configuration.aliceBaseUrl.toString();
  final Completer completer = new Completer<Response>();
  final String    path      = '/call/queue';
  HttpRequest     request;
  final String    url       = _buildUrl(base, path);

  request = new HttpRequest()
    ..open(GET, url)
    ..onLoad.listen((_){
      switch(request.status) {
        case 200:
          Map data = _parseJson(request.responseText);
          completer.complete(new Response(Response.OK, data));
          break;

        case 204:
          completer.complete(new Response(Response.NOTFOUND, null));
          break;

        default:
          completer.completeError(new Response.error(Response.CRITICALERROR, '${url} [${request.status}] ${request.statusText}'));
      }
    })
    ..onError.listen((e) {
      _logError(request, url);
      completer.completeError(new Response.error(Response.CRITICALERROR, e.toString()));

    })
    ..send();

  return completer.future;
}

/**
 * Hangup [call].
 */
Future<Response> hangupCall(model.Call call){
  final String       base      = configuration.aliceBaseUrl.toString();
  final Completer    completer = new Completer<Response>();
  final List<String> fragments = <String>[];
  final String       path      = '/call/hangup';
  HttpRequest        request;
  String             url;

  fragments.add('call_id=${call.id}');
  url = _buildUrl(base, path, fragments);

  request = new HttpRequest()
    ..open(POST, url)
    ..onLoad.listen((_) {
      switch(request.status) {
        case 200:
          Map data = _parseJson(request.responseText);
          completer.complete(new Response(Response.OK, data));
          break;

        case 404:
          completer.complete(new Response(Response.NOTFOUND, null));
          break;

        default:
          completer.completeError(new Response.error(Response.CRITICALERROR, '${url} [${request.status}] ${request.statusText}'));
      }
    })
    ..onError.listen((e) {
      _logError(request, url);
      completer.completeError(new Response.error(Response.CRITICALERROR, e.toString()));

    })
    ..send();

  return completer.future;
}

/**
 * Place a new call to an Agent, a Contact (via contact method, ), an arbitrary PSTn number or a SIP phone.
 *
 * Sends a request to make a new call.
 */
Future<Response> originateCall(String agentId, {int cmId, String pstnNumber, String sip}){
  assert(agentId.isNotEmpty);

  final String       base      = configuration.aliceBaseUrl.toString();
  final Completer    completer = new Completer<Response>();
  final List<String> fragments = <String>[];
  final String       path      = '/call/originate';
  HttpRequest        request;
  String             url;

  fragments.add('agent_id=${agentId}');

  if (cmId != null){
    fragments.add('cm_id=${cmId}');
  }

  if (pstnNumber != null && !pstnNumber.isEmpty){
    fragments.add('pstn_number=${pstnNumber}');
  }

  if (sip != null && !sip.isEmpty){
    fragments.add('sip=${sip}');
  }

  url = _buildUrl(base, path, fragments);

  request = new HttpRequest()
    ..open(POST, url)
    ..onLoad.listen((_){
      switch(request.status) {
        case 200:
          Map data = _parseJson(request.responseText);
          completer.complete(new Response(Response.OK, data));
          break;

        default:
          completer.completeError(new Response.error(Response.CRITICALERROR, '${url} [${request.status}] ${request.statusText}'));
      }
    })
    ..onError.listen((e) {
      _logError(request, url);
      completer.completeError(new Response.error(Response.CRITICALERROR, e.toString()));

    })
    ..send();

  return completer.future;
}

/**
 * Park [call].
 * TODO Check up on Docs. It says nothing about call_id. 2013-02-27 Thomas P.
 */
Future<Response> parkCall(model.Call call){
  assert(call != null);

  final String       base      = configuration.aliceBaseUrl.toString();
  final Completer    completer = new Completer<Response>();
  final List<String> fragments = <String>[];
  final String       path      = '/call/park';
  HttpRequest        request;
  String             url;

  fragments.add('call_id=${call.id}');
  url = _buildUrl(base, path, fragments);

  request = new HttpRequest()
    ..open(POST, url)
    ..onLoad.listen((_){
      switch(request.status) {
        case 200:
          Map data = _parseJson(request.responseText);
          completer.complete(new Response(Response.OK, data));
          break;

        case 404:
          completer.complete(new Response(Response.NOTFOUND, null));
          break;

        default:
          completer.completeError(new Response.error(Response.CRITICALERROR, '${url} [${request.status}] ${request.statusText}'));
      }
    })
    ..onError.listen((e) {
      _logError(request, url);
      completer.completeError(new Response.error(Response.CRITICALERROR, e.toString()));

    })
    ..send();

  return completer.future;
}

/**
 * Sends a call based on the [callId], if present, to the agent with [AgentId].
 * If no callId is specified, then the next call in line will be dispatched
 * to the agent.
 */
Future<Response> pickupCall(String agentId, {model.Call call}){
  assert(agentId.isNotEmpty);

  final String       base      = configuration.aliceBaseUrl.toString();
  final Completer    completer = new Completer<Response>();
  final List<String> fragments = <String>[];
  final String       path = '/call/pickup';
  HttpRequest        request;
  String             url;

  fragments.add('agent_id=${agentId}');

  if (call != null && !call.id != null) {
    fragments.add('call_id=${call.id}');
  }

  url = _buildUrl(base, path, fragments);

  request = new HttpRequest()
    ..open(POST, url)
    ..onLoad.listen((_){
      switch(request.status) {
        case 200:
          Map data = _parseJson(request.responseText);
          completer.complete(new Response(Response.OK, data));
          break;

        case 204:
          completer.complete(new Response(Response.NOTFOUND, null));
          break;

        default:
          completer.completeError(new Response.error(Response.CRITICALERROR, '${url} [${request.status}] ${request.statusText}'));
      }
    })
    ..onError.listen((e) {
      _logError(request, url);
      completer.completeError(new Response.error(Response.CRITICALERROR, e.toString()));

    })
    ..send();

  return completer.future;
}

/**
 * TODO Not implemented in Alice, as far as i can see. 2013-02-27 Thomas P.
 * Gives the status of a call.
 */
Future<Response> statusCall(model.Call call){
  assert(call != null);

  final String       base      = configuration.aliceBaseUrl.toString();
  final Completer    completer = new Completer<Response>();
  final List<String> fragments = <String>[];
  final String       path      = '/call/state';
  HttpRequest        request;
  String             url;

  fragments.add('call_id=${call.id}');
  url = _buildUrl(base, path, fragments);

  request = new HttpRequest()
    ..open(POST, url)
    ..onLoad.listen((_){
      switch(request.status) {
        case 200:
          Map data = _parseJson(request.responseText);
          completer.complete(new Response(Response.OK, data));
          break;

        case 404:
          completer.complete(new Response(Response.NOTFOUND, {}));
          break;

        default:
          completer.completeError(new Response.error(Response.CRITICALERROR, '${url} [${request.status}] ${request.statusText}'));
      }
    })
    ..onError.listen((e) {
      _logError(request, url);
      completer.completeError(new Response.error(Response.CRITICALERROR, e.toString()));

    })
    ..send();

  return completer.future;
}

/**
 * Sends a request to transfer a call.
 */
Future<Response> transferCall(model.Call call){
  assert(call != null);

  final String       base      = configuration.aliceBaseUrl.toString();
  final Completer    completer = new Completer<Response>();
  final List<String> fragments = <String>[];
  final String       path      = '/call/transfer';
  HttpRequest        request;
  String             url;

  fragments.add('source=${call.id}');
  url = _buildUrl(base, path, fragments);

  request = new HttpRequest()
    ..open(POST, url)
    ..onLoad.listen((_){
      switch(request.status) {
        case 200:
          Map data = _parseJson(request.responseText);
          completer.complete(new Response(Response.OK, data));
          break;

        case 404:
          completer.complete(new Response(Response.NOTFOUND, null));
          break;

        default:
          completer.completeError(new Response.error(Response.CRITICALERROR, '${url} [${request.status}] ${request.statusText}'));
      }
    })
    ..onError.listen((e) {
      _logError(request, url);
      completer.completeError(new Response.error(Response.CRITICALERROR, e.toString()));

    })
    ..send();

  return completer.future;
}
