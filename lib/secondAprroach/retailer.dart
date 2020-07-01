class Retailer{
  String _name;
  String _phone;
  String _gst;
  String _address;

  Retailer(this._name,this._phone,this._gst,this._address);

  Retailer.map(dynamic obj){
    this._name = obj['name'];
    this._phone = obj['phone'];
    this._gst = obj['gst'];
    this._address = obj['address'];
  }

  String get  name=> _name;
  String get phone => _phone;
  String get gst => _gst;
  String get address => _address;

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map['name']=_name;
    map['phone'] = _phone;
    map['gst'] = _gst;
    map['address'] = _address;
    return map;
  }

  Retailer.fromMap(Map<String,dynamic> map){
    this._name= map['name'];
    this._phone = map['phone'];
    this._gst = map['gst'];
    this._address = map['address'];

  }
}