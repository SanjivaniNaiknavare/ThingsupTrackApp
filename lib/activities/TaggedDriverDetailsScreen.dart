import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helperClass/DriverObject.dart';


class TaggedDriverDetailsScreen extends StatefulWidget
{
  TaggedDriverDetailsScreen({Key key,this.index,this.driverObject}) : super(key: key);
  int index;
  TaggedDriverObject driverObject;

  @override
  _DriverDetailsScreenState createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<TaggedDriverDetailsScreen> {
  String LOGTAG = "TaggedDriverDetailsScreen";

  bool isResponseReceived=true;
  bool deviceValidate = false;
  bool driverValidate = false;

  String selectedDevice;
  String selectedDriver;

  List<String> listOfDevices=new List();
  List<String> listOfDrivers=new List();

  Map<String,dynamic> deviceIDNameMap=new Map();
  Map<String,dynamic> driverIDNameMap=new Map();

  final deviceController = TextEditingController();
  final driverController = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    global.lastFunction = "";

    for(var keys in global.myDevices.keys)
    {
      DeviceObjectAllAccount deviceObjectAllAccount=global.myDevices[keys];
      String tempData=deviceObjectAllAccount.uniqueid+"["+deviceObjectAllAccount.name+"]";
      listOfDevices.add(tempData);
      deviceIDNameMap.putIfAbsent(tempData, () => deviceObjectAllAccount.uniqueid);
    }

    for(var keys in global.myDrivers.keys)
    {
      DriverObject driverObject=global.myDrivers[keys];
      String tempData=driverObject.name;
      listOfDrivers.add(tempData);
      driverIDNameMap.putIfAbsent(tempData, () => driverObject.id);
    }
  }


  void tagDriverToDevice() async
  {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    deviceValidate = false;
    driverValidate=false;

    String deviceData = selectedDevice;
    String driverDData = selectedDriver;

    if (deviceData.isEmpty || deviceData == " " || deviceData.length == 0 || deviceData == "null")
    {
      deviceValidate = true;
    }
    else
    {
      deviceValidate = false;
    }

    if (driverDData.isEmpty || driverDData == " " || driverDData.length == 0 || driverDData == "null")
    {
      driverValidate = true;
    }
    else
    {
      driverValidate = false;
    }

    setState(() {});

    if (!deviceValidate && !driverValidate)
    {
      isResponseReceived = false;
      setState(() {});

      String uniqueid = deviceIDNameMap[selectedDevice];
      String id = driverIDNameMap[selectedDriver];


      TagDriverToDeviceClass tagDriverToDeviceClass = new TagDriverToDeviceClass(id: id, uniqueid: uniqueid);
      var jsonBody = jsonEncode(tagDriverToDeviceClass);

      print(LOGTAG + " addDriver jsonbody->" + jsonBody.toString());

      Response response = await global.apiClass.TagDriverToDevice(jsonBody);
      if (response != null)
      {

        print(LOGTAG + " addDriver statusCode->" + response.statusCode.toString());
        print(LOGTAG + " addDriver body->" + response.body.toString());

        if (response.statusCode == 200)
        {
          global.lastFunction = "addDriver";
          _onbackButtonPressed();
        }
        else if (response.statusCode == 400)
        {
          isResponseReceived = true;
          setState(() {});
          var resBody = json.decode(response.body);
          String status = resBody['status'];

          if (status.toString().contains("Driver Already Exist"))
          {
            global.helperClass.showAlertDialog(context, "", "Driver Already Exist", false, "");
          }
          else if (status.toString().contains("User is not owner of Device"))
          {
            global.helperClass.showAlertDialog(context, "", "User Is Not Owner Of Device", false, "");
          }
        }
        else if (response.statusCode == 500)
        {
          isResponseReceived = true;
          setState(() {});
          global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
        }
      }
      else
      {
        isResponseReceived = true;
        setState(() {});
        global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
      }
    }
  }


  Future<bool> _onbackButtonPressed()
  {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){


    return WillPopScope(
        onWillPop: _onbackButtonPressed,
        child: Scaffold(
            appBar:AppBar(
              titleSpacing: 0.0,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child:new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child:  Container(
                                height: kToolbarHeight-10,
                                padding:  EdgeInsets.fromLTRB(15,0,0,0),
                                child: new Container(
                                    child: GestureDetector(
                                        onTap: (){_onbackButtonPressed();},
                                        child: new Container(
                                          height: 20,
                                          child:Image(image: AssetImage('assets/back-arrow.png')),
                                        )
                                    )
                                )
                            ),
                          )
                        ],
                      )
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: new Text("Tag Driver",style: TextStyle(fontSize: global.font18, color: global.mainBlackColor,fontWeight: FontWeight.w600,fontFamily: 'MulishRegular'))
                        )
                      ],
                    ),
                  ),
                  Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child:new Container()
                  )
                ],
              ),
              backgroundColor:global.screenBackColor,
            ),
            body:Container(
              height: MediaQuery.of(context).size.height,
              color: global.screenBackColor,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:isResponseReceived? SingleChildScrollView(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(height: 5,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child:  Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                                  decoration: !deviceValidate?BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Color(0xffffffff), border: Border.all(color:Color(0xffc4c4c4),width: 0.5)):BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: global.errorTextFieldFillColor, border: Border.all(color:Color(0xffc4c4c4),width: 0.5)),
                                  child: new DropdownButtonHideUnderline(
                                      child: new DropdownButton<String>(
                                        hint: Text('Select device',style: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular')),
                                        isExpanded: true,
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                        value: selectedDevice,
                                        items: listOfDevices.map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  new Flexible(
                                                      child:new Container(
                                                          margin:EdgeInsets.fromLTRB(0,0,0,0),
                                                          child:  new Text(value,
                                                            style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
                                                            overflow: TextOverflow.ellipsis,
                                                          )
                                                      )
                                                  )
                                                ]
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newval)
                                        {
                                          deviceValidate=false;
                                          setState(() {selectedDevice=newval;});
                                        },
                                      )
                                  )
                              ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child:Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                                  decoration: !driverValidate?BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Color(0xffffffff), border: Border.all(color:Color(0xffc4c4c4),width: 0.5)):BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: global.errorTextFieldFillColor, border: Border.all(color:Color(0xffc4c4c4),width: 0.5)),
                                  child: new DropdownButtonHideUnderline(
                                      child: new DropdownButton<String>(
                                        hint: Text('Select driver',style: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular')),
                                        isExpanded: true,
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                        value: selectedDriver,
                                        items: listOfDrivers.map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  new Flexible(
                                                      child:new Container(
                                                          margin:EdgeInsets.fromLTRB(0,0,0,0),
                                                          child:  new Text(value,
                                                            style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
                                                            overflow: TextOverflow.ellipsis,
                                                          )
                                                      )
                                                  )
                                                ]
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newval)
                                        {
                                          driverValidate=false;
                                          setState(() {selectedDriver=newval;});
                                        },
                                      )
                                  )
                              ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: new RaisedButton(
                            onPressed: () {
                              tagDriverToDevice();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            color: Color(0xff2D9F4C),
                            child:new Text('Tag Driver', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                        ),
                      ),
                    ],
                  )
              ):new Container(
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
              ),
            )
        )
    );
  }
}

