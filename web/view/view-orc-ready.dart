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
 * This class is responsible for instantiating all the widgets when then
 * [Model.AppClientState] is [Model.AppState.READY].
 */
class ORCReady {
  final Model.AppClientState _appState;
  final Controller.Calendar _calendarController;
  final Controller.Call _callController;
  final ORModel.ClientConfiguration _clientConfig;
  final Controller.Contact _contactController;
  ContactSelector _contactSelector;
  final Controller.DistributionList _distributionListController;
  final Controller.Endpoint _endpointController;
  Map<String, String> _langMap;
  MessageCompose _messageCompose;
  Controller.Message _messageController;
  Controller.Notification _notification;
  Controller.Popup _popup;
  final Controller.Reception _receptionController;
  ReceptionSelector _receptionSelector;
  static ORCReady _singleton;
  List<ORModel.Reception> _sortedReceptions;
  final Controller.Sound _sound;
  final Controller.User _userController;
  final Model.UIORCReady _ui;

  /**
   * Constructor.
   */
  factory ORCReady(
      Model.AppClientState appState,
      Model.UIORCReady uiReady,
      Controller.Calendar calendarController,
      ORModel.ClientConfiguration clientConfig,
      Controller.Contact contactController,
      Controller.Reception receptionController,
      List<ORModel.Reception> sortedReceptions,
      Controller.User userController,
      Controller.Call callController,
      Controller.Notification notification,
      Controller.Message message,
      Controller.DistributionList distributionListController,
      Controller.Endpoint endpointController,
      Controller.Popup popup,
      Controller.Sound sound,
      Map<String, String> langMap) {
    if (_singleton == null) {
      _singleton = new ORCReady._internal(
          appState,
          uiReady,
          calendarController,
          clientConfig,
          contactController,
          receptionController,
          sortedReceptions,
          userController,
          callController,
          notification,
          message,
          distributionListController,
          endpointController,
          popup,
          sound,
          langMap);
    }

    return _singleton;
  }

  /**
   * Internal constructor.
   */
  ORCReady._internal(
      Model.AppClientState this._appState,
      Model.UIORCReady this._ui,
      this._calendarController,
      this._clientConfig,
      this._contactController,
      this._receptionController,
      this._sortedReceptions,
      this._userController,
      this._callController,
      this._notification,
      this._messageController,
      this._distributionListController,
      this._endpointController,
      this._popup,
      this._sound,
      this._langMap) {
    _observers();
  }

  /**
   * Observers.
   */
  void _observers() {
    _appState.onStateChange.listen((Model.AppState appState) =>
        appState == Model.AppState.ready ? _runApp() : _ui.visible = false);
  }

  /**
   * Go visible and instantiate all the widgets.
   */
  void _runApp() {
    final ORUtil.WeekDays _weekDays = new ORUtil.WeekDays(
        _langMap[Key.dayMonday],
        _langMap[Key.dayTuesday],
        _langMap[Key.dayWednesday],
        _langMap[Key.dayThursday],
        _langMap[Key.dayFriday],
        _langMap[Key.daySaturday],
        _langMap[Key.daySunday]);
    Model.UICalendar _uiCalendar =
        new Model.UICalendar(querySelector('#calendar'), _weekDays, _langMap);
    Model.UIContactData _uiContactData =
        new Model.UIContactData(querySelector('#contact-data'));
    Model.UIContactSelector _uiContactSelector = new Model.UIContactSelector(
        querySelector('#contact-selector'), _popup, _langMap);
    Model.UIMessageArchive _uiMessageArchive = new Model.UIMessageArchive(
        querySelector('#message-archive'), _weekDays, _langMap);
    Model.UIMessageCompose _uiMessageCompose =
        new Model.UIMessageCompose(querySelector('#message-compose'));
    Model.UIReceptionSelector _uiReceptionSelector =
        new Model.UIReceptionSelector(
            querySelector('#reception-selector'), _popup, _langMap);

    new Contexts(new Model.UIContexts());
    new Hint(new Model.UIHint());

    _userController
        .getState(_appState.currentUser)
        .then((ORModel.UserStatus userStatus) {
      new AgentInfo(new Model.UIAgentInfo(querySelector('#agent-info')),
          _appState, _userController, _notification, _callController);

      new GlobalCallQueue(
          new Model.UIGlobalCallQueue(
              querySelector('#global-call-queue'),
              _langMap,
              _clientConfig.hideInboundCallerId,
              _clientConfig.myIdentifiers),
          _appState,
          new Controller.Destination(
              Controller.Context.home, Controller.Widget.globalCallQueue),
          _notification,
          _callController,
          _sound,
          userStatus);
    });

    new Calendar(
        _uiCalendar,
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.calendar),
        _uiContactSelector,
        _uiReceptionSelector,
        _contactController,
        _calendarController,
        _notification);

