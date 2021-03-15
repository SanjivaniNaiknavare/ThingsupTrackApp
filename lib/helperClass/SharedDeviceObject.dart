
class SharedDeviceObject
{
  SharedDeviceObject({this.id,this.deviceid,this.userid,this.token,this.name});

  int id;
  int deviceid;
  int userid;
  String token;
  String name;

  SharedDeviceObject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deviceid = json['deviceid'],
        userid = json['userid'],
        token = json['token'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'deviceid':deviceid,
      'userid':userid,
      'token':token,
      'name':name,
    };
  }
}
