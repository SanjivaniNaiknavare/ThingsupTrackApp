import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';



class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  final textController = TextEditingController();
  BuildContext mContext;
  String idToken="";
  String LOGTAG="HomeScreen";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    super.initState();

    getUserData();

  }

  void getUserData() async
  {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;
    print(LOGTAG+" idToken->"+idToken.toString());

    List<String> idTokenList=idToken.split(".");
    int decodelength=idTokenList[1].length;
    if(decodelength%4!=0)
    {
      int modData=decodelength%4;
      for(int k=0;k<modData;k++)
      {
        idTokenList[1]=idTokenList[1]+"=";
      }
    }

    String decodedUserJson = utf8.decode(base64.decode(idTokenList[1]));
    print(LOGTAG+" decodedUserJson->"+decodedUserJson);

    String role="";
    var resBody=json.decode(decodedUserJson.toString());
    role=resBody["role"];
    global.userRole=role;
    global.userID=_auth.currentUser.uid;
    print(LOGTAG+" role->"+global.userRole.toString());
    print(LOGTAG+" userID->"+global.userID.toString());

    idToken=global.idToken.toString();
    setState(() {});

  }

  Future<bool> _willPopCallback() async
  {
    if (Platform.isAndroid)
    {
      SystemNavigator.pop();
    }
    else if (Platform.isIOS)
    {
      exit(0);
    }
    return true;
  }


  void logoutUser() async{

    await global.firebaseInstance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("LoggedInStatus",false);
    Navigator.pushNamedAndRemoveUntil(context, "/SignIn", (r) => false);
  }

  @override
  void dispose() async
  {
    super.dispose();
  }


  void addUser() async
  {

    String userid="sanju@gmail.com";
    String name="sanju";
    String password="Test@1234";
    String role="user";
    bool disabled=false;
    String phone="";
    bool twelvehourformat=false;
    String custommap="";
    String devices="";

    AddUserClass addUserClass=new AddUserClass(userid: userid,name: name,password: password,role: role,disabled: disabled,phone: phone,twelvehourformat: twelvehourformat,custommap: custommap,devices: devices);
    var jsonBody=jsonEncode(addUserClass);
    print(LOGTAG+" addUser jsonbody->"+jsonBody.toString());

    Response response=await global.apiClass.AddUser(jsonBody);

    print(LOGTAG+" adduser response->"+response.toString());

    if(response!=null)
    {

      idToken=global.idToken.toString();
      setState(() {});

      print(LOGTAG+" adduser statusCode->"+response.statusCode.toString());
      print(LOGTAG+" adduser body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" adduser->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "User Already Exist", false, "");
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void updateUser() async
  {
    String userid="sanju@gmail.com";
    String name="sanjubaba";
    String phone="+919975469292";
    bool twelvehourformat=false;
    String custommap="";

    UpdateUserClass updateUserClass=new UpdateUserClass(userid: userid,name: name,phone: phone,twelvehourformat: twelvehourformat,custommap: custommap);
    var jsonBody=jsonEncode(updateUserClass);
    print(LOGTAG+" updateUser jsonbody->"+jsonBody.toString());

    Response response=await global.apiClass.UpdateUser(jsonBody);
    print(LOGTAG+" updateUser response->"+response.toString());

    if(response!=null)
    {

      idToken=global.idToken.toString();
      setState(() {});

      print(LOGTAG+" updateUser statusCode->"+response.statusCode.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" adduser->"+resBody.toString());
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }


  }

  void getUser() async
  {
    Response response=await global.apiClass.GetUser();
    print(LOGTAG+" getUser response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getUser statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getuser->"+resBody.toString());
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void deleteUser() async
  {
    Response response=await global.apiClass.DeleteUser("sanju@gmail.com");

    print(LOGTAG+" deleteUser response->"+response.toString());

    if(response!=null)
    {
      idToken=global.idToken.toString();
      setState(() {});

      print(LOGTAG+" deleteUser statusCode->"+response.statusCode.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" delete user->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "User Not Found", false, "");
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void getChildUsers() async
  {
    Response response=await global.apiClass.GetChildUsers();
    print(LOGTAG+" getChildUsers response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getChildUsers statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getChildUsers->"+resBody.toString());
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void addDevice() async
  {
    String name="my first device";
    String uniqueid="SanjuDevice";
    String groupid=null;
    String phone="";
    String model="";
    String contact="";
    String type="car";
    LatLngClass static=new LatLngClass(lat:12.34,lng:13.5);

    AddAndUpdateDeviceClass addDeviceClass=new AddAndUpdateDeviceClass(name: name,uniqueid: uniqueid,static: static,groupid: groupid,phone: phone,model: model,contact: contact,type: type);
    var jsonBody=jsonEncode(addDeviceClass);
    print(LOGTAG+" addDevice jsonbody->"+jsonBody.toString());

    Response response=await global.apiClass.AddDevice(jsonBody);
    print(LOGTAG+" addDevice response->"+response.toString());

    if(response!=null)
    {
      idToken=global.idToken.toString();
      setState(() {});

      print(LOGTAG+" addDevice statusCode->"+response.statusCode.toString());
      print(LOGTAG+" addDevice body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" addDevice->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "Device Already Exist", false, "");
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void updateDevice() async
  {
    String name="my device";
    String uniqueid="SanjuDevice";
    String groupid=null;
    String phone="";
    String model="";
    String contact="";
    String type="car";
    LatLngClass static=new LatLngClass(lat:12.34,lng:13.5);

    AddAndUpdateDeviceClass addDeviceClass=new AddAndUpdateDeviceClass(name: name,uniqueid: uniqueid,static: static,groupid: groupid,phone: phone,model: model,contact: contact,type: type);
    var jsonBody=jsonEncode(addDeviceClass);
    print(LOGTAG+" updateDevice jsonbody->"+jsonBody.toString());

    Response response=await global.apiClass.UpdateDevice(jsonBody);
    print(LOGTAG+" updateDevice response->"+response.toString());

    if(response!=null)
    {
      idToken=global.idToken.toString();
      setState(() {});

      print(LOGTAG+" updateDevice statusCode->"+response.statusCode.toString());
      print(LOGTAG+" updateDevice body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" updateDevice->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "Device Already Exist", false, "");
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void deleteDevice() async
  {
    Response response=await global.apiClass.DeleteDevice("SanjuDevice");
    print(LOGTAG+" deleteDelete response->"+response.toString());

    if(response!=null)
    {
      idToken=global.idToken.toString();
      setState(() {});

      print(LOGTAG+" deleteDelete statusCode->"+response.statusCode.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" deleteDelete->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "User Not Found", false, "");
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }


  void getAccountDevices() async
  {
    Response response=await global.apiClass.GetAccountDevices();
    print(LOGTAG+" getAccountDevices response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getAccountDevices statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getAccountDevices->"+resBody.toString());
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void getDeviceDetails() async
  {
    Response response=await global.apiClass.GetDeviceDetails("SanjuDevice");
    print(LOGTAG+" getDeviceDetails response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getDeviceDetails statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getDeviceDetails->"+resBody.toString());
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void getOwnedDevices() async
  {
    Response response=await global.apiClass.GetOwnedDevices();
    print(LOGTAG+" getOwnedDevices response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getOwnedDevices statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getOwnedDevices->"+resBody.toString());
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void getTaggedDevices() async
  {
    Response response=await global.apiClass.GetTaggedDevices("sanju@gmail.com");
    print(LOGTAG+" getTaggedDevices response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getTaggedDevices statusCode->"+response.statusCode.toString());
      print(LOGTAG+" getTaggedDevices body->"+response.body.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        if(resBody.toString().contains("Devices not found"))
        {
          global.helperClass.showAlertDialog(context, "", "Device not found", false, "");
        }
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "User is not Child/Access Denied", false, "");
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  void tagUserToDevice() async
  {
    String uniqueid="SanjuDevice";
    String taguserid="sanju@gmail.com";


    TagUserToDevice tagUserToDevice=new TagUserToDevice(uniqueid: uniqueid,taguserid: taguserid);
    var jsonBody=jsonEncode(tagUserToDevice);
    print(LOGTAG+" tagUserToDevice jsonbody->"+jsonBody.toString());

    Response response=await global.apiClass.TagUserToDevice(jsonBody);
    print(LOGTAG+" tagUserToDevice response->"+response.toString());

    if(response!=null)
    {
      idToken=global.idToken.toString();
      setState(() {});

      print(LOGTAG+" tagUserToDevice statusCode->"+response.statusCode.toString());
      print(LOGTAG+" tagUserToDevice body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" tagUserToDevice->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "User is not Child/Access Denied", false, "");
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }

  }

  void untagUserFromDevice() async
  {
    String uniqueid="SanjuDevice";
    String taguserid="sanju@gmail.com";

    Response response=await global.apiClass.UntagUserFromDevice(uniqueid,taguserid);
    print(LOGTAG+" untagUserFromDevice response->"+response.toString());

    if(response!=null)
    {
      idToken=global.idToken.toString();
      setState(() {});

      print(LOGTAG+" untagUserFromDevice statusCode->"+response.statusCode.toString());
      print(LOGTAG+" untagUserFromDevice body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" untagUserFromDevice->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "User is not Child/Access Denied", false, "");
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }

  }


  @override
  Widget build(BuildContext context) {
    mContext=context;
    return new WillPopScope (
        onWillPop: _willPopCallback,
        child:Scaffold(
            key: _scaffoldKey,

            appBar:AppBar(
              titleSpacing: 0.0,
              elevation: 2,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                ],
              ),
              backgroundColor: global.appbarBackColor,
            ),
            body:new Column
              (
              children: <Widget>[


                new Row(
                  children: <Widget>[
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          addUser();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Add user"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          updateUser();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Update user"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          getUser();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Get user"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          deleteUser();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Delete user"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          logoutUser();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Logout"),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height:10),
                new Row(
                  children: <Widget>[
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          getChildUsers();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("get Child users"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          addDevice();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Add Device"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          updateDevice();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Update Device"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          deleteDevice();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Delete Device"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          getAccountDevices();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("GetAccountDevices"),
                        ),
                      ),
                    )

                  ],
                ),
                SizedBox(height:10),
                new Row(
                  children: <Widget>[
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          getDeviceDetails();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Get Device Details"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          getOwnedDevices();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Get Owned Dev"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          getTaggedDevices();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Get Tagged Dev"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          tagUserToDevice();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("TagUserToDevice"),
                        ),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap:(){
                          untagUserFromDevice();
                        },
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Text("Untag User frm Dev"),
                        ),
                      ),
                    )

                  ],
                ),
                new Container(
                    height:200,
                    child: new SelectableText(

                      idToken,
                      maxLines: 20,
                    )
                )
              ],
            )
        )
    );
  }
}