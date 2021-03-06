
class SharedDeviceObject
{
  SharedDeviceObject({this.id,this.deviceid,this.userid,this.token});

  int id;
  int deviceid;
  int userid;
  String token;

  SharedDeviceObject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deviceid = json['deviceid'],
        userid = json['userid'],
        token = json['token'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'deviceid':deviceid,
      'userid':userid,
      'token':token,
    };
  }
}
