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

part of view;

abstract class MessageLabels {
  static final String saveButtonLabel = 'Gem';
  static final String sendButtonLabel = 'Send';
  static final String title = 'Besked';
  static final String cancelButtonLabel = 'Annuller';
  static final String callerPhonePlaceholder = 'Telefon';
  static final String callerCellphonePlaceholder = 'Mobilnummer';
  static final String callerLocalNumberPlaceholder = 'Lokalnr';
  static final String callerCompanyPlaceholder = 'Firmanavn';
  static final String callerNamePlaceholder = 'Opkalders navn';
  static final String searchPlaceholder = 'S&oslash;g..';
  static final String searchResultPlaceholder = 'Ingen data fundet';
  static final String messagePlaceholder = 'Besked';
  static final String pleaseCall = 'Ring venligst';
  static final String callsBack = 'Ringer selv tilbage';
  static final String hasCalled = 'Har ringet';
  static final String urgent = 'Haster';
}

class Message {

  static const String className = '${libraryName}.Message';

  final DivElement element;
  final Context context;
   
  DivElement     get body   => this.element.querySelector('.send-message-container');
  HeadingElement get header => this.element.querySelector('h1');

  InputElement get sendmessagesearchbox    => this.body.querySelector('#${id.SENDMESSAGE_SEARCHBOX}');
  InputElement get sendmessagesearchresult => this.body.querySelector('#sendmessagesearchresult');
  InputElement callerNameField;
  InputElement callerCompanyField;
  InputElement callerPhoneField;
  InputElement callerCellphoneField;
  InputElement callerLocalExtensionField;
  TextAreaElement messageBodyField;

  /// Checkboxes
  InputElement get pleaseCall => this.body.querySelector('#send-message-pleasecall');
  InputElement get callsBack  => this.body.querySelector('#send-message-callsback');
  InputElement get hasCalled  => this.body.querySelector('#send-message-hascalled');
  InputElement get urgent     => this.body.querySelector('#send-message-urgent');
  
  bool hasFocus = false;

  ButtonElement cancelButton;
  ButtonElement draftButton;
  ButtonElement sendButton;

  UListElement recipientsList;

  List<Element> focusElements;

  model.Reception reception = model.nullReception;
  model.Contact contact = model.nullContact;
  List<model.Recipient> recipients = new List<model.Recipient>();

  /**
   * Update the disabled property.
   * 
   * Used for locking the input fields upon sending
   * a message, or when no contact is selected.
   */
  void set isDisabled(bool disabled) {
    this.element.querySelectorAll('input').forEach((InputElement element) {
      element.disabled = disabled;
    });

    this.element.querySelectorAll('textarea').forEach((TextAreaElement element) {
      element.disabled = disabled;
    });

    this.element.querySelectorAll('button').forEach((ButtonElement element) {
      element.disabled = disabled;
    });
  }
  
  /**
   * Update the tabable property.
   * 
   * Used for enabling and disabling the tab button for the widget.
   */
  void set tabable (bool enable) {
    this.element.querySelectorAll('input').forEach((InputElement element) {
      element.tabIndex = enable ? 1 : -1;
    });

    this.element.querySelectorAll('textarea').forEach((TextAreaElement element) {
      element.tabIndex = enable ? 1 : -1;
    });

    this.element.querySelectorAll('button').forEach((ButtonElement element) {
      element.tabIndex = enable ? 1 : -1;
    });
  }

  /**
   * Clears out the content of the input fields.
   */
  void _clearInputFields() {
    
    const String context = '${className}._clear';
    
    this.element.querySelectorAll('input').forEach((InputElement element) {
      element.value = "";
    });

    this.element.querySelectorAll('textarea').forEach((TextAreaElement element) {
      element.value = "";
    });

    log.debugContext('Message Cleared', context);
  }

  Message(DivElement this.element, Context this.context) {
  
    callerNameField = body.querySelector('#sendmessagename');
    callerCompanyField = body.querySelector('#sendmessagecompany');
    callerPhoneField = body.querySelector('#sendmessagephone');
    callerCellphoneField = body.querySelector('#sendmessagecellphone');
    callerLocalExtensionField = body.querySelector('#sendmessagelocalno');
    messageBodyField = body.querySelector('#sendmessagetext');


    cancelButton = body.querySelector('#sendmessagecancel')
        ..text = MessageLabels.cancelButtonLabel
        ..onClick.listen(_cancelClick);

    draftButton = body.querySelector('#sendmessagedraft')
        ..text = MessageLabels.saveButtonLabel
        ..onClick.listen(_draftClick);

    sendButton = body.querySelector('#sendmessagesend')
        ..text = MessageLabels.sendButtonLabel
        ..onClick.listen(_sendHandler);

    recipientsList = querySelector('#send-message-recipient-list');

    focusElements = [sendmessagesearchbox, callerNameField, callerCompanyField, callerPhoneField, callerCellphoneField, callerLocalExtensionField, messageBodyField, pleaseCall, callsBack, hasCalled, urgent, cancelButton, draftButton, sendButton];

    focusElements.forEach((e) => context.registerFocusElement(e));

    this._renderContact(contact);
    this._setupLabels();
    this._registerEventListeners();
  }

  
  void _setupLabels () {
    this.header.text = MessageLabels.title;
    this.callerCellphoneField.placeholder = MessageLabels.callerCellphonePlaceholder; 
    this.callerNameField.placeholder = MessageLabels.callerNamePlaceholder;
    this.callerCompanyField.placeholder = MessageLabels.callerCompanyPlaceholder;
    this.callerPhoneField.placeholder= MessageLabels.callerPhonePlaceholder;
    this.callerLocalExtensionField.placeholder = MessageLabels.callerLocalNumberPlaceholder;
    this.messageBodyField.placeholder = MessageLabels.messagePlaceholder;
    
    /// Checkbox labes.
    this.element.querySelectorAll('label').forEach((LabelElement label) {
      final String labelFor = label.attributes['for'];
      
      if (labelFor == this.pleaseCall.id) {
        label.text = MessageLabels.pleaseCall;
      } else if (labelFor == this.callsBack.id) {
        label.text = MessageLabels.callsBack;
      } else if (labelFor == this.hasCalled.id) {
        label.text =  MessageLabels.hasCalled;
      } else if (labelFor == this.urgent.id) {
        label.text = MessageLabels.urgent;
      }
    });
    }
  
