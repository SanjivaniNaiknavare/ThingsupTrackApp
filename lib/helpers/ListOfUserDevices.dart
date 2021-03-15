import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class ListOfUserDevices extends StatefulWidget
{
  ListOfUserDevices({Key key,this.index,this.deviceObject,this.onTabClicked}) : super(key: key);
  int index;
  ValueChanged<String> onTabClicked;
  DeviceObjectAllAccount deviceObject;

  @override
  _ListOfUserDevicesState createState() => _ListOfUserDevicesState();
}

class _ListOfUserDevicesState extends State<ListOfUserDevices>
{

  String LOGTAG="ListOfUserDevices";
  bool status = false;

  @override
  void initState(){
    super.initState();


  }



  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Container(
            padding: EdgeInsets.fromLTRB(0,10,10,10),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: new BoxDecoration(
              color: global.whiteColor,
              border: Border.all(color:Color(0xffc4c4c4), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child:new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child:  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text((widget.index+1).toString(), style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                    ],
                  ),
                ),
                Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(widget.deviceObject.name.toString(), style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.w600,fontFamily: 'MulishRegular')),
                        SizedBox(height: 8,),
                        new Text(widget.deviceObject.uniqueid.toString(), style: new TextStyle(fontSize: global.font14, color: Color(0xff121212).withOpacity(0.8), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),

                      ],
                    )
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          widget.onTabClicked("Delete");
                        },
                        child: new Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.fromLTRB(5,5,5,5),
                            margin: EdgeInsets.fromLTRB(0,7,0,0),
                            decoration: new BoxDecoration(
                              color: global.transparent,
                              border: Border.all(color: Color(0xffc4c4c4),width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                            ),
                            child: new SvgPicture.asset('assets/delete-icon.svg',height: 20)
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}