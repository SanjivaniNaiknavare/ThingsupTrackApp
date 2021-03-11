import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helpers/ShowTypePopupForDevice.dart';

class DeviceDetailsScreen extends StatefulWidget
{
  DeviceDetailsScreen({Key key,this.index,this.deviceObjectAllAccount}) : super(key: key);
  int index;
  DeviceObjectAllAccount deviceObjectAllAccount;
  @override
  _DeviceDetailsScreenState createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  String LOGTAG = "DeviceDetailsScreen";

  String selectedTypeForDevice = "";

  bool isResponseReceived=true;
  bool nameValidate = false;
  bool deviceIDValidate = false;
  bool grpIDValidate = false;
  bool phoneValidate = false;
  bool modelValidate = false;
  bool contactValidate = false;
  bool latitudeValidate = false;
  bool longitudeValidate = false;
  bool typeValidate = false;
  bool isStatic = false;

  final nameController = TextEditingController();
  final deviceIDController = TextEditingController();
  final grpIDController = TextEditingController();
  final phoneController = TextEditingController();
  final modelController = TextEditingController();
  final contactController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  final typeController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = new LatLng(18.6, 73.7);
  Set<Marker> _markers = new HashSet<Marker>();

  @override
  void initState()
  {
    super.initState();
    global.lastFunction = "";

    if (widget.deviceObjectAllAccount != null)
    {
      nameController.text = widget.deviceObjectAllAccount.name.toString();
      deviceIDController.text = widget.deviceObjectAllAccount.uniqueid.toString();
      grpIDController.text = widget.deviceObjectAllAccount.groupid.toString();
      phoneController.text = widget.deviceObjectAllAccount.phone.toString();
      modelController.text = widget.deviceObjectAllAccount.model.toString();
      contactController.text = widget.deviceObjectAllAccount.contact.toString();
      typeController.text = widget.deviceObjectAllAccount.type.toString();

      if (widget.deviceObjectAllAccount.static != null)
      {
        LatLngClass latLngClass = widget.deviceObjectAllAccount.static;
        latController.text = latLngClass.lat.toString();
        longController.text = latLngClass.lng.toString();
        _setMarkers(new LatLng(latLngClass.lat, latLngClass.lng));
        _center = new LatLng(latLngClass.lat, latLngClass.lng);
        isStatic = true;
      }
    }
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _setMarkers(LatLng point)
  {
    _markers.clear();
    final String markerIdVal = 'marker_id_1';
    setState(() {
      latitudeValidate=false;
      longitudeValidate=false;
      latController.text = double.parse((point.latitude).toStringAsFixed(2)).toString();
      longController.text = double.parse((point.longitude).toStringAsFixed(2)).toString();
      _markers.add(
        Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId(markerIdVal),
            position: point,
            anchor: Offset(0.5, 0.5)
        ),
      );
    });
  }

