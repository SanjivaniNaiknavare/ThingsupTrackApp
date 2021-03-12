import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/activities/GeofenceScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;

class GeofenceManagementScreen extends StatefulWidget
{
  @override
  _GeofenceManagementScreenState createState() => _GeofenceManagementScreenState();
}

class _GeofenceManagementScreenState extends State<GeofenceManagementScreen> with SingleTickerProviderStateMixin
{

  String LOGTAG="GeofenceManagementScreen";
  TabController _controller;
  int tabIndex=0;

  @override
  void initState()
  {
    super.initState();


    _controller = TabController(length: 1, vsync: this);
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
                    Flexible(
                        flex:1,
                        fit: FlexFit.tight,
                        child:new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child:  Container(
                                  height: kToolbarHeight-10,
                                  padding:  EdgeInsets.fromLTRB(15,0,0,0),
                                  child: new Container(
                                      child: GestureDetector(
                                          onTap: (){_onbackButtonPressed();},
                                          child: new Container(
                                            height: 20,
                                            child:Image(image: AssetImage('assets/back-arrow.png')),
                                          )
                                      )
                                  )
                              ),
                            )
                          ],
                        )
                    ),
                    Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: new Text("Geofence",style: TextStyle(fontSize: global.font18, color: global.mainBlackColor,fontWeight: FontWeight.w600,fontFamily: 'MulishRegular'))
                            ),
                          ],
                        )
                    ),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child:new Container()
                    )
                  ],
                ),
                bottom:PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child:
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
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
                                      tabIndex==0?Text("Location",style: TextStyle(fontSize: global.font13,color:global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                                      Text("Location",style: TextStyle(fontSize: global.font13,color:Color(0xff3C74DC),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                    ],
                                  )
                              ),
                            ),
                          ]
                      ),
                    )
                ),
                backgroundColor:global.screenBackColor,
              ),
              body:TabBarView(
                controller: _controller,
                children: [
                  GeofenceScreen(),
                ],
              ),
            )
        )
    );
  }
}