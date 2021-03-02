import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsuptrackapp/global.dart' as global;



class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{

  BuildContext mContext;

  String LOGTAG="HomeScreen";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    super.initState();

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
  void dispose() async {
    super.dispose();
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
          body:GestureDetector(
            onTap: (){

              logoutUser();

            },
            child: new Text("Hi"),
          )
        )
    );
  }
}