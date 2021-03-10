import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/activities/DevicesScreen.dart';
import 'package:thingsuptrackapp/activities/DriverScreen.dart';
import 'package:thingsuptrackapp/activities/DriverTaggingScreen.dart';
import 'package:thingsuptrackapp/activities/UserDevicesScreen.dart';
import 'package:thingsuptrackapp/activities/UserSharedDevicesScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;

class DeviceManagementScreen extends StatefulWidget
{
  @override
  _DeviceManagementScreenState createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> with SingleTickerProviderStateMixin
{

  String LOGTAG="DeviceManagementScreen";
  TabController _controller;
  int tabIndex=0;

  @override
  void initState()
  {
    super.initState();


    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(() {
      tabIndex = _controller.index;
      setState(() {});
      print(LOGTAG+" currentIndex->"+tabIndex.toString());
    });

  }

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
                elevation: 0,
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
                bottom:
                TabBar(
                    controller: _controller,
                    labelPadding: EdgeInsets.fromLTRB(5,0,5,0),
                    isScrollable: true,
                    indicatorColor: global.transparent,
                    tabs: [
                      Tab(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            decoration: BoxDecoration(
                                color: tabIndex==0?Color(0xff3C74DC):global.whiteColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Color(0xff3C74DC), width: 1)),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.center,
                              children: <Widget>[
                                tabIndex==0?Text("Devices",style: TextStyle(fontSize: global.font13,color:global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                                Text("Devices",style: TextStyle(fontSize: global.font13,color:Color(0xff3C74DC),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                              ],
                            )
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              color: tabIndex==1? Color(0xff3C74DC):global.whiteColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Color(0xff3C74DC), width: 1)),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.center,
                              children: <Widget>[
                                tabIndex==1?Text("User Devices",style: TextStyle(fontSize: global.font13,color:global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                                Text("User Devices",style: TextStyle(fontSize: global.font13,color:Color(0xff3C74DC),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                              ]
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              color: tabIndex==2?Color(0xff3C74DC):global.whiteColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Color(0xff3C74DC), width: 1)),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.center,
                              children: <Widget>[
                                tabIndex==2?Text("Share Devices",style: TextStyle(fontSize: global.font13,color:global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                                Text("Share Devices",style: TextStyle(fontSize: global.font13,color:Color(0xff3C74DC),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),

                              ]
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            decoration: BoxDecoration(
                                color: tabIndex==3?Color(0xff3C74DC):global.whiteColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Color(0xff3C74DC), width: 1)),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.center,
                              children: <Widget>[
                                tabIndex==3?Text("Drivers",style: TextStyle(fontSize: global.font13,color:global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                                Text("Drivers",style: TextStyle(fontSize: global.font13,color:Color(0xff3C74DC),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                              ],
                            )
                        ),
                      ),
                      Tab(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            decoration: BoxDecoration(
                                color: tabIndex==4?Color(0xff3C74DC):global.whiteColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Color(0xff3C74DC), width: 1)),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.center,
                              children: <Widget>[
                                tabIndex==4?Text("Tagged Drivers",style: TextStyle(fontSize: global.font13,color:global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                                Text("Tagged Drivers",style: TextStyle(fontSize: global.font13,color:Color(0xff3C74DC),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                              ],
                            )
                        ),
                      ),
                    ]
                ),
                backgroundColor:global.screenBackColor,
              ),
              body:TabBarView(
                controller: _controller,
                children: [
                  DevicesScreen(),
                  UserDevicesScreen(),
                  UserSharedDevicesScreen(),
                  DriverScreen(),
                  DriverTaggingScreen(),
                ],
              ),
            )
        )
    );
  }
}