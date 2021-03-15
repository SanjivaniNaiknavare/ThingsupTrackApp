import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/DriverObject.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenDriverInfo extends StatefulWidget
{
  HomeScreenDriverInfo({Key key,this.deviceObjectAllAccount}) : super(key: key);
  DeviceObjectAllAccount deviceObjectAllAccount;


  @override
  _HomeScreenDriverInfoState createState() => _HomeScreenDriverInfoState();
}

class _HomeScreenDriverInfoState extends State<HomeScreenDriverInfo> {

  String LOGTAG = "HomeScreenDriverInfo";
  File userSelectedImg;
  DriverObject driverObject;
  bool isResponseReceived=false;


  @override
  void initState() {
    super.initState();

    getDriverInfo();

    print(LOGTAG + " deviceObjectAllAccount->" + widget.deviceObjectAllAccount.toString());
  }

  void getDriverInfo() async
  {

    Response response=await global.apiClass.GetDriverInfoFromDevice(widget.deviceObjectAllAccount.uniqueid);
    print(LOGTAG+" getDriverInfo response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getDriverInfo statusCode->"+response.statusCode.toString());
      print(LOGTAG+" getDriverInfo body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getDriverInfo->"+resBody.toString());

        int reslength=resBody.toString().length;
        print(LOGTAG+" resBody length->"+reslength.toString());

        if(reslength>30)
        {
          Map<String,dynamic> payloadList = resBody;

          int id = payloadList['id'];
          int driverid = payloadList['driverid'];
          String name = payloadList['name'];
          String phone = payloadList['phone'];
          String photo = payloadList['photo'];
          String attributes = payloadList['attributes'];

          if(photo!=null)
          {
            if(photo.length>0)
            {
              Uint8List MainprofileImg=base64Decode(photo);

              final tempDir = await getTemporaryDirectory();
              final file = await new File('${tempDir.path}/image'+DateTime.now().millisecondsSinceEpoch.toString()+'.jpg').create();
              file.writeAsBytesSync(MainprofileImg);
              userSelectedImg=file;

              print(LOGTAG+" userSelectedImg path->"+userSelectedImg.path.toString());
            }
          }
          driverObject = new DriverObject(id: id.toString(), driverid: driverid.toString(), name: name, phone: phone, photo: photo, attributes: attributes);

          isResponseReceived=true;
          setState(() {});
        }
        else
        {
          String status=resBody['status'];
          if(status.toString().compareTo("Driver not found")==0)
          {
            isResponseReceived=true;
            setState(() {});
            //global.helperClass.showAlertDialog(context, "", "Driver not found", false, "");
          }
        }
      }
      else if (response.statusCode == 500)
      {
        isResponseReceived=true;
        setState(() {});
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      isResponseReceived=true;
      setState(() {});
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }


  @override
  Widget build(BuildContext context) {
    return isResponseReceived?(driverObject!=null?new Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: new BoxDecoration(
          color: global.whiteColor,
          border: Border.all(color: Color(0xffc4c4c4),width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12.0),),
        ),
        child:new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text('Driver Info :',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font16, color: Color(0xff121212),fontWeight: FontWeight.w600,fontFamily: 'MulishRegular')),
              ],
            ),
            SizedBox(height: 10,),
            new Row(
              children: <Widget>[
                new Container(
                  height: 50,
                  width: 50,
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
                        image:  AssetImage("assets/default-avatar-icon.png"),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: global.whiteColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                ),
                SizedBox(width: 5,),
                new Text(driverObject.name.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: global.font14, color: global.darkBlack,fontWeight:FontWeight.w600,fontFamily: 'MulishRegular'))
              ],
            ),
            SizedBox(height: 10,),
            new Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    String callStr="tel://"+driverObject.phone.toString();
                    launch(callStr);
                  },
                  child: new Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      //margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                      decoration: new BoxDecoration(
                        color: global.transparent,
                        border: Border.all(color: Color(0xff2D9F4C),width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(8.0),),
                      ),
                      child:new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new SvgPicture.asset('assets/green-phone-icon.svg')
                          ),
                          new Text(driverObject.phone.toString(), style: TextStyle(fontSize: global.font14, color: global.darkBlack,fontFamily: 'MulishRegular')),

                        ],
                      )
                  ),
                )
              ],
            )
          ],
        )
    ):new Container(
      height: MediaQuery.of(context).size.height/2,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text('No driver found',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font16, color: Color(0xff121212),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),

        ],
      ),
    )):new Container(
        height: MediaQuery.of(context).size.height/2,
        child:Center(
          child:new Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(global.secondaryBlueColor),
              backgroundColor: global.lightGreyColor,
              strokeWidth: 5,),
          ),
        )
    );
  }
}