  void deleteDevice(String userindex) async
  {
    isResponseReceived=false;
    setState(() {});

    Response response=await global.apiClass.DeleteDevice(userindex);
    if(response!=null)
    {
      print(LOGTAG+" deleteDelete statusCode->"+response.statusCode.toString());
      print(LOGTAG+" deleteDelete body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        global.lastFunction="deleteDevice";
        _onbackButtonPressed();
      }
      else if (response.statusCode == 400)
      {
        isResponseReceived=true;
        setState(() {});
        global.helperClass.showAlertDialog(context, "", "User Not Found", false, "");
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

  void addDevice() async
  {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    bool isvalid = false;
    nameValidate = false;
    deviceIDValidate = false;

    selectedTypeForDevice=typeController.text;
    String nameData = nameController.text;
    String deviceIDData = deviceIDController.text;

    if (nameData.isEmpty || nameData == " " || nameData.length == 0 || nameData == "null")
    {
      nameValidate = true;
    }
    else
    {
      nameValidate = false;
    }

    if (deviceIDData.isEmpty || deviceIDData == " " || deviceIDData.length == 0 || deviceIDData == "null")
    {
      deviceIDValidate = true;
    }
    else
    {
      deviceIDValidate = false;
    }

    if (isStatic)
    {
      String latData = latController.text.toString();
      String lngData = longController.text.toString();

      if (latData.isEmpty || latData == " " || latData.length == 0 || latData == "null")
      {
        latitudeValidate = true;
      }
      else
      {
        latitudeValidate = false;
      }

      if (lngData.isEmpty || lngData == " " || lngData.length == 0 || lngData == "null")
      {
        longitudeValidate = true;
      }
      else
      {
        longitudeValidate = false;
      }
    }

    if (!nameValidate && !deviceIDValidate)
    {
      isvalid = true;
    }
    else
    {
      isvalid = false;
    }

    if (isStatic)
    {
      if (!latitudeValidate && !longitudeValidate)
      {
        isvalid = true;
      }
      else
      {
        isvalid = false;
      }
    }

    setState(() {});

    if (isvalid)
    {
      if (!selectedTypeForDevice.isEmpty && selectedTypeForDevice != " " && selectedTypeForDevice.length > 0)
      {
        isResponseReceived=false;
        setState(() {});

        String name = nameData;
        String uniqueid = deviceIDData;
        String groupid = grpIDController.text;
        String phone = phoneController.text;
        String model = modelController.text;
        String contact = contactController.text;
        String type = selectedTypeForDevice;
        LatLngClass static;

        if (isStatic)
        {
          double latData = double.parse(latController.text.toString());
          double lngData = double.parse(longController.text.toString());
          static = new LatLngClass(lat: latData, lng: lngData);
        }

        AddAndUpdateDeviceClass addDeviceClass = new AddAndUpdateDeviceClass(name: name, uniqueid: uniqueid, static: static, groupid: groupid, phone: phone, model: model, contact: contact, type: type);
        var jsonBody = jsonEncode(addDeviceClass);
        print(LOGTAG + " addDevice jsonbody->" + jsonBody.toString());

        Response response = await global.apiClass.AddDevice(jsonBody);
        if (response != null)
        {
          print(LOGTAG + " addDevice statusCode->" + response.statusCode.toString());
          print(LOGTAG + " addDevice body->" + response.body.toString());

          if (response.statusCode == 200)
          {
            global.lastFunction="addDevice";
            _onbackButtonPressed();
          }
          else if (response.statusCode == 400)
          {
            isResponseReceived=true;
            setState(() {});

            var resBody = json.decode(response.body);
            String status = resBody['status'];

            if (status.toString().contains("Device Already Exist"))
            {
              global.helperClass.showAlertDialog(context, "", "Device Already Exist", false, "");
            }
            else if (status.toString().contains("Unsupported Type"))
            {
              global.helperClass.showAlertDialog(context, "", "Unsupported Device Type", false, "");
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
      else
      {
        global.helperClass.showAlertDialog(context, "", "Please select type for device", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please provide valid data", false, "");
    }
  }

  void updateDevice() async
  {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    bool isvalid = false;
    nameValidate = false;
    deviceIDValidate = false;

    selectedTypeForDevice=typeController.text;
    String nameData = nameController.text;
    String deviceIDData = deviceIDController.text;

    if (nameData.isEmpty || nameData == " " || nameData.length == 0 || nameData == "null")
    {
      nameValidate = true;
    }
    else
    {
      nameValidate = false;
    }

    if (deviceIDData.isEmpty || deviceIDData == " " || deviceIDData.length == 0 || deviceIDData == "null")
    {
      deviceIDValidate = true;
    }
    else
    {
      deviceIDValidate = false;
    }

    if (isStatic)
    {
      String latData = latController.text.toString();
      String lngData = longController.text.toString();

      if (latData.isEmpty || latData == " " || latData.length == 0 || latData == "null")
      {
        latitudeValidate = true;
      }
      else
      {
        latitudeValidate = false;
      }

      if (lngData.isEmpty || lngData == " " || lngData.length == 0 || lngData == "null")
      {
        longitudeValidate = true;
      }
      else
      {
        longitudeValidate = false;
      }
    }

    if (!nameValidate && !deviceIDValidate)
    {
      isvalid = true;
    }
    else
    {
      isvalid = false;
    }

    if (isStatic)
    {
      if (!latitudeValidate && !longitudeValidate)
      {
        isvalid = true;
      }
      else
      {
        isvalid = false;
      }
    }

    setState(() {});

    if (isvalid)
    {
      if (!selectedTypeForDevice.isEmpty && selectedTypeForDevice != " " && selectedTypeForDevice.length > 0)
      {
        isResponseReceived=false;
        setState(() {});

        String name = nameData;
        String uniqueid = deviceIDData;
        String groupid = grpIDController.text;
        String phone = phoneController.text;
        String model = modelController.text;
        String contact = contactController.text;
        String type = selectedTypeForDevice;
        LatLngClass static;

        if (isStatic)
        {
          double latData = double.parse(latController.text.toString());
          double lngData = double.parse(longController.text.toString());
          static = new LatLngClass(lat: latData, lng: lngData);
        }

        AddAndUpdateDeviceClass addDeviceClass=new AddAndUpdateDeviceClass(name: name,uniqueid: uniqueid,static: static,groupid: groupid,phone: phone,model: model,contact: contact,type: type);
        var jsonBody=jsonEncode(addDeviceClass);
        print(LOGTAG+" updateDevice jsonbody->"+jsonBody.toString());

        Response response=await global.apiClass.UpdateDevice(jsonBody);
        if(response!=null)
        {
          print(LOGTAG+" updateDevice statusCode->"+response.statusCode.toString());
          print(LOGTAG+" updateDevice body->"+response.body.toString());

          if (response.statusCode == 200)
          {
            var resBody = json.decode(response.body);
            global.lastFunction="updateDevice";
            _onbackButtonPressed();
          }
          else if (response.statusCode == 400)
          {
            isResponseReceived=true;
            setState(() {});
            global.helperClass.showAlertDialog(context, "", "Device Already Exist", false, "");
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
      else
      {
        global.helperClass.showAlertDialog(context, "", "Please select type for device", false, "");
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please provide valid data", false, "");
    }
  }

  void deleteConfirmationPopup(String selindex)
  {
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new Container(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("Are you sure you want to delete the \'"+widget.deviceObjectAllAccount.name.toString()+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Color(0xffdcdcdc), width: 1.0,),),
                      ),
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
                                  child: Text("Cancel", style: TextStyle(fontSize: global.font15,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
                                  onPressed: (){ Navigator.of(context).pop(); },
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
                                  child: Text("OK", style: TextStyle(fontSize: global.font15,color:global.mainColor,fontStyle: FontStyle.normal)),
                                  onPressed: () async {
                                    deleteDevice(selindex);
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showDropDownDiailogForType()
  {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: global.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: global.popupBackColor,
                border: Border.all(color:global.popupBackColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                  child:SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child:new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 3,
                                      fit: FlexFit.tight,
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          new Text("Select type fo device", style: TextStyle(fontSize: global.font18,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishSemiBold')),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap:(){Navigator.of(context).pop();},
                                            child:   new Container(
                                              height:20,
                                              width:20,
                                              child:Image(image: AssetImage("assets/close-red-icon.png"),color: global.mainBlackColor,),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                ShowTypePopupForDevice(selectedType: (value){
                                  selectedTypeForDevice=value;
                                  typeController.text=value;
                                  setState(() {});
                                },
                                )
                              ],
                            )
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  )
              ),
            ),
          );
        });
  }

  Future<bool> _onbackButtonPressed()
  {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){

    final nameField = TextField(
      onTap: () {
        setState(() {nameValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: nameController,
      decoration:!nameValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.deviceObjectAllAccount==null?"Name":widget.deviceObjectAllAccount.name.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.deviceObjectAllAccount==null?"Name":widget.deviceObjectAllAccount.name.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );


    final deviceIDField = TextField(
      onTap: () {
        setState(() {deviceIDValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: deviceIDController,
      decoration:!deviceIDValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.deviceObjectAllAccount==null?"Device ID":widget.deviceObjectAllAccount.uniqueid.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.deviceObjectAllAccount==null?"Device ID":widget.deviceObjectAllAccount.uniqueid.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final groupIDField = TextField(
      onTap: () {
        setState(() {grpIDValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: grpIDController,
      decoration:!grpIDValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.deviceObjectAllAccount==null?"Group ID":widget.deviceObjectAllAccount.groupid.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.deviceObjectAllAccount==null?"Group ID":widget.deviceObjectAllAccount.groupid.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );


    final phoneField = TextField(
      onTap: () {
        setState(() {phoneValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      keyboardType: TextInputType.phone,
      controller: phoneController,
      decoration:!phoneValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.deviceObjectAllAccount==null?"Phone No":widget.deviceObjectAllAccount.phone.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5,), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.deviceObjectAllAccount==null?"Phone No":widget.deviceObjectAllAccount.phone.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final modelField = TextField(
      onTap: () {
        setState(() {modelValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: modelController,
      decoration:!modelValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.deviceObjectAllAccount==null ?"Model":widget.deviceObjectAllAccount.model.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.deviceObjectAllAccount==null?"Model":widget.deviceObjectAllAccount.model.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final contactField = TextField(
      onTap: () {
        setState(() {contactValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: contactController,
      decoration:!contactValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.deviceObjectAllAccount==null?"Contact":widget.deviceObjectAllAccount.contact.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5,), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.deviceObjectAllAccount==null?"Contact":widget.deviceObjectAllAccount.contact.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final typeField = TextField(
      onTap: () {
        showDropDownDiailogForType();
        setState(() { typeValidate = false; });
      },

      style:TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      controller: typeController,
      readOnly: true,
      decoration:!typeValidate?InputDecoration(
        suffixIcon:IconButton(
          icon: Icon(
            Icons.arrow_drop_down,
            color: global.darkGreyColor.withOpacity(0.9),
          ),
        ),
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Type",
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5,), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Type",
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final latitudeField = TextField(
      onTap: () {
        setState(() { latitudeValidate = false; });
      },

      style:TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      controller: latController,
      readOnly: true,
      decoration:!latitudeValidate?InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Latitude",
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Latitude",
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final longitudeField = TextField(
      onTap: () {
        setState(() { longitudeValidate = false; });
      },

      style:TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      controller: longController,
      readOnly: true,
      decoration:!longitudeValidate?InputDecoration(
        filled: true,
        fillColor: Color(0xffEffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Longitude",
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Longitude",
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    return WillPopScope(
        onWillPop: _onbackButtonPressed,
        child: Scaffold(
            appBar:AppBar(
              titleSpacing: 0.0,
              elevation: 5,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(15,0,0,0),
                      child: GestureDetector(
                          onTap: (){_onbackButtonPressed();},
                          child: new Container(
                            height: 25,
                            child:Image(image: AssetImage('assets/back-arrow.png')),
                          )
                      )
                  ),
                  Container(
                      padding:  EdgeInsets.fromLTRB(15,0,0,0),
                      child: widget.deviceObjectAllAccount!=null?new Text("Edit Device",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                      new Text("Add Device",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                  ),
                ],
              ),
              backgroundColor:global.screenBackColor,
            ),
            body:Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:isResponseReceived? SingleChildScrollView(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.deviceObjectAllAccount!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Name :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 5,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child: new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: SizedBox(
                                  height: 50,
                                  child: nameField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.deviceObjectAllAccount!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Device ID :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 5,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child: new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: SizedBox(
                                  height: 50,
                                  child: deviceIDField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.deviceObjectAllAccount!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Group ID :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 5,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child: new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child:SizedBox(
                                  height: 50,
                                  child: groupIDField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.deviceObjectAllAccount!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Phone No :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 5,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child:new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: SizedBox(
                                  height: 50,
                                  child: phoneField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.deviceObjectAllAccount!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Model :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 5,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child:new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: SizedBox(
                                  height: 50,
                                  child: modelField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.deviceObjectAllAccount!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Contact :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 5,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child:new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: SizedBox(
                                  height: 50,
                                  child: contactField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.deviceObjectAllAccount!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Type :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 5,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                            flex:1,
                            fit: FlexFit.tight,
                            child:  new Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: SizedBox(
                                height: 50,
                                child: typeField,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit: FlexFit.tight,
                              child:new Row(
                                children: <Widget>[
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        new Text("Static :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                        Checkbox(
                                          onChanged: (bool flag) {
                                            isStatic=flag;
                                            setState(() {});
                                          },
                                          value: isStatic,
                                        ),
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                      isStatic?SizedBox(height: 10,):new Container(width: 0,height: 0,),
                      isStatic?new Row(
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child:new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: SizedBox(
                                  height: 50,
                                  child: latitudeField,
                                ),
                              )
                          ),
                          Flexible(
                              flex:1,
                              fit:FlexFit.tight,
                              child:new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: SizedBox(
                                  height: 50,
                                  child: longitudeField,
                                ),
                              )
                          )
                        ],
                      ):new Container(width: 0,height: 0,),
                      isStatic?SizedBox(height: 10,):new Container(width: 0,height: 0,),
                      isStatic?new Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child:GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition:CameraPosition(
                              target: _center,
                              zoom: 11.0,
                            ),
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                              ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                              ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                              ..add(Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer())),
                            markers: _markers,
                            onTap: (point){
                              _setMarkers(point);
                            },
                          )
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 15,),
                      widget.deviceObjectAllAccount!=null?new Row(
                        children: <Widget>[

                          Flexible(
                            flex:1,
                            fit:FlexFit.tight,
                            child:   new Container(
                              padding: EdgeInsets.fromLTRB(0,0,5,0),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: new Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: new RaisedButton(
                                    onPressed: () {
                                      deleteConfirmationPopup(widget.deviceObjectAllAccount.uniqueid);
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),side: BorderSide(color: Color(0xffF7716E))),
                                    color: global.whiteColor,
                                    child:new Text('Delete Device', style: TextStyle(fontSize: global.font14, color: Color(0xffF7716E),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex:1,
                            fit: FlexFit.tight,
                            child: new Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: new RaisedButton(
                                  onPressed: () {
                                    updateDevice();
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                  color: Color(0xff2D9F4C),
                                  child:new Text('Update Device', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                              ),
                            ),
                          )
                        ],
                      ):new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: new RaisedButton(
                            onPressed: () {
                              addDevice();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            color: Color(0xff2D9F4C),
                            child:new Text('Add Device', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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

