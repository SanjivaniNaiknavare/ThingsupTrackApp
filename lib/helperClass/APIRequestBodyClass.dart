import 'package:json_annotation/json_annotation.dart';
@JsonSerializable(nullable: false)
class AddUserClass
{
  AddUserClass({this.userid,this.name,this.password,this.role,this.disabled,this.phone,this.twelvehourformat,this.custommap,this.devices});

  String userid;
  String name;
  String password;
  String role;
  bool disabled;
  String phone;
  bool twelvehourformat;
  String custommap;
  String devices;

  AddUserClass.fromJson(Map<String, dynamic> json)
      : userid = json['userid'],
        name = json['name'],
        password = json['password'],
        role = json['role'],
        disabled = json['disabled'],
        phone = json['phone'],
        twelvehourformat = json['twelvehourformat'],
        custommap = json['custommap'],
        devices = json['devices'];

  Map<String, dynamic> toJson() {
    return {
      'userid':userid,
      'name':name,
      'password':password,
      'role':role,
      'disabled':disabled,
      'phone':phone,
      'twelvehourformat':twelvehourformat,
      'custommap':custommap,
      'devices':devices,
    };
  }
}

class UpdateUserClass
{
  UpdateUserClass({this.userid,this.name,this.phone,this.twelvehourformat,this.custommap});

  String userid;
  String name;
  String phone;
  bool twelvehourformat;
  String custommap;

  UpdateUserClass.fromJson(Map<String, dynamic> json)
      : userid = json['userid'],
        name = json['name'],
        phone = json['phone'],
        twelvehourformat = json['twelvehourformat'],
        custommap = json['custommap'];

  Map<String, dynamic> toJson() {
    return {
      'userid':userid,
      'name':name,
      'phone':phone,
      'twelvehourformat':twelvehourformat,
      'custommap':custommap,
    };
  }
}

//{
//    "name":"testdevice",
//    "uniqueid":"TestDevice3",
//    "static":{
//        "lat":12.34,
//        "lng":13.5
//    },
//    "groupid":null,
//    "phone":"",
//    "model":"",
//    "contact":"",
//    "type":"car"
//}

class LatLngClass
{
  LatLngClass({this.lat,this.lng});

  double lat;
  double lng;
  LatLngClass.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lng = json['lng'];

  Map<String, dynamic> toJson() {
    return {
      'lat':lat,
      'lng':lng,
    };
  }
}

class AddAndUpdateDeviceClass
{
  AddAndUpdateDeviceClass({this.name,this.uniqueid,this.static,this.groupid,this.phone,this.model,this.contact,this.type});

  String name;
  String uniqueid;
  LatLngClass static;
  String groupid;
  String phone;
  String model;
  String contact;
  String type;

  AddAndUpdateDeviceClass.fromJson(Map<String, dynamic> json)
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


class TagUserToDevice
{
  TagUserToDevice({this.uniqueid,this.taguserid});

  String uniqueid;
  String taguserid;

  TagUserToDevice.fromJson(Map<String, dynamic> json)
      : uniqueid = json['uniqueid'],
        taguserid = json['taguserid'];

  Map<String, dynamic> toJson() {
    return {
      'uniqueid':uniqueid,
      'taguserid':taguserid,
    };
  }
}


