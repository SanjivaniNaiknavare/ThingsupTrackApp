
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class SearchDeviceList extends StatefulWidget
{
  SearchDeviceList({Key key,this.index,this.deviceObject,this.onTabClicked}) : super(key: key);
  int index;
  ValueChanged<bool> onTabClicked;
  DeviceObjectAllAccount deviceObject;

  @override
  _SearchDeviceListState createState() => _SearchDeviceListState();
}

class _SearchDeviceListState extends State<SearchDeviceList>
{

  String LOGTAG="SearchDeviceList";
  bool status = false;

  @override
  void initState(){
    super.initState();


  }



  @override
  Widget build(BuildContext context) {
    return new Container(
      color: global.screenBackColor,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child:GestureDetector(
            onTap: (){
              widget.onTabClicked(true);
            },
            child:Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: new BoxDecoration(
                      color: global.whiteColor,
                      border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child:new Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child:new Container(child:new SvgPicture.asset('assets/search-device-list-icon.svg')),
                        ),
                        Flexible(
                            flex: 5,
                            fit: FlexFit.tight,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(widget.deviceObject.name.toString(), style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.w500,fontFamily: 'MulishRegular')),
                              ],
                            )
                        ),

                      ],
                    )
                )
        )
    );
  }
}