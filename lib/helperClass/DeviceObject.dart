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
  DeviceObjectAllAccount({this.id,
    this.deviceid,
    this.name,
    this.uniqueid,
    this.static,
    this.groupid,
    this.phone,
    this.model,
    this.contact,
    this.type,
    this.lastUpdate,
    this.speed,
    this.valid,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.attributes,
    this.moving,
    this.idle,
    this.offline,
    this.stopped,
    this.status,
    this.course
  });

  int id;
  int deviceid;
  String name;
  String uniqueid;
  LatLngClass static;
  String groupid;
  String phone;
  String model;
  String contact;
  String type;
  String lastUpdate;
  double speed;
  int valid;
  double latitude;
  double longitude;
  int accuracy;
  Map<String,dynamic> attributes;
  bool moving;
  bool idle;
  bool offline;
  bool stopped;
  String status;
  int course;


  DeviceObjectAllAccount.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deviceid = json['deviceid'],
        name = json['name'],
        uniqueid = json['uniqueid'],
        static = json['static'],
        groupid = json['groupid'],
        phone = json['phone'],
        model = json['model'],
        contact = json['contact'],
        type = json['type'],
        lastUpdate = json['lastUpdate'],
        speed = json['speed'],
        valid = json['valid'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        accuracy = json['accuracy'],
        attributes = json['attributes'],
        moving = json['moving'],
        idle = json['idle'],
        offline = json['offline'],
        stopped = json['stopped'],
        status = json['status'],
        course = json['course'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'deviceid':deviceid,
      'name':name,
      'uniqueid':uniqueid,
      'static':static,
      'groupid':groupid,
      'phone':phone,
      'model':model,
      'contact':contact,
      'type':type,
      'lastUpdate':lastUpdate,
      'speed':speed,
      'valid':valid,
      'latitude':latitude,
      'longitude':longitude,
      'accuracy':accuracy,
      'attributes':attributes,
      'moving':moving,
      'idle':idle,
      'offline':offline,
      'stopped':stopped,
      'status':status,
      'course':course,

    };
  }
}

