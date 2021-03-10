import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsuptrackapp/activities/DeviceManagementScreen.dart';
import 'package:thingsuptrackapp/activities/GeofenceScreen.dart';
import 'package:thingsuptrackapp/activities/UserManagementScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helpers/HomeScreenBottomSheet.dart';
import 'package:thingsuptrackapp/helpers/NavDrawer.dart';



class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  final textController = TextEditingController();
  BuildContext mContext;

  String LOGTAG="HomeScreen";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isResponseReceived=false;
  bool isDeviceFound=false;
  List<DeviceObjectAllAccount> listOfDevices=new List();

  @override
  void initState()
  {
    super.initState();

    print(LOGTAG+" initState called");
   // getDevices();
   // getUserData();

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

    print(LOGTAG+" idTokenList->"+idTokenList[1].length.toString());

    String decodedUserJson = utf8.decode(base64.decode(idTokenList[1]));
    print(LOGTAG+" decodedUserJson->"+decodedUserJson);

    String role="";
    var resBody=json.decode(decodedUserJson.toString());
    role=resBody["role"];
    global.userRole=role;
    global.userName=resBody["name"];
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


  void updateUI(BuildContext context,int value) async
  {
    if(value==2)
    {

    }
    else if(value==3)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementScreen(),),);
    }
    else if(value==4)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceManagementScreen(),),);
    }
    else if(value==5)
    {
      //geofence
      Navigator.push(context, MaterialPageRoute(builder: (context) => GeofenceScreen(),),);
    }
    else if(value==6)
    {

    }
    else if(value==7)
    {
      await global.firebaseInstance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("LoggedInStatus",false);
      Navigator.pushNamedAndRemoveUntil(context, "/SignIn", (r) => false);

    }
  }

  @override
  Widget build(BuildContext context) {
    mContext=context;
    return new WillPopScope (
        onWillPop: _willPopCallback,
        child:Scaffold(
            key: _scaffoldKey,
            drawer: NavDrawer(optionSelected: (value){
              updateUI(context,value);
            }),
            appBar:AppBar(
              titleSpacing: 0.0,
              elevation: 2,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding:  EdgeInsets.fromLTRB(25,0,0,0),
                      child:  GestureDetector(
                          onTap: (){
                            _scaffoldKey.currentState.openDrawer();
                            setState(() {});
                          },
                          child:new Container(
                              height: 30,
                              child:SvgPicture.asset('assets/sidemenu-icon.svg')
                          )
                      )
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(15,8,8,8),
                      child:  Text("Home", style: new TextStyle(fontSize: global.font18, color: global.appbarTextColor, fontWeight: FontWeight.normal,fontFamily: 'PoppinsRegular'))
                  )
                ],
              ),
              backgroundColor: global.appbarBackColor,
            ),
            body:new Stack(
                children: <Widget>[
                  Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      )
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.8,
                    minChildSize: 0.2,
                    maxChildSize: 1.0,
                    builder: (BuildContext context, ScrollController scrollController){
                      return HomeScreenBottomSheet(scrollController: scrollController,);
                    },
                  )
                ]
            )
        )
    );
  }
}