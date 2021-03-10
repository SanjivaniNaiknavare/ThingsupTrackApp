import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DriverObject.dart';


class DriverDetailsScreen extends StatefulWidget
{
  DriverDetailsScreen({Key key,this.index,this.driverObject}) : super(key: key);
  int index;
  DriverObject driverObject;

  @override
  _DriverDetailsScreenState createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  String LOGTAG = "DriverDetailsScreen";

  bool isResponseReceived=true;
  bool nameValidate = false;
  bool phoneValidate = false;
  bool atttrValidate=false;
  String imageSelected="";

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final attrController = TextEditingController();

  File tempfile;
  File userSelectedImg;

  @override
  void initState()
  {
    super.initState();
    global.lastFunction = "";

    getData();
  }

  void getData() async
  {
    if (widget.driverObject != null)
    {
      nameController.text = widget.driverObject.name.toString();
      phoneController.text = widget.driverObject.phone.toString();

      if(widget.driverObject.photo!=null)
      {
        if(widget.driverObject.photo.length>0)
        {
          Uint8List MainprofileImg = base64Decode(widget.driverObject.photo);
          final tempDir = await getTemporaryDirectory();
          final file = await new File('${tempDir.path}/image' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg').create();
          file.writeAsBytesSync(MainprofileImg);
          userSelectedImg = file;
        }
      }
    }
    setState(() {});
  }

  void deleteDriver(String userindex) async
  {
    isResponseReceived=false;
    setState(() {});

    Response response=await global.apiClass.DeleteDevice(userindex);
    if(response!=null)
    {
      print(LOGTAG+" deleteDriver statusCode->"+response.statusCode.toString());
      print(LOGTAG+" deleteDriver body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        global.lastFunction="deleteDriver";
        _onbackButtonPressed();
      }
      else if (response.statusCode == 400)
      {
        isResponseReceived=true;
        setState(() {});
        global.helperClass.showAlertDialog(context, "", "Driver Not Found", false, "");
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

  void addDriver() async
  {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    nameValidate = false;
    phoneValidate=false;

    String nameData = nameController.text;
    String phoneIDData = phoneController.text;

    if (nameData.isEmpty || nameData == " " || nameData.length == 0 || nameData == "null")
    {
      nameValidate = true;
    }
    else
    {
      nameValidate = false;
    }

    if (phoneIDData.isEmpty || phoneIDData == " " || phoneIDData.length == 0 || phoneIDData == "null")
    {
      phoneValidate = true;
    }
    else
    {
      phoneValidate = false;
    }

    setState(() {});

    if (!nameValidate && !phoneValidate)
    {
      if(userSelectedImg!=null)
      {
        List<int> imageBytes = userSelectedImg.readAsBytesSync();
        imageSelected = base64Encode(imageBytes);
        print(LOGTAG+" image length->"+imageSelected.length.toString());
      }

      if(imageSelected.length>0 && imageSelected.length>102400)
      {
        global.helperClass.showAlertDialog(context, "", "File size should be less than 1MB", false, "");
      }
      else
      {
        isResponseReceived=false;
        setState(() {});

        String name = nameData;
        String phone = phoneIDData;
        String photo = imageSelected;
        String attributes = "{}";

        AddDriverClass addDriverClass = new AddDriverClass(name: name, phone: phone, photo: photo, attributes: attributes);
        var jsonBody = jsonEncode(addDriverClass);
        print(LOGTAG + " addDriver jsonbody->" + jsonBody.toString());

        Response response = await global.apiClass.AddDriver(jsonBody);
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
  }

  void updateDriver() async
  {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    nameValidate = false;
    phoneValidate = false;

    String nameData = nameController.text;
    String phoneData = phoneController.text;

    if (nameData.isEmpty || nameData == " " || nameData.length == 0 || nameData == "null")
    {
      nameValidate = true;
    }
    else
    {
      nameValidate = false;
    }

    if (phoneData.isEmpty || phoneData == " " || phoneData.length == 0 || phoneData == "null")
    {
      phoneValidate = true;
    }
    else
    {
      phoneValidate = false;
    }
    setState(() {});

    if (!nameValidate && !phoneValidate)
    {
      if(userSelectedImg!=null)
      {
        List<int> imageBytes = userSelectedImg.readAsBytesSync();
        imageSelected = base64Encode(imageBytes);
        print(LOGTAG+" image length->"+imageSelected.length.toString());
      }

      if(imageSelected.length>0 && imageSelected.length>102400)
      {
        global.helperClass.showAlertDialog(context, "", "File size should be less than 1MB", false, "");
      }
      else
      {
        isResponseReceived = false;
        setState(() {});

        String id = widget.driverObject.id;
        String name = nameData;
        String phone = phoneController.text;
        String photo = imageSelected;
        String attributes = "{}";

        UpdateDriverClass updateDriverClass = new UpdateDriverClass(id: id, name: name, phone: phone, photo: photo, attributes: attributes);
        var jsonBody = jsonEncode(updateDriverClass);
        print(LOGTAG + " updateDriver jsonbody->" + jsonBody.toString());

        Response response = await global.apiClass.UpdateDriver(jsonBody);
        if (response != null)
        {
          print(LOGTAG + " updateDriver statusCode->" + response.statusCode.toString());
          print(LOGTAG + " updateDriver body->" + response.body.toString());

          if (response.statusCode == 200)
          {
            var resBody = json.decode(response.body);
            global.lastFunction = "updateDriver";
            _onbackButtonPressed();
          }
          else if (response.statusCode == 400)
          {
            isResponseReceived = true;
            setState(() {});
            global.helperClass.showAlertDialog(context, "", "Driver Already Exist", false, "");
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
  }

  void GalleryImage() async
  {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((value) => {

      tempfile=value,
      userSelectedImg=value,
      setState((){}),

    }).catchError((onError){
      setState(() {});
    });

    print(LOGTAG+"selected gallery image:"+tempfile.toString());
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
        hintText: widget.driverObject==null?"Name":widget.driverObject.name.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.driverObject==null?"Name":widget.driverObject.name.toString(),
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
        hintText:  widget.driverObject==null?"Phone No":widget.driverObject.phone.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.driverObject==null?"Phone No":widget.driverObject.phone.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final attributeField = TextField(
      onTap: () {
        setState(() {atttrValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: attrController,
      decoration:!atttrValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.driverObject==null?"Attributes":widget.driverObject.attributes.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.driverObject==null?"Attributes":widget.driverObject.attributes.toString(),
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
                      child: widget.driverObject!=null?new Text("Edit Driver",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                      new Text("Add Driver",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                      widget.driverObject!=null?new Row(
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
                      widget.driverObject!=null?new Row(
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
                      widget.driverObject!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Attributes :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                                  child: attributeField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.driverObject!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Photo :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      ):new Container(width: 0,height: 0,),
                      SizedBox(height: 5,),
                      SizedBox(
                        height:150,
                        child:
                        new Row(
                          children: <Widget>[
                            Flexible(
                              flex:2,
                              fit: FlexFit.tight,
                              child:  new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child:  new Container(
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
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                                flex:2,
                                fit:FlexFit.tight,
                                child:new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Text('*File size must be less than 1MB', style: TextStyle(fontSize: global.font12, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                    SizedBox(height:10),
                                    new Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      height: 50,
                                      child: new RaisedButton(
                                          onPressed: () {
                                            GalleryImage();
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                          color: global.mainColor,
                                          child:new Text('Upload', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                                      ),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),


                      widget.driverObject!=null?new Row(
                        children: <Widget>[
                          Flexible(
                            flex:1,
                            fit: FlexFit.tight,
                            child: new Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: new RaisedButton(
                                  onPressed: () {
                                    updateDriver();
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                  color: Color(0xff2D9F4C),
                                  child:new Text('Update Driver', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                              addDriver();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            color: Color(0xff2D9F4C),
                            child:new Text('Add Driver', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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

