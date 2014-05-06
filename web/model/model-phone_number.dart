part of model;

class PhoneNumber {
  int    _phoneID;
  int    _priority;
  String _value;
  String _kind;
  
  int    get phoneID     => _phoneID; 
  int    get priority    => _priority; 
  String get kind        => _kind;
  String get value       => _value;
  
  int compareTo(PhoneNumber other) => priority - other.priority;

  PhoneNumber ();
  
  PhoneNumber.fromMap(Map map) {
    this._value    = map['value'];
    this._kind     = map['kind'];
    this._phoneID  = map['id'];
    this._priority = map['priority'];
    
    if (this._priority == null) {
      this._priority = 0;
    }
  }
  
  @override
  String toString () {
    return '${this.kind}:${this.value}, ID: ${this.phoneID}, priority: ${this.priority}' ;
  }
}

class DiablePhoneNumber extends PhoneNumber {
  int    _contactID;
  int    _receptionID;
  
  int get contactID   => _contactID; 
  int get receptionID => _receptionID; 
  
  int compareTo(PhoneNumber other) => this.priority - other.priority;

  DiablePhoneNumber.from(PhoneNumber number, Contact context) {
    this._value    = number._value;
    this._kind     = number._kind;
    this._phoneID  = number._phoneID;
    this._priority = number._priority;

    this._contactID   = context.id;
    this._receptionID = context.receptionID;
  }
  
  String toLabel () {
    return '${this.value}';
  }
  
  @override
  String toString () {
    return '${super.toString()}, context:${contactID}@${receptionID}';
  }

}