    new ContactData(
        _uiContactData,
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.contactData),
        _uiContactSelector,
        _uiReceptionSelector,
        _popup,
        _langMap);

    new CalendarEditor(
        new Model.UICalendarEditor(
            querySelector('#calendar-editor'), _weekDays, _langMap),
        new Controller.Destination(
            Controller.Context.calendarEdit, Controller.Widget.calendarEditor),
        _uiCalendar,
        _uiContactSelector,
        _uiReceptionSelector,
        _calendarController,
        _popup,
        _langMap);

    _contactSelector = new ContactSelector(
        _uiContactSelector,
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.contactSelector),
        _uiReceptionSelector,
        _contactController);

    new MessageArchive(
        _uiMessageArchive,
        new Controller.Destination(
            Controller.Context.messages, Controller.Widget.messageArchive),
        _messageController,
        _userController,
        _uiContactSelector,
        _uiReceptionSelector,
        _uiMessageCompose,
        _popup,
        _langMap);

    _messageCompose = new MessageCompose(
        _uiMessageCompose,
        _uiMessageArchive,
        _appState,
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.messageCompose),
        _uiContactSelector,
        _uiReceptionSelector,
        _messageController,
        _notification,
        _distributionListController,
        _endpointController,
        _popup,
        _langMap);

    new MyCallQueue(
        new Model.UIMyCallQueue(querySelector('#my-call-queue'), _langMap,
            _contactController, _receptionController),
        _uiMessageCompose,
        _appState,
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.myCallQueue),
        _notification,
        _callController,
        _popup,
        _langMap,
        _uiContactData,
        _uiContactSelector,
        _uiReceptionSelector);

    new ReceptionAddresses(
        new Model.UIReceptionAddresses(querySelector('#reception-addresses')),
        new Controller.Destination(
            Controller.Context.homePlus, Controller.Widget.receptionAddresses),
        _uiReceptionSelector);

    new ReceptionAltNames(
        new Model.UIReceptionAltNames(querySelector('#reception-alt-names')),
        new Controller.Destination(
            Controller.Context.homePlus, Controller.Widget.receptionAltNames),
        _uiReceptionSelector);

    new ReceptionBankInfo(
        new Model.UIReceptionBankInfo(querySelector('#reception-bank-info')),
        new Controller.Destination(
            Controller.Context.homePlus, Controller.Widget.receptionBankInfo),
        _uiReceptionSelector);

    new ReceptionCommands(
        new Model.UIReceptionCommands(querySelector('#reception-commands')),
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.receptionCommands),
        _uiReceptionSelector);

    new ReceptionEmail(
        new Model.UIReceptionEmail(querySelector('#reception-email')),
        new Controller.Destination(
            Controller.Context.homePlus, Controller.Widget.receptionEmail),
        _uiReceptionSelector);

    new ReceptionMiniWiki(
        new Model.UIReceptionMiniWiki(querySelector('#reception-mini-wiki')),
        new Controller.Destination(
            Controller.Context.homePlus, Controller.Widget.receptionMiniWiki),
        _uiReceptionSelector);

    new ReceptionOpeningHours(
        new Model.UIReceptionOpeningHours(
            querySelector('#reception-opening-hours')),
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.receptionOpeningHours),
        _uiReceptionSelector);

    new ReceptionProduct(
        new Model.UIReceptionProduct(querySelector('#reception-product')),
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.receptionProduct),
        _uiReceptionSelector);

    new ReceptionSalesmen(
        new Model.UIReceptionSalesmen(querySelector('#reception-salesmen')),
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.receptionSalesmen),
        _uiReceptionSelector);

    _receptionSelector = new ReceptionSelector(
        _uiReceptionSelector,
        _appState,
        new Controller.Destination(
            Controller.Context.home, Controller.Widget.receptionSelector),
        _notification,
        _sortedReceptions,
        _receptionController,
        _popup,
        _langMap);

    new ReceptionTelephoneNumbers(
        new Model.UIReceptionTelephoneNumbers(
            querySelector('#reception-telephone-numbers')),
        new Controller.Destination(Controller.Context.homePlus,
            Controller.Widget.receptionTelephoneNumbers),
        _uiReceptionSelector);

    new ReceptionType(
        new Model.UIReceptionType(querySelector('#reception-type')),
        new Controller.Destination(
            Controller.Context.homePlus, Controller.Widget.receptionType),
        _uiReceptionSelector,
        _langMap);

    new ReceptionVATNumbers(
        new Model.UIReceptionVATNumbers(
            querySelector('#reception-vat-numbers')),
        new Controller.Destination(
            Controller.Context.homePlus, Controller.Widget.receptionVATNumbers),
        _uiReceptionSelector);

    new ReceptionWebsites(
        new Model.UIReceptionWebsites(querySelector('#reception-websites')),
        new Controller.Destination(
            Controller.Context.homePlus, Controller.Widget.receptionWebsites),
        _uiReceptionSelector);

    new WelcomeMessage(
        new Model.UIWelcomeMessage(querySelector('#welcome-message')),
        _appState,
        _uiReceptionSelector,
        _langMap);

    _ui.visible = true;

    window.location.hash.isEmpty
        ? _navigate.goHome()
        : _navigate.goWindowLocation();
  }
}
