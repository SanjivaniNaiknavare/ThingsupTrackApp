import 'package:thingsuptrackapp/HelperClass.dart';
import 'package:thingsuptrackapp/activities/HomeScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'activities/SignIn.dart';
import 'package:thingsuptrackapp/global.dart' as global;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = new SignIn();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isUserLoggedIn=prefs.getBool("LoggedInStatus");

  if(isUserLoggedIn!=null)
  {
    if (isUserLoggedIn)
    {
      _defaultHome = new HomeScreen();
    }
  }

  runApp(MyApp(defaultHome: _defaultHome,));
}

class MyApp extends StatefulWidget
{
  MyApp({Key key,this.defaultHome}) : super(key: key);
  Widget defaultHome;
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseAuth _auth;

  @override
  void initState()
  {
    super.initState();

    initDBHelper();

    global.helperClass=new HelperClass();

    getPermissions();
  }

  void initDBHelper() async
  {

    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);
    global.firebaseInstance=_auth;

  }

  void getPermissions()async
  {
//    Map<Permission, PermissionStatus> statuses = await [
//      Permission.location,
//      Permission.storage,
//    ].request();
  }

  @override
  Widget build(BuildContext context) {

    debugPaintSizeEnabled = false;
    return MaterialApp(
      title: 'Track App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/SignIn': (context) => SignIn(),
      },
      home: widget.defaultHome,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
