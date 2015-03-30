part of view;

class Contexts {
  Map<String, HtmlElement> _contextMap;
  DomContexts              _dom;

  /**
   *
   */
  Contexts(DomContexts this._dom) {
    _contextMap = {'context-calendar-edit': _dom.contextCalendarEdit,
                   'context-home'         : _dom.contextHome,
                   'context-homeplus'     : _dom.contextHomeplus,
                   'context-messages'     : _dom.contextMessages};

    _registerEventListeners();
  }

  /**
   *
   */
  void onNavigation(Place place) {
    _contextMap.forEach((id, element) {
      id == place.contextId ? _setVisible(element) : _setHidden(element);
    });
  }

  /**
   *
   */
  void _registerEventListeners() {
    _navigate.onGo.listen(onNavigation);

    _hotKeys.onAltQ.listen((_) => _navigate.goHome());
    _hotKeys.onAltW.listen((_) => _navigate.goHomeplus());
    _hotKeys.onAltE.listen((_) => _navigate.goMessages());
  }

  /**
   *
   */
  void _setHidden(HtmlElement element) {
    element.style.zIndex = '0';
  }

  /**
   *
   */
  void _setVisible(HtmlElement element) {
    element.style.zIndex = '1';
  }
}