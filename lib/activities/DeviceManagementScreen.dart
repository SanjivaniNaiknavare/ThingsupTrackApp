import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/activities/DevicesScreen.dart';
import 'package:thingsuptrackapp/activities/UserDevicesScreen.dart';
import 'package:thingsuptrackapp/activities/UserSharedDevicesScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;

class DeviceManagementScreen extends StatefulWidget
{
  @override
  _DeviceManagementScreenState createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen>
{


  Future<bool> _onbackButtonPressed()
  {
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: _onbackButtonPressed,
        child: DefaultTabController(
            length: 3,
            child:
            Scaffold(
              appBar:AppBar(
                titleSpacing: 0.0,
                elevation: 5,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding:  EdgeInsets.fromLTRB(15,0,0,0),
                        child:  GestureDetector(
                            onTap: (){_onbackButtonPressed();},
                            child: new Container(
                              height: 25,
                              child:Image(image: AssetImage('assets/back-arrow.png')),
                            )
                        )
                    ),
                    Container(
                        padding:  EdgeInsets.fromLTRB(15,0,0,0),
                        child:  new Text("Device Management",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                    ),
                  ],
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(text: "Devices"),
                    Tab(text: "User Devices"),
                    Tab(text: "Share Devices"),
                  ],
                  unselectedLabelColor: global.darkGreyColor,
                  labelColor: global.mainColor,

                ),
                backgroundColor:global.screenBackColor,
              ),
              body:TabBarView(
                children: [
                  DevicesScreen(),
                  UserDevicesScreen(),
                  UserSharedDevicesScreen()
                ],
              ),

            )
        )
    );
  }
}