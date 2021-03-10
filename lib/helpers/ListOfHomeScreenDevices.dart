import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thingsuptrackapp/helpers/AttributeTable.dart';

class ListOfHomeScreenDevices extends StatefulWidget
{
  ListOfHomeScreenDevices({Key key,this.index,this.scrollController,this.deviceObjectAllAccount,this.onTabCicked}) : super(key: key);
  int index;
  ValueChanged<String> onTabCicked;
  DeviceObjectAllAccount deviceObjectAllAccount;
  ScrollController scrollController;

  @override
  _ListOfHomeScreenDevicesState createState() => _ListOfHomeScreenDevicesState();
}

class _ListOfHomeScreenDevicesState extends State<ListOfHomeScreenDevices>
{

  String LOGTAG="ListOfHomeScreenDevices";
  bool status = false;
  bool expandFlag=false;

  List<String> attributeKeysList=new List();
  List<String> attributeValuesList=new List();


  @override
  void initState(){
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
    }

  }


  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child:new Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
            child:Container(
                decoration: new BoxDecoration(
                  color: Color(0xff2D9F4C),
                  borderRadius: BorderRadius.all(Radius.circular(12.0),),
                ),
                child:
//                CustomScrollView(
//                  controller: widget.scrollController,
//                  scrollDirection: Axis.vertical,
//                  shrinkWrap: true,
//                  slivers: <Widget>[
//                SliverList(
//                delegate: SliverChildListDelegate(
//                  [

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
                                color: global.whiteColor,
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
                                               // SizedBox(width:5),
                                                Expanded(
                                                    child: new Column(
                                                      children: <Widget>[
                                                        new Text(widget.deviceObjectAllAccount.status.toString(),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontFamily: 'MulishRegular'),
                                                        )
                                                      ],
                                                    )
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

                                                    },
                                                    child: new Container(
                                                        height: 35,
                                                        padding: EdgeInsets.fromLTRB(8,8,8,8),
                                                        margin: EdgeInsets.fromLTRB(5,0,5,0),
                                                        width: MediaQuery.of(context).size.width,
                                                        decoration: new BoxDecoration(
                                                          color: global.transparent,
                                                          border: Border.all(color: Color(0xffc4c4c4),width: 1),
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

                                                      },
                                                      child: new Container(
                                                          height: 35,
                                                          padding: EdgeInsets.fromLTRB(8,8,8,8),
                                                          margin: EdgeInsets.fromLTRB(5,0,5,0),
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: new BoxDecoration(
                                                            color: global.transparent,
                                                            border: Border.all(color: Color(0xffc4c4c4),width: 1),
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
                                                new Text(widget.deviceObjectAllAccount.lastUpdate.toString(), style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontWeight: FontWeight.w600,fontFamily: 'MulishRegular')),
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
                                                    expandFlag=!expandFlag;
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
                                                        child: !expandFlag?Icon(Icons.keyboard_arrow_right,color: global.whiteColor,):Icon(Icons.keyboard_arrow_down,color: global.whiteColor,),
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
                      expandFlag && widget.deviceObjectAllAccount.attributes.length>0?new Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          color: global.whiteColor,

                          child:
                          new Column(
                              children:<Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Attributes :",style:TextStyle(fontSize: global.font16, color: Color(0xff121212),fontFamily: 'MulishRegular')),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                new ListView.builder
                                  (
                                    controller: widget.scrollController,
                                    shrinkWrap: true,
                                    itemCount: widget.deviceObjectAllAccount.attributes.length,
                                    itemBuilder: (BuildContext ctxt, int index) {
                                      String key=attributeKeysList.elementAt(index);
                                      String value=attributeValuesList.elementAt(index);

                                      return Container(
                                        height: 50,
                                        child: AttributeTable(index:index,keyData: key,valueData:value),
                                      );
                                    }
                                )
                              ]
                          )

                      ):new Container(width: 0,height: 0,),
                    ]
                )
                //  ]))])
            )
        )
    );
  }
}