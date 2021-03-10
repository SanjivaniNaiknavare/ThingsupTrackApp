import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'package:thingsuptrackapp/helperClass/DriverObject.dart';

import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter_svg/flutter_svg.dart';



class ListOfTaggedDrivers extends StatefulWidget
{
  ListOfTaggedDrivers({Key key,this.index,this.taggedDriverObject,this.onTabCicked}) : super(key: key);
  int index;
  ValueChanged<String> onTabCicked;
  TaggedDriverObject taggedDriverObject;

  @override
  _ListOfTaggedDriversState createState() => _ListOfTaggedDriversState();
}

class _ListOfTaggedDriversState extends State<ListOfTaggedDrivers>
{

  String LOGTAG="ListOfTaggedDrivers";
  bool status = false;
  File userSelectedImg;
  Uint8List imageBytes;

  @override
  void initState(){
    super.initState();

    initPhoto();
  }

  void initPhoto() async
  {
    DriverObject driverObject=global.myDrivers[widget.taggedDriverObject.id];

    if(driverObject!=null)
    {
      if(driverObject.photo!=null)
      {
        if (driverObject.photo.length > 0)
        {
          Uint8List MainprofileImg = base64Decode(driverObject.photo);
          imageBytes = MainprofileImg;

          final tempDir = await getTemporaryDirectory();
          final file = await new File('${tempDir.path}/image' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg').create();
          file.writeAsBytesSync(MainprofileImg);
          userSelectedImg = file;

          print(LOGTAG + " userSelectedImg path->" + userSelectedImg.path.toString());
        }
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
                            height: 80,
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
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ):new BoxDecoration(
                                color: global.whiteColor,
                                image:  DecorationImage(
                                  image:  AssetImage("assets/dummy-user-profile.png"),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: global.whiteColor,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),

//                              child: userSelectedImg==null?new Container(
//                                child: Image(image: AssetImage("assets/dummy-user-profile.png")),
//                              ):new Container(
//                                  child: Image(image: MemoryImage(imageBytes))
//                              )
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
                                              new Text(widget.taggedDriverObject.name.toString(), maxLines: 10,style: TextStyle(fontSize: global.font16, color: global.darkBlack,fontFamily: 'MulishRegular'))
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                                SizedBox(height:5),
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                        child:new SvgPicture.asset('assets/yellow-mail-icon.svg')
                                    ),
                                    SizedBox(width:5),
                                    Expanded(
                                        child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Text(widget.taggedDriverObject.uniqueid.toString(), style: TextStyle(fontSize: global.font16, color: global.darkBlack,fontFamily: 'MulishRegular'))
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
                                        flex:1,
                                        fit:FlexFit.tight,
                                        child:new Container()
                                    ),
                                    Flexible(
                                        flex:2,
                                        fit:FlexFit.tight,
                                        child:new Container(
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