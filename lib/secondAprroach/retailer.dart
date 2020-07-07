class Retailer{
  String _name;
  String _phone;
  String _gst;
  String _address;
  String _retailerId;

  Retailer(this._name,this._phone,this._gst,this._address,this._retailerId);

  Retailer.map(dynamic obj){
    this._name = obj['name'];
    this._phone = obj['phone'];
    this._gst = obj['gst'];
    this._address = obj['address'];
    this._retailerId = obj['retailedId'];
  }

  String get  name=> _name;
  String get phone => _phone;
  String get gst => _gst;
  String get address => _address;
  String get retailerId => _retailerId;

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map['name']=_name;
    map['phone'] = _phone;
    map['gst'] = _gst;
    map['address'] = _address;
    map ['retailerId'] = _retailerId;
    return map;
  }

  Retailer.fromMap(Map<String,dynamic> map){
    this._name= map['name'];
    this._phone = map['phone'];
    this._gst = map['gst'];
    this._address = map['address'];
    this._retailerId = map ['retailerId'];

  }
}