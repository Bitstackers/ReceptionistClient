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

part of model;

/**
 * TODO (TL): Comment
 */
class UIMessageCompose extends UIModel {
  HtmlElement      _myFirstTabElement;
  HtmlElement      _myFocusElement;
  HtmlElement      _myLastTabElement;
  final DivElement _myRoot;

  /**
   * Constructor.
   */
  UIMessageCompose(DivElement this._myRoot) {
    _myFocusElement    = _messageTextarea;
    _myFirstTabElement = _callerNameInput;
    _myLastTabElement  = _draftInput;

    _setupLocalKeys();
    _observers();
  }

  @override HtmlElement get _firstTabElement => _myFirstTabElement;
  @override HtmlElement get _focusElement    => _myFocusElement;
  @override HtmlElement get _lastTabElement  => _myLastTabElement;
  @override HtmlElement get _root            => _myRoot;

  InputElement         get _callerNameInput    => _root.querySelector('.names input.caller');
  InputElement         get _callsBackInput     => _root.querySelector('.checks .calls-back');
  ButtonElement        get _cancelButton       => _root.querySelector('.buttons .cancel');
  InputElement         get _cellphoneInput     => _root.querySelector('.phone-numbers input.cell');
  InputElement         get _companyNameInput   => _root.querySelector('.names input.company');
  InputElement         get _draftInput         => _root.querySelector('.checks .draft');
  InputElement         get _extensionInput     => _root.querySelector('.phone-numbers input.extension');
  InputElement         get _landlineInput      => _root.querySelector('.phone-numbers input.landline');
  TextAreaElement      get _messageTextarea    => _root.querySelector('.message textarea');
  InputElement         get _pleaseCallInput    => _root.querySelector('.checks .please-call');
  DivElement           get _recipientsDiv      => _root.querySelector('.recipients');
  ButtonElement        get _saveButton         => _root.querySelector('.buttons .save');
  ButtonElement        get _sendButton         => _root.querySelector('.buttons .send');
  SpanElement          get _showRecipientsSpan => _root.querySelector('.show-recipients');
  ElementList<Element> get _tabElements        => _root.querySelectorAll('[tabindex]');
  InputElement         get _urgentInput        => _root.querySelector('.checks .urgent');

  /**
   * Make sure we never take focus away from an already focused element, unless
   * we're [event].target is another widget member with tabindex set > 0.
   */
  void _handleMouseDown(MouseEvent event) {
    if((event.target as HtmlElement).tabIndex < 1) {
      /// NOTE (TL): This keeps focus on the currently focused field when
      /// clicking the _root.
      event.preventDefault();
    }
  }

  /**
   * Return the click event stream for the cancel button.
   */
  Stream<MouseEvent> get onCancel => _cancelButton.onClick;

  /**
   * Return the click event stream for the save button.
   */
  Stream<MouseEvent> get onSave => _saveButton.onClick;

  /**
   * Return the click event stream for the send button.
   */
  Stream<MouseEvent> get onSend => _sendButton.onClick;

  /**
   * Observers.
   */
  void _observers() {
    _root.onKeyDown.listen(_keyboard.press);

    _root.onMouseDown.listen(_handleMouseDown);

    /// Enables focused element memory for this widget.
    _tabElements.forEach((HtmlElement element) {
      element.onFocus.listen((Event event) => _myFocusElement = (event.target as HtmlElement));
    });

    _showRecipientsSpan.onMouseOver.listen(_toggleRecipients);
    _showRecipientsSpan.onMouseOut .listen(_toggleRecipients);

    _callerNameInput.onInput.listen(_toggleButtons);
    _messageTextarea.onInput.listen(_toggleButtons);
  }

  /**
   * Setup keys and bindings to methods specific for this widget.
   */
  void _setupLocalKeys() {
    _hotKeys.registerKeys(_keyboard, _defaultKeyMap());
  }

  /**
   * Enable/disable the widget buttons and as a sideeffect set the value of
   * [_myLastTabElement] as this depends on the state of the buttons.
   */
  void _toggleButtons(_) {
    final bool toggle = !(_callerNameInput.value.trim().isNotEmpty && _messageTextarea.value.trim().isNotEmpty);

    _cancelButton.disabled = toggle;
    _saveButton.disabled = toggle;
    _sendButton.disabled = toggle;

    _myLastTabElement = toggle ? _draftInput : _sendButton;
  }

  /**
   * Show/hide the recipients list.
   */
  void _toggleRecipients(_) {
    _recipientsDiv.classes.toggle('recipients-hidden');
  }
}