  /**
   * Re-renders the recipient list.
   */
  void _renderRecipientList() {
    // Updates the recipient list.
    recipientsList.children.clear();
    this.recipients.forEach((model.Recipient recipient) {
      recipientsList.children.add(new LIElement()..text = recipient.role + ": " + recipient.contactName);
    });
  }

  /**
   * Click handler for the entire message element. Sets the focus to the widget.
   */
  void _onMessageElementClick(_) {
    const String context = '${className}._onMessageElementClick';
    Controller.Context.changeLocation(new nav.Location(id.CONTEXT_HOME, id.SENDMESSAGE, id.SENDMESSAGE_CELLPHONE));
  }

  /**
   * Event handler responsible for selecting the current widget.
   */
  void _onLocationChanged(nav.Location location) {
    this.hasFocus = (location.widgetId == element.id);
    
    element.classes.toggle('focus', this.hasFocus);
    this.tabable = this.hasFocus;
    
    if (location.elementId != null) {
      var elem = element.querySelector('#${location.elementId}');
      if (elem != null) {
        elem.focus();
      }
    }
  }

  /**
   * Event handler responsible for updating the recipient list (and UI) when a contact is changed.
   */
  void _renderContact(model.Contact contact) {
    this.contact = contact;

    this.recipients.clear();
    if (this.contact != model.Contact.noContact) {
      this.isDisabled = false;
      contact.dereferenceDistributionList().then((List<model.Recipient> dereferencedDistributionList) {
        // Put all the dereferenced recipients to the local list.
        dereferencedDistributionList.forEach((model.Recipient recipient) {
          this.recipients.add(recipient);
        });

        this._renderRecipientList();
      });
    } else {
      this.isDisabled = true;
      this._renderRecipientList();
    }
  }

  void _registerEventListeners() {
    element.onClick.listen(this._onMessageElementClick);
    event.bus.on(event.locationChanged).listen(this._onLocationChanged);

    event.bus.on(event.contactChanged).listen(this._renderContact);

    event.bus.on(event.receptionChanged).listen((model.Reception value) {
      reception = value;
    });

    event.bus.on(event.callChanged).listen((model.Call value) {
      callerPhoneField.value = '${value.callerId}';
    });

    element.onClick.listen((MouseEvent e) {
      if ((e.target as Element).attributes.containsKey('tabindex')) {
        event.bus.fire(event.locationChanged, new nav.Location(context.id, element.id, (e.target as Element).id));
      }
    });
  }

  void _cancelClick(_) {
    this._clearInputFields();
  }

  void _draftClick(_) {
    const String context = '${className}.draftClick';

    log.fixmeContext("Not implemented!", context);
  }

  /**
   * Harvests and prepares the message from the input fields and
   * sends is via the Message Service.
   */
  void _sendHandler(_) {
    contact.contextMap().then((Map contextMap) {
      model.Message pendingMessage = new model.Message.fromMap({
        'message': messageBodyField.value,
        'phone': callerPhoneField.value,
        'caller': {
          'name': callerNameField.value,
          'company': callerCompanyField.value,
          'phone': callerPhoneField.value,
          'cellphone': callerCellphoneField.value,
          'localextension': callerLocalExtensionField.value
        },
        'context': contextMap,
        'flags': []
      });


      pleaseCall.checked ? pendingMessage.addFlag('urgent') : null;
      callsBack.checked ? pendingMessage.addFlag('willCallBack') : null;
      hasCalled.checked ? pendingMessage.addFlag('called') : null;
      urgent.checked ? pendingMessage.addFlag('urgent') : null;


      for (model.Recipient recipient in this.recipients) {
        pendingMessage.addRecipient(recipient);
      }

      this.isDisabled = true;

      pendingMessage.send().then((_) {
        log.debug('Sent message');
        this._clearInputFields();
        this.isDisabled = false;
      }).catchError((error) {
        this.isDisabled = false;
        log.debug('----- Send Message Unlucky Result: ${error}');
      });
    });
  }
}