import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ListOfHomeScreenDevices extends StatefulWidget
{
  ListOfHomeScreenDevices({Key key,this.index,this.expandFlag,this.scrollController,this.deviceObjectAllAccount,this.onExpandCicked,this.onDriverInfoCicked,this.onShareCicked,this.onDeviceSelected}) : super(key: key);
  int index;
  bool expandFlag;
  ValueChanged<bool> onExpandCicked;
  ValueChanged<bool> onDriverInfoCicked;
  ValueChanged<bool> onShareCicked;
  ValueChanged<bool> onDeviceSelected;
  DeviceObjectAllAccount deviceObjectAllAccount;
  ScrollController scrollController;

  @override
  _ListOfHomeScreenDevicesState createState() => _ListOfHomeScreenDevicesState();
}

class _ListOfHomeScreenDevicesState extends State<ListOfHomeScreenDevices>
{

  String LOGTAG="ListOfHomeScreenDevices";
  bool status = false;
  String lastUpdateData="NA";
  // bool expandFlag=false;

  @override
  void initState(){
    super.initState();



  }

  @override
  Widget build(BuildContext context) {

    if(global.myObject!=null)
    {

      if (widget.deviceObjectAllAccount.lastUpdate == null)
      {
        lastUpdateData = "NA";
      }
      else
      {
        if(widget.deviceObjectAllAccount.lastUpdate.toString().isEmpty)
        {
          lastUpdateData="NA";
        }
        else
        {
          lastUpdateData = widget.deviceObjectAllAccount.lastUpdate;
        }
      }
    }

    return new Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child:GestureDetector(
            onTap: (){
              print(LOGTAG+" device is clicked");
              widget.onDeviceSelected(true);
            },
            child: new Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                child:Container(
                    decoration: new BoxDecoration(
                      color: Color(0xff2D9F4C),
                      borderRadius: BorderRadius.all(Radius.circular(12.0),),
                    ),
                    child:
                    new Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              Flexible(
                                flex:1,
                                fit: FlexFit.tight,
                                child: new Container(color: Color(0xff2D9F4C),
                                    child:new Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Good',
                                              style: TextStyle(fontSize: global.font16, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                              Flexible(
                                flex:8,
                                fit: FlexFit.tight,
                                child: new Container(
                                    padding: EdgeInsets.fromLTRB(10,15,10,15),
                                    decoration: new BoxDecoration(
                                        color: global.whiteColor,
                                        borderRadius: new BorderRadius.only(
                                          bottomRight: const Radius.circular(12.0),
                                          topRight: const Radius.circular(12.0),
                                        )
                                    ),
                                    child:new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                flex:3,
                                                fit: FlexFit.tight,
                                                child: new Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Text(widget.deviceObjectAllAccount.name.toString(),textAlign: TextAlign.center, style: TextStyle(fontSize: global.font16, color: Color(0xff121212),fontWeight: FontWeight.w600,fontFamily: 'MulishRegular')),

                                                  ],
                                                )
                                            ),
                                            Flexible(
                                                flex:2,
                                                fit: FlexFit.tight,
                                                child: new Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Container(
                                                        child:new SvgPicture.asset('assets/green-wifi-icon.svg')
                                                    ),
                                                    SizedBox(width:5),
                                                    new Text(widget.deviceObjectAllAccount.status.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontFamily: 'MulishRegular'),
                                                    )
                                                  ],
                                                )
                                            ),
                                            Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child:new Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex:1,
                                                      fit: FlexFit.tight,
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          widget.onDriverInfoCicked(true);
                                                        },
                                                        child: new Container(
                                                            height: 35,
                                                            padding: EdgeInsets.fromLTRB(8,8,8,8),
                                                            margin: EdgeInsets.fromLTRB(5,5,0,5),
                                                            width: MediaQuery.of(context).size.width,
                                                            decoration: new BoxDecoration(
                                                              color: global.transparent,
                                                              border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                                            ),
                                                            child: new SvgPicture.asset('assets/green-driver-icon.svg')
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                        flex:1,
                                                        fit: FlexFit.tight,
                                                        child:
                                                        GestureDetector(
                                                          onTap: (){
                                                            widget.onShareCicked(true);
                                                          },
                                                          child: new Container(
                                                              height: 35,
                                                              padding: EdgeInsets.fromLTRB(8,8,8,8),
                                                              margin: EdgeInsets.fromLTRB(5,5,0,5),
                                                              width: MediaQuery.of(context).size.width,
                                                              decoration: new BoxDecoration(
                                                                color: global.transparent,
                                                                border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                                                                borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                                              ),
                                                              child: new SvgPicture.asset('assets/share-icon.svg')
                                                          ),
                                                        )
                                                    )
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                flex:2,
                                                fit: FlexFit.tight,
                                                child:new Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Text("Last Updated",textAlign: TextAlign.center, style: TextStyle(fontSize: global.font12, color: Color(0xff6b6b6b),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                    SizedBox(height: 5,),
                                                    new Text(lastUpdateData.toString(), style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontWeight: FontWeight.w600,fontFamily: 'MulishRegular')),
                                                  ],
                                                )
                                            ),
                                            Flexible(
                                                flex:2,
                                                fit: FlexFit.tight,
                                                child:new Row(
                                                  children: <Widget>[
                                                    new Container(
                                                        child:new SvgPicture.asset('assets/speed-icon.svg')
                                                    ),
                                                    SizedBox(width:5),
                                                    Expanded(
                                                        child: new Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            new Text(widget.deviceObjectAllAccount.speed.toString()+" km/hr",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: global.font14, color: Color(0xff121212),fontFamily: 'MulishRegular'),
                                                            )
                                                          ],
                                                        )
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){

                                                        widget.expandFlag=!widget.expandFlag;
                                                        widget.onExpandCicked(widget.expandFlag);


                                                        setState(() {});
                                                      },
                                                      child:  new Container(
                                                          decoration: new BoxDecoration(
                                                            color: global.greenColor,
                                                            border: Border.all(color: global.greenColor,width: 1),
                                                            borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                                          ),
                                                          child: new Container(
                                                            padding: EdgeInsets.all(3),
                                                            child: Icon(Icons.keyboard_arrow_right,color: global.whiteColor,),
                                                          )
                                                      ),
                                                    )
                                                  ],
                                                )
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                ),
                              ),

                            ],
                          ),

                        ]
                    )
                  //  ]))])
                )
            )
        )
    );
  }
}