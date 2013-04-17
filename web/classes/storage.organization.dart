/*                                Bob
                   Copyright (C) 2012-, AdaHeads K/S

  This is free software;  you can redistribute it and/or modify it
  under terms of the  GNU General Public License  as published by the
  Free Software  Foundation;  either version 3,  or (at your  option) any
  later version. This library is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  You should have received a copy of the GNU General Public License and
  a copy of the GCC Runtime Library Exception along with this program;
  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
  <http://www.gnu.org/licenses/>.
*/

part of storage;

final _Organization organization = new _Organization();

/**
 * Storage class for Organization objects.
 */
class _Organization{
  //TODO Make it possible to invalidate cached items.
  var _cache = new Map<int, model.Organization>();

  _Organization();

  /**
   * Fetch an organization by [id] from Alice if there is no cache of it.
   */
  void get(int id, OrganizationSubscriber onComplete) {
    if (_cache.containsKey(id)) {
      onComplete(_cache[id]);

    }else{
      log.debug('${id} is not cached');
      new protocol.Organization.get(id)
          ..onSuccess((text) {
            var org = new model.Organization(json.parse(text));
            _cache[org.id] = org;
            onComplete(org);
          })
          ..onNotFound((){
            //TODO Do something.
          })
          ..onError((){
            //TODO Do something.
          })
          ..send();
    }
  }
}