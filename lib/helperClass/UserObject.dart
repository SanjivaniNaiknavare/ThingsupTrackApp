

class UserObject
{
  UserObject({this.id,this.email,this.name,this.password,this.role,this.disabled,this.phone,this.twelvehourformat,this.custommap,this.devices});

  int id;
  String email;
  String name;
  String password;
  String role;
  bool disabled;
  String phone;
  bool twelvehourformat;
  String custommap;
  String devices;

  UserObject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
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
      'id':id,
      'email':email,
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
