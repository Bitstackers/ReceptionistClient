part of view;

class ReceptionCommands extends Widget {
  Place                _myPlace;
  DomReceptionCommands _dom;

  /**
   *
   */
  ReceptionCommands(DomReceptionCommands this._dom, Place this._myPlace) {
    _registerEventListeners();
  }

  void _activateMe(_) {
    _navigateToMyPlace();
  }

  @override
  HtmlElement get focusElement => _dom.commandList;

  @override
  Place get myPlace => _myPlace;

  void _registerEventListeners() {
    _navigate.onGo.listen(_setWidgetState);

    _dom.root.onClick.listen(_activateMe);

    _hotKeys.onAltH .listen(_activateMe);
  }

  @override
  HtmlElement get root => _dom.root;
}