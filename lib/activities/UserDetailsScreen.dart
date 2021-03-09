import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/UserObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helpers/ShowDevicePopupForUser.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';

class UserDetailsScreen extends StatefulWidget
{
  UserDetailsScreen({Key key,this.index,this.userObject,this.listofDevices}) : super(key: key);
  int index;
  UserObject userObject;
  List<DeviceObjectOwned> listofDevices;

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
{
  String LOGTAG="UserDetailsScreen";

  bool isResponseReceived=true;
  String expectedRole="";
  bool nameValidate=false;
  bool useridValidate=false;
  bool passwordValidate=false;
  bool roleValidate=false;
  bool phoneValidate=false;
  bool deviceValidate=false;
  bool customMapValidate=false;
  String devicesValidate="";
  bool twelveHourFormat=false;

  final nameController = TextEditingController();
  final deviceController = TextEditingController();
  final useridController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();

  List<String> selectedlistofDevices=new List();

  @override
  void initState(){
    super.initState();
    global.lastFunction="";
    if(global.userRole.toString().compareTo("manager")==0)
    {
      expectedRole="user";
    }
    else if(global.userRole.toString().compareTo("admin")==0)
    {
      expectedRole="manager";
    }

    if(widget.userObject!=null)
    {
      nameController.text=widget.userObject.name;
      phoneController.text=widget.userObject.phone;
      twelveHourFormat=widget.userObject.twelvehourformat;
    }
    setState(() {});
  }


  void addUser() async
  {
    useridValidate=false;
    nameValidate=false;
    phoneValidate=false;
    passwordValidate=false;

    String useridData=useridController.text;
    String nameData=nameController.text;
    String phoneData=phoneController.text;
    String passwordData=passwordController.text;

    if(useridData.isEmpty || useridData==" " || useridData.length==0)
    {
      useridValidate=true;
    }
    else
    {
      bool verFlag=global.helperClass.isValidEmail(useridData);
      if(!verFlag)
      {
        useridValidate=true;
        global.helperClass.showAlertDialog(context, "", "Please enter valid email address", false, "");
      }
      else
      {
        useridValidate=false;
      }
    }

    if(nameData.isEmpty || nameData==" " || nameData.length==0)
    {
      nameValidate=true;
    }
    else
    {
      nameValidate=false;
    }

    if(passwordData.isEmpty || passwordData==" " || passwordData.length==0)
    {
      passwordValidate=true;
    }
    else
    {
      passwordValidate=false;
    }

    if(phoneData.isEmpty || phoneData==" " || phoneData.length==0)
    {
      phoneValidate=true;
    }
    else
    {
      if(phoneData.length==13 && phoneData.toString().contains("+"))
      {
        phoneValidate=false;
      }
      else
      {
        phoneValidate=true;
        global.helperClass.showAlertDialog(context, "", "Please enter valid phone number with country code", false, "");
      }
    }

    setState(() {});

    if(!nameValidate && !phoneValidate && !useridValidate && !passwordValidate)
    {

      String userid=useridData;
      String name=nameData;
      String password=passwordData;
      String role=expectedRole;
      bool disabled=false;
      String phone=phoneData;
      bool twelvehourformat=twelveHourFormat;
      String custommap="";
      String devices="";

      for(int s=0;s<selectedlistofDevices.length;s++)
      {
        devices=devices+selectedlistofDevices.elementAt(s).toString()+",";
      }
      if(devices.length>0)
      {
        devices=devices.substring(0,devices.length-1);
      }

      AddUserClass addUserClass=new AddUserClass(userid: userid,name: name,password: password,role: role,disabled: disabled,phone: phone,twelvehourformat: twelvehourformat,custommap: custommap,devices: devices);
      var jsonBody=jsonEncode(addUserClass);
      print(LOGTAG+" addUser jsonbody->"+jsonBody.toString());

      isResponseReceived=false;
      setState(() {});

      Response response=await global.apiClass.AddUser(jsonBody);

      if(response!=null)
      {
        print(LOGTAG+" adduser statusCode->"+response.statusCode.toString());
        print(LOGTAG+" adduser body->"+response.body.toString());

        if (response.statusCode == 200)
        {
          var resBody = json.decode(response.body);
          print(LOGTAG+" adduser->"+resBody.toString());
          global.lastFunction="addUser";
          _onbackButtonPressed();

        }
        else if (response.statusCode == 400)
        {
          isResponseReceived=true;
          setState(() {});

          var resBody = json.decode(response.body);
          String status=resBody['status'];
          if(status.toString().contains("User Already Exist"))
          {
            global.helperClass.showAlertDialog(context, "", "User Already Exist", false, "");
          }
          else if(status.toString().contains("User with Phone number Already Exist"))
          {
            global.helperClass.showAlertDialog(context, "", "User with given Phone number Already Exist", false, "");
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

  }

  void updateUser() async
  {
    nameValidate=false;
    phoneValidate=false;

    String nameData=nameController.text;
    String phoneData=phoneController.text;

    if(nameData.isEmpty || nameData==" " || nameData.length==0 || nameData=="null")
    {
      nameValidate=true;
    }
    else
    {
      nameValidate=false;
    }

    if(phoneData.isEmpty || phoneData==" " || phoneData.length==0 || phoneData=="null")
    {
      phoneValidate=true;
    }
    else
    {
      if(phoneData.length==13 && phoneData.toString().contains("+"))
      {
        phoneValidate=false;
      }
      else{
        phoneValidate=true;
        global.helperClass.showAlertDialog(context, "", "Please enter valid phone number with country code", false, "");
      }
    }

    setState(() {});

    if(!nameValidate && !phoneValidate)
    {

      String userid=widget.userObject.email.toString();
      String name=nameData;
      String phone=phoneData;
      bool twelvehourformat=twelveHourFormat;
      String custommap=widget.userObject.custommap.toString();

      UpdateUserClass updateUserClass=new UpdateUserClass(userid: userid,name: name,phone: phone,twelvehourformat: twelvehourformat,custommap: custommap);
      var jsonBody=jsonEncode(updateUserClass);
      print(LOGTAG+" updateUser jsonbody->"+jsonBody.toString());

      isResponseReceived=false;
      setState(() {});

      Response response=await global.apiClass.UpdateUser(jsonBody);
      if(response!=null)
      {
        print(LOGTAG+" updateUser statusCode->"+response.statusCode.toString());

        if (response.statusCode == 200)
        {
          var resBody = json.decode(response.body);
          global.lastFunction="updateUser";
          _onbackButtonPressed();
          print(LOGTAG+" adduser->"+resBody.toString());
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

  }



  Future<bool> _onbackButtonPressed()
  {
    Navigator.of(context).pop();
  }

  void showDropDownDiailogForDevice()
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
                  padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                  child:SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ShowDevicePopupForUser(
                        deviceList: widget.listofDevices,
                        selectedDeviceList:selectedlistofDevices,
                        selectedDevices: (value){

                          selectedlistofDevices.clear();
                          selectedlistofDevices.addAll(value);
                          print(value);
                          String _selectedDevice="";
                          int cur_length=selectedlistofDevices.length;
                          if(cur_length>0)
                          {
                            if(cur_length==1)
                            {
                              _selectedDevice=selectedlistofDevices.elementAt(0);
                            }
                            else
                            {
                              _selectedDevice=selectedlistofDevices.elementAt(0)+" and others";
                            }
                          }
                          else
                          {
                            _selectedDevice="";
                          }
                          deviceController.text=_selectedDevice;
                          Navigator.of(context).pop();
                        },
                      )
                  )
              ),
            ),
          );
        });
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
        fillColor: Color(0xffEFF0F6),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.userObject==null?"Name":widget.userObject.name.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.userObject==null?"Name":widget.userObject.name.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );


    final useridField = TextField(
      onTap: () {
        setState(() {useridValidate = false;});
      },
      enabled: widget.userObject==null?true:false,
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: useridController,
      decoration:!useridValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffEFF0F6),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.userObject==null?"User ID":widget.userObject.email.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.userObject==null?"User ID":widget.userObject.email.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final passwordField = TextField(
      onTap: () {
        setState(() {passwordValidate = false;});
      },
      enabled:widget.userObject!=null?false:true,
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: passwordController,
      decoration:!passwordValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffEFF0F6),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  "Password",
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final roleField = TextField(
        enabled: false,
        textInputAction: TextInputAction.done,
        style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
        cursorColor: global.mainColor,
        obscureText: false,
        controller: roleController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffEFF0F6),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText:  expectedRole,
          hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
        )
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
        fillColor: Color(0xffEFF0F6),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.userObject==null?"Phone No(+919988776655)":widget.userObject.phone.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.userObject==null?"Phone No(+919988776655)":widget.userObject.phone.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final customMapField = TextField(
      onTap: () {
        setState(() {customMapValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      decoration:!customMapValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffEFF0F6),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.userObject==null || widget.userObject.custommap.length==0?"CustomMap":widget.userObject.custommap.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.userObject==null || widget.userObject.custommap.length==0?"CustomMap":widget.userObject.custommap.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    final deviceField = TextField(
      onTap: () {
        showDropDownDiailogForDevice();
        setState(() { deviceValidate = false; });
      },
      enabled: widget.userObject==null?true:false,
      style:TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      controller: deviceController,
      readOnly: true,
      decoration:!deviceValidate?InputDecoration(
        suffixIcon:IconButton(
          icon: Icon(
            Icons.arrow_drop_down,
            color: global.darkGreyColor.withOpacity(0.9),
          ),
        ),
        filled: true,
        fillColor: Color(0xffEFF0F6),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Devices",
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Devices",
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
                      padding:  EdgeInsets.fromLTRB(15,0,0,0),
                      child:  GestureDetector(
                          onTap: (){_onbackButtonPressed();},
                          child: new Container(
                            height: 25,
                            child:Image(image: AssetImage('assets/back-arrow.png')),
                          )
                      )
                  ),
                  Container(
                      padding:  EdgeInsets.fromLTRB(15,0,0,0),
                      child:  new Text("User Details",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                  ),
                ],
              ),
              backgroundColor:global.screenBackColor,
            ),
            body:Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:isResponseReceived?SingleChildScrollView(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.userObject!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("User ID :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                                  child: useridField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.userObject!=null?new Row(
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
                      widget.userObject!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Password :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                                  child: passwordField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.userObject!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Role :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                                  child: roleField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.userObject!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Phone :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                      widget.userObject!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("CustomMap :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                                  child: customMapField,
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      widget.userObject!=null?new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child:new Text("Devices :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                                child: deviceField,
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
                                        new Text("TwelveHourFormat :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                        Checkbox(
                                          onChanged: (bool flag) {
                                            twelveHourFormat=flag;
                                            setState(() {});
                                          },
                                          value: twelveHourFormat,
                                        ),
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      widget.userObject!=null?new Row(
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
                                    updateUser();
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                  color: Color(0xff2D9F4C),
                                  child:new Text('Update User', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                              addUser();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            color: Color(0xff2D9F4C),
                            child:new Text('Add User', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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