import 'APIRequestBodyClass.dart';

class DeviceObjectOwned
{
  DeviceObjectOwned({this.name,this.uniqueid,this.static,this.groupid,this.phone,this.model,this.contact,this.type});

  String name;
  String uniqueid;
  LatLngClass static;
  String groupid;
  String phone;
  String model;
  String contact;
  String type;

  DeviceObjectOwned.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uniqueid = json['uniqueid'],
        static = json['static'],
        groupid = json['groupid'],
        phone = json['phone'],
        model = json['model'],
        contact = json['contact'],
        type = json['type'];

  Map<String, dynamic> toJson() {
    return {
      'name':name,
      'uniqueid':uniqueid,
      'static':static,
      'groupid':groupid,
      'phone':phone,
      'model':model,
      'contact':contact,
      'type':type,
    };
  }
}

class DeviceObjectAllAccount
{
  DeviceObjectAllAccount({this.id,this.name,this.uniqueid,this.static,this.groupid,this.phone,this.model,this.contact,this.type});

  int id;
  String name;
  String uniqueid;
  LatLngClass static;
  String groupid;
  String phone;
  String model;
  String contact;
  String type;

  DeviceObjectAllAccount.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        uniqueid = json['uniqueid'],
        static = json['static'],
        groupid = json['groupid'],
        phone = json['phone'],
        model = json['model'],
        contact = json['contact'],
        type = json['type'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name':name,
      'uniqueid':uniqueid,
      'static':static,
      'groupid':groupid,
      'phone':phone,
      'model':model,
      'contact':contact,
      'type':type,
    };
  }
}

