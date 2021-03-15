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

class UserIDClass
{
  UserIDClass({this.userid});

  String userid;

  UserIDClass.fromJson(Map<String, dynamic> json)
      : userid = json['userid'];

  Map<String, dynamic> toJson() {
    return {
      'userid':userid,
    };
  }
}

class AddGeofenceClass
{
  AddGeofenceClass({this.name,this.description,this.area,this.attributes});

  String name;
  String description;
  List<LatLngClass> area;
  AttributeClass attributes;

  AddGeofenceClass.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        area = json['area'],
        attributes = json['attributes'];

  Map<String, dynamic> toJson() {
    return {
      'name':name,
      'description':description,
      'area':area,
      'attributes':attributes,
    };
  }
}

class UpdateGeofenceClass
{
  UpdateGeofenceClass({this.name,this.description,this.area,this.attributes,this.id});

  String name;
  String description;
  List<LatLngClass> area;
  AttributeClass attributes;
  String id;

  UpdateGeofenceClass.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        area = json['area'],
        attributes = json['attributes'],
        id = json['id'];

  Map<String, dynamic> toJson() {
    return {
      'name':name,
      'description':description,
      'area':area,
      'attributes':attributes,
      'id':id,
    };
  }
}

class AttributeClass
{
  AttributeClass(this.key, this.value);

  dynamic key;
  dynamic value;

  AttributeClass.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        value = double.parse(json['value'].toString().replaceAll(",", ""));

  Map toJson() => {
    key: value,
  };
}

class AddDriverClass
{
  AddDriverClass({this.name,this.phone,this.photo,this.attributes});

  String name;
  String phone;
  String photo;
  AttributeClass attributes;

  AddDriverClass.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        photo = json['photo'],
        attributes = json['attributes'];

  Map<String, dynamic> toJson() {
    return {
      'name':name,
      'phone':phone,
      'photo':photo,
      'attributes':attributes,
    };
  }
}

class UpdateDriverClass
{
  UpdateDriverClass({this.id,this.name,this.phone,this.photo,this.attributes});

  String id;
  String name;
  String phone;
  String photo;
  AttributeClass attributes;

  UpdateDriverClass.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        phone = json['phone'],
        photo = json['photo'],
        attributes = json['attributes'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name':name,
      'phone':phone,
      'photo':photo,
      'attributes':attributes,
    };
  }
}

class TagDriverToDeviceClass
{
  TagDriverToDeviceClass({this.id,this.uniqueid});

  String id;
  String uniqueid;

  TagDriverToDeviceClass.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uniqueid = json['uniqueid'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'uniqueid':uniqueid,
    };
  }
}


class SharingDeviceClass
{
  SharingDeviceClass({this.uniqueid,this.interval});

  String uniqueid;
  int interval;

  SharingDeviceClass.fromJson(Map<String, dynamic> json)
      : interval = json['interval'],
        uniqueid = json['uniqueid'];

  Map<String, dynamic> toJson() {
    return {
      'interval':interval,
      'uniqueid':uniqueid,
    };
  }
}


class AvatarClass
{
  AvatarClass({this.avatar});

  String avatar;

  AvatarClass.fromJson(Map<String, dynamic> json)
      : avatar = json['avatar'];

  Map<String, dynamic> toJson() {
    return {
      'avatar':avatar,
    };
  }
}


