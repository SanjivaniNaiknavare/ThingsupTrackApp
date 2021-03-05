import 'APIRequestBodyClass.dart';

class GeofenceObject
{
  GeofenceObject({this.id,this.geofenceid,this.name,this.description,this.area,this.attributes});

  int id;
  int geofenceid;
  String name;
  String description;
  List<dynamic> area;
  AttributeClass attributes;

  GeofenceObject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        geofenceid = json['geofenceid'],
        name = json['name'],
        description = json['description'],
        area = json['area'],
        attributes = json['attributes'];

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'geofenceid':geofenceid,
      'name':name,
      'description':description,
      'area':area,
      'attributes':attributes,
    };
  }
}
