import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thingsuptrackapp/global.dart' as global;

class NavDrawer extends StatefulWidget
{
  NavDrawer({Key key,this.optionSelected}) : super(key: key);
  ValueChanged<int> optionSelected;
  @override
  NavDrawerState createState() => NavDrawerState();

}

class NavDrawerState extends State<NavDrawer>
{

  File userSelectedImg;
  bool status=false;

  @override
  Widget build(BuildContext context)
  {
    return Container(
        color: global.whiteColor,
        child:Theme(
            data: Theme.of(context).copyWith(
              canvasColor: global.whiteColor,
            ),
            child:
            Drawer(
              child: ListView(

                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                      color: global.whiteColor,
                      height: 160,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(12,60,25,30),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(0,5,0,5),
                              alignment: Alignment.centerLeft,
                              height: 60,
                              child:Image(image: AssetImage("assets/tracking-app-logo.png"))
                          ),
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: new BoxDecoration(
                        color: global.whiteColor,
                        border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(8.0),),
                      ),
                      child: SizedBox(
                        height:80,
                        child: new Row(
                          children: <Widget>[
                            Flexible(
                              flex:2,
                              fit: FlexFit.tight,
                              child:  new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child:  new Container(
                                  decoration: userSelectedImg!=null?new BoxDecoration(
                                    color: global.whiteColor,
                                    image:  DecorationImage(
                                      image:  FileImage(File(userSelectedImg.path)),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: global.whiteColor,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ):new BoxDecoration(
                                      color: global.whiteColor,
                                      image:  DecorationImage(
                                        image: AssetImage("assets/default-avatar-icon.png"),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                        color: global.whiteColor,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                                flex:3,
                                fit:FlexFit.tight,
                                child:new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(global.myObject.name.toString(), style: TextStyle(fontSize: global.font14, color: global.darkBlack,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                    SizedBox(height:10),
                                    new Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        decoration: new BoxDecoration(
                                          color: global.transparent,
                                          border: Border.all(color: Color(0xffc4c4c4),width: 1),
                                          borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                        ),
                                        child:new Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                flex:1,
                                                fit:FlexFit.tight,
                                                child:new Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text("Dark Mode", style: TextStyle(fontSize: global.font12, color: global.darkBlack,fontFamily: 'MulishRegular')),
                                                  ],
                                                )
                                            ),
                                            Flexible(
                                                flex:1,
                                                fit:FlexFit.tight,
                                                child: Switch(
                                                  onChanged: (val){
                                                    setState(() {
                                                      status = val;
                                                    });
                                                    if(val)
                                                    {

                                                    }
                                                    else
                                                    {

                                                    }
                                                  },
                                                  value: status,
                                                  activeColor: Color(0xff0E4DA4),
                                                  activeTrackColor: Color(0xff0E4DA4).withOpacity(0.24),
                                                  inactiveThumbColor: Color(0xff4D5259),
                                                  inactiveTrackColor:Color(0xff0E4DA4).withOpacity(0.1),
                                                )
                                            )
                                          ],
                                        )
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                  ),
                  new Container(
                    decoration: BoxDecoration(
                      color: global.whiteColor,
                      borderRadius: BorderRadius.only(topRight:  Radius.circular(12),bottomRight:Radius.circular(12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                            alignment: Alignment.center,
                            child: new Container(
                                width: 30,
                                height: 30,
                                child:SvgPicture.asset('assets/drawer-home-icon.svg')
                            )
                        ),
                      ),
                      title: Text('Home',style: new TextStyle(fontSize: global.font15, color: Color(0xff0176FE), fontWeight: FontWeight.normal,fontFamily: 'MulishSemiBold')),
                      onTap: () => {

                        Navigator.of(context).pop(),
                        widget.optionSelected(1),
                      },
                    ),
                  ),
                  new Container(
                      decoration: BoxDecoration(
                        color: global.whiteColor,
                        borderRadius: BorderRadius.only(topRight:  Radius.circular(12),bottomRight:Radius.circular(12)),
                      ),
                      child:ListTile(
                        leading: Container(
                          height: 30.0,
                          width: 30.0,
                          child: Container(
                              alignment: Alignment.center,
                              child: new Container(
                                  width: 30,
                                  height: 30,
                                  child:SvgPicture.asset('assets/drawer-history-icon.svg')
                              )
                          ),
                        ),
                        title: Text('History',style: new TextStyle(fontSize: global.font15, color: Color(0xff0176FE), fontWeight: FontWeight.normal,fontFamily: 'MulishSemiBold')),
                        onTap: () => {
                          Navigator.of(context).pop(),
                          widget.optionSelected(2),
                        },
                      )
                  ),
                  new Container(
                    decoration: BoxDecoration(
                      color: global.whiteColor,
                      borderRadius: BorderRadius.only(topRight:  Radius.circular(12),bottomRight:Radius.circular(12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                            alignment: Alignment.center,
                            child: new Container(
                                width: 30,
                                height: 30,
                                child:SvgPicture.asset('assets/drawer-user-icon.svg')
                            )
                        ),
                        //  decoration: BoxDecoration(color: Color(0xff0176FE).withOpacity(0.3), shape: BoxShape.circle,),
                      ),
                      title: Text('User Management',style: new TextStyle(fontSize: global.font15, color: Color(0xff0176FE), fontWeight: FontWeight.normal,fontFamily: 'MulishSemiBold')),
                      onTap: () => {
                        Navigator.of(context).pop(),
                        widget.optionSelected(3),
                      },
                    ),
                  ),
                  new Container(
                    decoration: BoxDecoration(
                      color: global.whiteColor,
                      borderRadius: BorderRadius.only(topRight:  Radius.circular(12),bottomRight:Radius.circular(12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                            alignment: Alignment.center,
                            child: new Container(
                                width: 30,
                                height: 30,
                                child:SvgPicture.asset('assets/drawer-device-icon.svg')
                            )
                        ),
                      ),
                      title: Text('Device Management',style: new TextStyle(fontSize: global.font15, color: Color(0xff0176FE), fontWeight: FontWeight.normal,fontFamily: 'MulishSemiBold')),
                      onTap: () => {

                        Navigator.of(context).pop(),
                        widget.optionSelected(4),
                      },
                    ),
                  ),
                  new Container(
                    decoration: BoxDecoration(
                      color: global.whiteColor,
                      borderRadius: BorderRadius.only(topRight:  Radius.circular(12),bottomRight:Radius.circular(12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                            alignment: Alignment.center,
                            child: new Container(
                                width: 30,
                                height: 30,
                                child:SvgPicture.asset('assets/drawer-geofence-icon.svg')
                            )
                        ),
                      ),
                      title: Text('Geofence',style: new TextStyle(fontSize: global.font15, color: Color(0xff0176FE), fontWeight: FontWeight.normal,fontFamily: 'MulishSemiBold')),
                      onTap: () => {
                        Navigator.of(context).pop(),
                        widget.optionSelected(5),
                      },
                    ),
                  ),
                  new Container(
                      decoration: BoxDecoration(
                        color: global.whiteColor,
                        borderRadius: BorderRadius.only(topRight:  Radius.circular(12),bottomRight:Radius.circular(12)),
                      ),
                      child:ListTile(
                        leading: Container(
                          height: 30.0,
                          width: 30.0,
                          child: Container(
                              alignment: Alignment.center,
                              child:new Container(
                                  width: 30,
                                  height: 30,
                                  child:SvgPicture.asset('assets/drawer-profile-icon.svg')
                              )
                          ),
                        ),
                        title: Text('Profile',style: new TextStyle(fontSize: global.font15, color: Color(0xff0176FE), fontWeight: FontWeight.normal,fontFamily: 'MulishSemiBold')),
                        onTap: () => {
                          Navigator.of(context).pop(),
                          widget.optionSelected(6)
                        },
                      )
                  ),
                  new Container(
                    decoration: BoxDecoration(
                      color:global.whiteColor,
                      borderRadius: BorderRadius.only(topRight:  Radius.circular(12),bottomRight:Radius.circular(12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                            alignment: Alignment.center,
                            child:new Container(
                                width: 30,
                                height: 30,
                                child:SvgPicture.asset('assets/drawer-exit-icon.svg')
                            )
                        ),
                      ),
                      title: Text('Exit',style: new TextStyle(fontSize: global.font15, color: Color(0xff0176FE), fontWeight: FontWeight.normal,fontFamily: 'MulishSemiBold')),
                      onTap: () => {
                        Navigator.of(context).pop(),
                        widget.optionSelected(7),
                      },
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}
