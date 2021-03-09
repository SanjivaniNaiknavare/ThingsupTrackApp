import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DriverObject.dart';
import 'package:thingsuptrackapp/helperClass/UserObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter_svg/flutter_svg.dart';



class ListOfDrivers extends StatefulWidget
{
  ListOfDrivers({Key key,this.index,this.driverObject,this.onTabCicked}) : super(key: key);
  int index;
  ValueChanged<String> onTabCicked;
  DriverObject driverObject;

  @override
  _ListOfDriversState createState() => _ListOfDriversState();
}

class _ListOfDriversState extends State<ListOfDrivers>
{

  String LOGTAG="ListOfDrivers";
  bool status = false;
  File userSelectedImg;
  Uint8List imageBytes;

  @override
  void initState(){
    super.initState();

    initPhoto();
  }

  void initPhoto() async{

    if(widget.driverObject.photo!=null)
    {
      if(widget.driverObject.photo.length>0)
      {
        Uint8List MainprofileImg=base64Decode(widget.driverObject.photo);
        imageBytes=MainprofileImg;

        final tempDir = await getTemporaryDirectory();
        final file = await new File('${tempDir.path}/image'+DateTime.now().millisecondsSinceEpoch.toString()+'.jpg').create();
        file.writeAsBytesSync(MainprofileImg);
        userSelectedImg=file;

        print(LOGTAG+" userSelectedImg path->"+userSelectedImg.path.toString());
      }
    }
    setState(() {});

  }



  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child:new Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
            child:Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: new BoxDecoration(
                  color: global.whiteColor,
                  border: Border.all(color: Color(0xffc4c4c4),width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(8.0),),
                ),
                child:new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Flexible(
                          flex:1,
                          fit:FlexFit.tight,
                          child:new Container(
                              child:
                              userSelectedImg==null?new Container(
                                child: Image(image: AssetImage("assets/dummy-user-profile.png")),
                              ):new Container(
                                  child: Image(image: MemoryImage(imageBytes))
                              )
                          ),
                        ),
                        new Flexible(
                            flex:3,
                            fit:FlexFit.tight,
                            child:new Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                        child:new SvgPicture.asset('assets/blue-user-icon.svg')
                                    ),
                                    SizedBox(width:5),
                                    Expanded(
                                        child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Text(widget.driverObject.name.toString(), maxLines: 10,style: TextStyle(fontSize: global.font16, color: global.darkBlack,fontFamily: 'MulishRegular'))
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                                SizedBox(height:5),
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                        child:new SvgPicture.asset('assets/green-phone-icon.svg')
                                    ),
                                    SizedBox(width:5),
                                    Expanded(
                                        child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              widget.driverObject.phone!=null?new Text(widget.driverObject.phone.toString(), style: TextStyle(fontSize: global.font16, color: global.darkBlack,fontFamily: 'MulishRegular')):
                                              new Text("NA",
                                                  maxLines: 10,
                                                  style: TextStyle(fontSize: global.font16, color: global.darkBlack,fontFamily: 'MulishRegular'))
                                            ]
                                        )
                                    )
                                  ],
                                ),
                                SizedBox(height:5),
                              ],
                            )
                        )
                      ],
                    ),
                    SizedBox(height:5),
                    new Row(
                      children: <Widget>[
                        new Flexible(
                            flex:1,
                            fit:FlexFit.tight,
                            child:new Container(
                            )
                        ),
                        new Flexible(
                            flex:3,
                            fit:FlexFit.tight,
                            child:new Container(
                                height: 45,
                                child: new Row(
                                  children: <Widget>[
                                    Flexible(
                                        flex:1,
                                        fit:FlexFit.tight,
                                        child:GestureDetector(
                                          onTap: (){
                                            widget.onTabCicked("Edit");
                                          },
                                          child: new Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 45,
                                              padding: EdgeInsets.fromLTRB(8,8,8,8),
                                              margin: EdgeInsets.fromLTRB(5,0,5,0),
                                              decoration: new BoxDecoration(
                                                color: global.transparent,
                                                border: Border.all(color: Color(0xffc4c4c4),width: 1),
                                                borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                              ),
                                              child:new SvgPicture.asset('assets/edit-pencil-icon.svg',height: 20,)
                                          ),
                                        )
                                    ),
                                    Flexible(
                                        flex:1,
                                        fit:FlexFit.tight,
                                        child:GestureDetector(
                                          onTap: (){
                                            widget.onTabCicked("Delete");
                                          },
                                          child: new Container(
                                              height: 45,
                                              padding: EdgeInsets.fromLTRB(8,8,8,8),
                                              margin: EdgeInsets.fromLTRB(5,0,5,0),
                                              width: MediaQuery.of(context).size.width,
                                              decoration: new BoxDecoration(
                                                color: global.transparent,
                                                border: Border.all(color: Color(0xffc4c4c4),width: 1),
                                                borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                              ),
                                              child: new SvgPicture.asset('assets/delete-icon.svg')
                                          ),
                                        )
                                    ),
                                    Flexible(
                                        flex:2,
                                        fit:FlexFit.tight,
                                        child:new Container(
//                                            margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
//                                            decoration: new BoxDecoration(
//                                              color: global.transparent,
//                                              border: Border.all(color: Color(0xffc4c4c4),width: 1),
//                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
//                                            ),
//                                            child:new Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              crossAxisAlignment: CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Flexible(
//                                                    flex:1,
//                                                    fit:FlexFit.tight,
//                                                    child:new Row(
//                                                      mainAxisAlignment: MainAxisAlignment.center,
//                                                      crossAxisAlignment: CrossAxisAlignment.center,
//                                                      children: <Widget>[
//                                                        new Text("Status", style: TextStyle(fontSize: global.font14, color: global.darkBlack,fontFamily: 'MulishRegular')),
//                                                      ],
//                                                    )
//                                                ),
//                                                Flexible(
//                                                    flex:1,
//                                                    fit:FlexFit.tight,
//                                                    child: new Container()
//                                                )
//                                              ],
//                                            )
                                        )
                                    )
                                  ],
                                )
                            )
                        )
                      ],
                    )
                  ],
                )
            )
        )
    );
  }
}