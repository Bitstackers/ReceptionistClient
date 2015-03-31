part of view;

class ContactCalendar extends Widget {
  Place              _myPlace;
  Model.UIContactCalendar _ui;

  ContactCalendar(Model.UIModel this._ui, Place this._myPlace) {
    _registerEventListeners();
  }

  void _activateMe(_) {
    _navigateToMyPlace();
  }

  @override
  Place get myPlace => _myPlace;

  /**
   *
   */
  void _registerEventListeners() {
    _navigate.onGo.listen(_setWidgetState);

    _ui.root.onClick.listen(_activateMe);

    _hotKeys.onAltK.listen(_activateMe);

    // TODO (TL): temporary stuff
    _ui.eventList.onDoubleClick.listen((_) => _navigate.goCalendarEdit());
  }

  @override
  Model.UIModel get ui => _ui;
}
