import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helpers/AttributeTable.dart';

class HomeScreenDeviceDetails extends StatefulWidget
{
  HomeScreenDeviceDetails({Key key,this.deviceObjectAllAccount,this.scrollController}) : super(key: key);
  DeviceObjectAllAccount deviceObjectAllAccount;
  ScrollController scrollController;


  @override
  _HomeScreenDeviceDetailsState createState() => _HomeScreenDeviceDetailsState();
}

class _HomeScreenDeviceDetailsState extends State<HomeScreenDeviceDetails> {

  String LOGTAG="HomeScreenDeviceDetails";

  List<String> attributeKeysList=new List();
  List<String> attributeValuesList=new List();

  @override
  void initState() {
    super.initState();

    if(widget.deviceObjectAllAccount.attributes!=null)
    {
      if(widget.deviceObjectAllAccount.attributes.length>0)
      {
        attributeKeysList.add("Name");
        attributeValuesList.add("value");
        for (var entry in widget.deviceObjectAllAccount.attributes.entries) {
          attributeKeysList.add(entry.key.toString());
          attributeValuesList.add(entry.value.toString());
        }
      }
      else if(widget.deviceObjectAllAccount.attributes.length==0)
      {
        attributeKeysList.add("Name");
        attributeValuesList.add("value");
      }
    }
    else
    {
      attributeKeysList.add("Name");
      attributeValuesList.add("value");
    }

    print(LOGTAG+" deviceObjectAllAccount->"+widget.deviceObjectAllAccount.attributes.toString());

  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child:Container(
            child:
            new Column(
                children: <Widget>[
                  new Container(
                      decoration: new BoxDecoration(
                        color: Color(0xff2D9F4C),
                        border: Border.all(color: Color(0xffc4c4c4),width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.0),),
                      ),
                      child:
                      new Row(
                        children: <Widget>[
                          Flexible(
                            flex:1,
                            fit: FlexFit.tight,
                            child: new Container(
                                color: Color(0xff2D9F4C),
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
                                    border: Border.all(color: Color(0xffffffff),width: 0.5),
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
                                                new Text(widget.deviceObjectAllAccount.name.toString(),textAlign: TextAlign.center, style: TextStyle(fontSize: global.font16, color: global.mainBlackColor,fontWeight: FontWeight.w600,fontFamily: 'MulishRegular')),

                                              ],
                                            )
                                        ),
                                        Flexible(
                                            flex:2,
                                            fit: FlexFit.tight,
                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Container(child:new SvgPicture.asset('assets/green-wifi-icon.svg')),
                                                SizedBox(width: 5,),
                                                new Text(widget.deviceObjectAllAccount.status.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: global.font12, color: global.mainBlackColor,fontFamily: 'MulishRegular'),
                                                )
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                            flex:3,
                                            fit: FlexFit.tight,
                                            child:new Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Text("Last Updated",textAlign: TextAlign.center, style: TextStyle(fontSize: global.font12, color: Color(0xff6b6b6b),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                SizedBox(height: 5,),
                                                new Text(widget.deviceObjectAllAccount.lastUpdate.toString(), style: TextStyle(fontSize: global.font12, color: global.mainBlackColor,fontWeight: FontWeight.w600,fontFamily: 'MulishRegular')),
                                              ],
                                            )
                                        ),
                                        Flexible(
                                            flex:2,
                                            fit: FlexFit.tight,
                                            child:new Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Container(
                                                    child:new SvgPicture.asset('assets/speed-icon.svg')
                                                ),
                                                SizedBox(width:5),
                                                new Text(widget.deviceObjectAllAccount.speed.toString()+" km/hr",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: global.font13, color: global.mainBlackColor,fontWeight:FontWeight.w300,fontFamily: 'MulishRegular'),
                                                ),
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
                      )
                  ),
                  new Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      color: global.whiteColor,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Attributes :",style:TextStyle(fontSize: global.font16, color: global.mainBlackColor,fontWeight:FontWeight.w600,fontFamily: 'MulishRegular')),
                              ],
                            ),
                            SizedBox(height: 10),
                            new ListView.builder
                              (
                                padding: EdgeInsets.only(top: 0),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: attributeKeysList.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  String key=attributeKeysList.elementAt(index);
                                  String value=attributeValuesList.elementAt(index);

                                  return Container(
                                    child: AttributeTable(index:index,keyData: key,valueData:value),
                                  );
                                }
                            )
                          ]
                      )

                  )
                ]
            )

        )
    );
  }
}