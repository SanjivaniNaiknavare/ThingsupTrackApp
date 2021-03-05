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

class UserDetailsScreen extends StatefulWidget
{
  UserDetailsScreen({Key key,this.index,this.userObject}) : super(key: key);
  int index;
  UserObject userObject;


  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
{
  String LOGTAG="UserDetailsScreen";

  String currentRole="user";
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


  @override
  void initState(){
    super.initState();

    global.lastFunction="";
    if(widget.userObject!=null)
    {
      nameController.text=widget.userObject.name;
      phoneController.text=widget.userObject.phone;
      twelveHourFormat=widget.userObject.twelvehourformat;
    }
  }


  void deleteUser(String userindex) async
  {
    Response response=await global.apiClass.DeleteUser(userindex);

    print(LOGTAG+" deleteUser response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" deleteUser statusCode->"+response.statusCode.toString());
      print(LOGTAG+" delete user->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        global.lastFunction="deleteUser";
        _onbackButtonPressed();
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "User Not Found", false, "");
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
      useridValidate=false;
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
      else{
        phoneValidate=true;
      }
    }

    setState(() {});

    if(!nameValidate && !phoneValidate && !useridValidate && !passwordValidate)
    {

      String userid=useridData;
      String name=nameData;
      String password=passwordData;
      String role=currentRole;
      bool disabled=false;
      String phone=phoneData;
      bool twelvehourformat=twelveHourFormat;
      String custommap="";
      String devices="";

      AddUserClass addUserClass=new AddUserClass(userid: userid,name: name,password: password,role: role,disabled: disabled,phone: phone,twelvehourformat: twelvehourformat,custommap: custommap,devices: devices);
      var jsonBody=jsonEncode(addUserClass);
      print(LOGTAG+" addUser jsonbody->"+jsonBody.toString());

      Response response=await global.apiClass.AddUser(jsonBody);

      print(LOGTAG+" adduser response->"+response.toString());

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
          global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
        }
      }
      else
      {
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

    if(nameData.isEmpty || nameData==" " || nameData.length==0)
    {
      nameValidate=true;
    }
    else
    {
      nameValidate=false;
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
      else{
        phoneValidate=true;
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

      Response response=await global.apiClass.UpdateUser(jsonBody);
      print(LOGTAG+" updateUser response->"+response.toString());

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
          global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
        }
      }
      else
      {
        global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
      }
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
                          new Text("Are you sure you want to delete the \'"+widget.userObject.name.toString()+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xffdcdcdc), width: 1.0,),
                        ),
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
                                    deleteUser(selindex);
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
                  padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                  child:SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child:new Text("Hi")
//                      ShowAlarmDevicePopup(
//                        deviceList: listofDevices,
//                        currentDeviceList: currentofDevices,
//                        selectedDevices: (value){
//
//                          currentofDevices.clear();
//                          currentofDevices.addAll(value);
//                          int cur_length=currentofDevices.length;
//                          if(cur_length>0)
//                          {
//                            if(cur_length==1)
//                            {
//                              _selectedDevice=currentofDevices.elementAt(0);
//                            }
//                            else
//                            {
//                              _selectedDevice=currentofDevices.elementAt(0)+" and others";
//                            }
//                          }
//                          else
//                          {
//                            _selectedDevice="";
//                          }
//
//                          deviceController.text=_selectedDevice;
//                          Navigator.of(context).pop();
//                        },
//                      )
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
        hintText:  widget.userObject==null?"Password":widget.userObject.password.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.userObject==null?"Password":widget.userObject.password.toString(),
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
          hintText:  "user",
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
      controller: phoneController,
      decoration:!phoneValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffEFF0F6),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:  widget.userObject==null?"Phone":widget.userObject.phone.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.userObject==null?"Phone":widget.userObject.phone.toString(),
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
        hintText: "Select Device",
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEFF0F6),), borderRadius: BorderRadius.circular(10.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEFF0F6)), borderRadius: BorderRadius.circular(10.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Select Device",
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
                child:SingleChildScrollView(

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
                              fit:FlexFit.tight,
                              child:   new Container(
                                padding: EdgeInsets.fromLTRB(0,0,5,0),
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: new Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: new RaisedButton(
                                      onPressed: () {
                                        deleteConfirmationPopup(widget.userObject.email);
                                      },
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),side: BorderSide(color: Color(0xffF7716E))),
                                      color: global.whiteColor,
                                      child:new Text('Delete User', style: TextStyle(fontSize: global.font14, color: Color(0xffF7716E),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                )
            )
        )
    );
  }
}