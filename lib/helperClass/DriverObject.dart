
class DriverObject
{
  DriverObject({this.id,this.driverid,this.name,this.phone,this.photo,this.attributes});

  String id;
  String driverid;
  String name;
  String phone;
  String photo;
  String attributes;

  DriverObject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        driverid = json['driverid'],
        name = json['name'],
        phone = json['phone'],
        photo = json['photo'],
        attributes = json['attributes'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'driverid':driverid,
      'name':name,
      'phone':phone,
      'photo':photo,
      'attributes':attributes,
    };
  }
}

class TaggedDriverObject
{
  TaggedDriverObject({this.id,this.uniqueid,this.name});

  String id;
  String uniqueid;
  String name;


  TaggedDriverObject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uniqueid = json['uniqueid'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'uniqueid':uniqueid,
      'name':name,
    };
  }
}