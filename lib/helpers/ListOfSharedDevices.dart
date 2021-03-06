
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helperClass/SharedDeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class ListOfSharedDevices extends StatefulWidget
{
  ListOfSharedDevices({Key key,this.index,this.sharedDeviceObject,this.onTabClicked}) : super(key: key);
  int index;
  ValueChanged<bool> onTabClicked;
  SharedDeviceObject sharedDeviceObject;

  @override
  _ListOfSharedDevicesState createState() => _ListOfSharedDevicesState();
}

class _ListOfSharedDevicesState extends State<ListOfSharedDevices>
{

  String LOGTAG="ListOfSharedDevices";
  bool status = false;

  DeviceObjectAllAccount deviceObject;

  @override
  void initState(){
    super.initState();

    print(global.myAllDevices);
    deviceObject=global.myAllDevices[widget.sharedDeviceObject.deviceid];

  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child:GestureDetector(
            onTap: (){
              widget.onTabClicked(true);
            },
            child:new Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                child:Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    height: 76,
                    decoration: new BoxDecoration(
                      color: global.screenBackColor,
                      boxShadow: [BoxShadow(color: Color.fromRGBO(18,18,18,0.1), blurRadius: 22.0, offset: Offset(0,8),),],
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child:new Row(
                      children: <Widget>[

                        Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                deviceObject!=null?new Text(deviceObject.name.toString(), style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                                new Text("DeviceName", style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                new Text("https://dev.track.thingsup.io/livedata?token="+widget.sharedDeviceObject.token.toString(), style: new TextStyle(fontSize: global.font12, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                              ],
                            )
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(Icons.chevron_right,color: Color(0xffD3616A),),
                        )
                      ],
                    )
                )
            )
        )
    );
  }
}