import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thingsuptrackapp/HelperClass.dart';
import 'package:thingsuptrackapp/activities/AllAPIScreen.dart';
import 'package:thingsuptrackapp/activities/GeofenceManagementScreen.dart';
import 'package:thingsuptrackapp/activities/ProfileScreen.dart';
import 'package:thingsuptrackapp/activities/UserManagementScreen.dart';
import 'package:thingsuptrackapp/activities/DeviceManagementScreen.dart';
import 'package:thingsuptrackapp/activities/DevicesScreen.dart';
import 'package:thingsuptrackapp/activities/GeofenceScreen.dart';
import 'package:thingsuptrackapp/activities/GoogleMapScreen.dart';
import 'package:thingsuptrackapp/activities/HomeScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thingsuptrackapp/helpers/PushNotificationManager';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsuptrackapp/activities/UserDevicesScreen.dart';
import 'package:thingsuptrackapp/activities/UserScreen.dart';
import 'package:thingsuptrackapp/activities/UserSharedDevicesScreen.dart';
import 'package:thingsuptrackapp/helpers/APIClass.dart';
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future _showNotificationWithoutSound(String title, String body,String url,String receiptID,String mobileNo, String countryCode) async
  {

    String payload=receiptID;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', playSound: false, importance: Importance.Max, priority: Priority.High,
      icon: 'ic_app_icon',
     // largeIcon: FilePathAndroidBitmap(largeIconPath),
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  @override
  void initState()
  {
    super.initState();

    initDBHelper();

    global.helperClass=new HelperClass();
    global.apiClass=new APIClass();
    getPermissions();


    PushNotificationsManager pushNotificationManager=new PushNotificationsManager();
    pushNotificationManager.init();

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true,badge: true, alert: true, provisional: true));
    _firebaseMessaging.configure();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('Firebase on message $message');


        if(Platform.isAndroid)
        {
          print("noti title:"+message['notification']['title'].toString());
          print("noti body:"+message['notification']['body'].toString());
          print("noti image:"+message['notification']['image'].toString());

          print("data image:" + message['data']['image'].toString());
          print("data receiptID:" + message['data']['receiptId'].toString());
          print("data mobNo:" + message['data']['mobileNo'].toString());
          print("data cc:" + message['data']['countryCode'].toString());

          if (message['data']['image'] != null &&
              message['data']['receiptId'] != null &&
              message['data']['mobileNo'] != null &&
              message['data']['countryCode'] != null) {
            _showNotificationWithoutSound(
                message['notification']['title'],
                message['notification']['body'],
                message['data']['image'], message['data']['receiptId'],
                message['data']['mobileNo'], message['data']['countryCode']);
          }
          else {

            print("MainClass:" + " on message else is called");
            _showNotificationWithoutSound(
                message['notification']['title'],
                message['notification']['body'],
                "","","","");
          }
        }
      },

      onResume: (Map<String, dynamic> message) async {
        print('Firebase on resume $message');

      },
      onLaunch: (Map<String, dynamic> message) async {
        print('Firebase on launch $message');

      },
    );

  }

  void initDBHelper() async
  {

    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);
    global.firebaseInstance=_auth;

  }

  void getPermissions()async
  {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location
    ].request();
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
