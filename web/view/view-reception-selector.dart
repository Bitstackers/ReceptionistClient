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
  final Model.AppClientState _appState;
  final Map<String, String> _langMap;
  final Controller.Destination _myDestination;
  final Controller.Notification _notification;
  final Controller.Popup _popup;
  final Controller.Reception _receptionController;
  final List<ORModel.Reception> _receptions;
  bool _refreshReceptionsCache = false;
  Timer refreshReceptionsCacheTimer;
  final Model.UIReceptionSelector _uiModel;

  /**
   * Constructor.
   */
  ReceptionSelector(
      Model.UIReceptionSelector this._uiModel,
      Model.AppClientState this._appState,
      Controller.Destination this._myDestination,
      Controller.Notification this._notification,
      List<ORModel.Reception> this._receptions,
      Controller.Reception this._receptionController,
      Controller.Popup this._popup,
      Map<String, String> this._langMap) {
    _ui.setHint('alt+v');

    _ui.receptions = _receptions;

    _observers();
  }

  @override Controller.Destination get _destination => _myDestination;
  @override Model.UIReceptionSelector get _ui => _uiModel;

  @override void _onBlur(_) {}
  @override void _onFocus(_) {}

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

    _notification.onReceptionChange.listen((_) => _refreshReceptionsCache = true);

    refreshReceptionsCacheTimer = new Timer.periodic(new Duration(seconds: 5), (_) {
      if (_refreshReceptionsCache) {
        _refreshReceptionsCache = false;
        _popup.info(_langMap[Key.receptionChanged], '', closeAfter: new Duration(seconds: 3));
        _receptionController.list().then((Iterable<ORModel.Reception> receptions) {
          _ui.receptionsCache = receptions.toList()
            ..sort((x, y) => x.name.toLowerCase().compareTo(y.name.toLowerCase()));
        });
      }
    });

    _appState.activeCallChanged.listen((ORModel.Call newCall) {
      if (newCall != ORModel.Call.noCall &&
          newCall.inbound &&
          _ui.selectedReception.ID != newCall.receptionID) {
        _ui.reset();
        _ui.changeActiveReception(newCall.receptionID);
      }
    });
  }
}
