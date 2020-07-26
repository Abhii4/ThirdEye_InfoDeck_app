class Retailer{
  String _name;
  String _phone;
  String _gst;
  String _address;
  String _retailerId;
  String _location;
  String _profileUrl;


  Retailer(this._name,this._phone,this._gst,this._address,this._retailerId,this._location,this._profileUrl);

  Retailer.map(dynamic obj){
    this._name = obj['name'];
    this._phone = obj['phone'];
    this._gst = obj['gst'];
    this._address = obj['address'];
    this._retailerId = obj['retailedId'];
    this._location = obj['location'];
    this._profileUrl = obj['profileUrl'];

  }

  String get  name=> _name;
  String get phone => _phone;
  String get gst => _gst;
  String get address => _address;
  String get retailerId => _retailerId;
  String get location => _location;
  String get profileUrl => _profileUrl;


  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map['name']=_name;
    map['phone'] = _phone;
    map['gst'] = _gst;
    map['address'] = _address;
    map ['retailerId'] = _retailerId;
    map ['location'] = _location;
    map  ['profileUrl'] = _profileUrl;

     return map;
  }

  Retailer.fromMap(Map<String,dynamic> map){
    this._name= map['name'];
    this._phone = map['phone'];
    this._gst = map['gst'];
    this._address = map['address'];
    this._retailerId = map ['retailerId'];
    this._location = map ['location'];
    this._profileUrl = map['profileUrl'];


  }
}