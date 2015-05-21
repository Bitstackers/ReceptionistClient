/*                  This file is part of OpenReception
                   Copyright (C) 2015-, BitStackers K/S

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

/**
 * The reception selector widget.
 */
class ReceptionSelector extends ViewWidget {
  final Controller.Destination    _myDestination;
  final Model.UIReceptionSelector _uiModel;
  final List<Model.Reception>     _receptions;

  /**
   * Constructor.
   */
  ReceptionSelector(Model.UIReceptionSelector this._uiModel,
                    Controller.Destination this._myDestination,
                    List<Model.Reception> this._receptions) {
    _ui.setHint('alt+v');

    _ui.receptions = _receptions;

    _observers();
  }

  @override Controller.Destination    get _destination => _myDestination;
  @override Model.UIReceptionSelector get _ui          => _uiModel;

  @override void _onBlur(_){}
  @override void _onFocus(_){}

  /**
   * Activate this widget if it's not already activated.
   */
  void _activateMe(_) {
    _navigateToMyDestination();
  }

  /**
   * Observers.
   */
  void _observers() {
    _navigate.onGo.listen(_setWidgetState);

    _hotKeys.onAltV.listen(_activateMe);

    _ui.onClick.listen(_activateMe);

    Model.Call.activeCallChanged.listen((Model.Call newCall) {
      if (newCall != Model.Call.noCall) {
        _ui.changeActiveReception(newCall.receptionID);
      }
    });
  }
}
