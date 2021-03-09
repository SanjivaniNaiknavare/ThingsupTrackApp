import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter/rendering.dart';
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';

class TagDevicePopup extends StatefulWidget
{
  TagDevicePopup({Key key,this.deviceList,this.selecteduserID}) : super(key: key);
  List<DeviceObjectAllAccount> deviceList;
  String selecteduserID;


  @override
  TagDevicePopupState createState() => TagDevicePopupState();
}

class TagDevicePopupState extends State<TagDevicePopup>
{
  String LOGTAG="TagDevicePopup";
  List<String> deviceListStrList=new List();
  bool deviceValidate=false;
  String _selectedDevice;

  @override
  void initState(){
    super.initState();


    for(var key in global.myDevices.keys)
    {
      bool isPresent=false;
      for(int k=0;k<widget.deviceList.length;k++)
      {
        DeviceObjectAllAccount deviceObjectAllAccount=widget.deviceList.elementAt(k);
        if(deviceObjectAllAccount.uniqueid.toString().compareTo(key)==0)
        {
          isPresent=true;
        }
      }

      if(!isPresent)
      {
        DeviceObjectAllAccount deviceObj=global.myDevices[key];
        String tempData=key.toString()+"["+deviceObj.name.toString()+"]";
        deviceListStrList.add(tempData);
      }
    }
    setState(() {});
  }

  void tagUserToDevice() async
  {

    String uniqueid=_selectedDevice;
    String taguserid=widget.selecteduserID;

    TagUserToDevice tagUserToDevice=new TagUserToDevice(uniqueid: uniqueid,taguserid: taguserid);
    var jsonBody=jsonEncode(tagUserToDevice);
    print(LOGTAG+" tagUserToDevice jsonbody->"+jsonBody.toString());

    Response response=await global.apiClass.TagUserToDevice(jsonBody);
    print(LOGTAG+" tagUserToDevice response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" tagUserToDevice statusCode->"+response.statusCode.toString());
      print(LOGTAG+" tagUserToDevice body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" tagUserToDevice->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        var resBody = json.decode(response.body);
        String status=resBody['status'];
        if(status.toString().contains("User is not Child/Access Denied"))
        {
          global.helperClass.showAlertDialog(context, "", "User is not Child/Access Denied", false, "");
        }
        else if(status.toString().contains("Device Doesn't Exist"))
        {
          global.helperClass.showAlertDialog(context, "", "Device Doesn't Exist", false, "");
        }

      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        new Container(
            padding: EdgeInsets.only(left: 0.0, right: 15.0),
            height: 50,
            child:
            new Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child:
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 10.0, right: 15.0),
                      decoration: !deviceValidate?BoxDecoration(borderRadius: BorderRadius.circular(10.0), color:global.transparent, border: Border.all(color:Color(0xffd3d3d3),)):BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: global.errorTextFieldFillColor, border: Border.all(color:Color(0xffd3d3d3),)),
                      child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                              hint: Text('Select Device',style: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular')),
                              isExpanded: true,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              value: _selectedDevice,
                              items: deviceListStrList.map((String value) {
                                return new DropdownMenuItem<String>(
                                    value: value,
                                    child:
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            value,
                                            style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ]
                                    )
                                );
                              }).toList(),
                              onChanged: (newval)
                              {
                                deviceValidate = false;
                                setState(() {_selectedDevice = newval;});
                              }
                          )
                      )
                  ),
                )
              ],
            )
        ),
        SizedBox(height: 20,),
        new Container(
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xffdcdcdc), width: 1.0,),),),
        ),
        new Row(
          children: <Widget>[
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child:new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancel", style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )
            ),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child:new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("OK", style: TextStyle(fontSize: global.font16,color:global.mainColor,fontStyle: FontStyle.normal)),
                      onPressed: () async {
                        tagUserToDevice();
                      },
                    )
                  ],
                )
            )
          ],
        ),
      ],
    );
  }
}