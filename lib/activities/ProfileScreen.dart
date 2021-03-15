import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helpers/AvatarList.dart';

class ProfileScreen extends StatefulWidget
{
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String LOGTAG = "ProfileScreen";


  @override
  void initState()
  {
    super.initState();

  }

  void changeUserAvatar() async{

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
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: new Column(
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
                                          new Text("Select Avatar", style: TextStyle(fontSize: global.font20,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishSemiBold')),
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
                                            onTap:(){
                                              Navigator.of(context).pop();
                                            },
                                            child:new Container(
                                              width:20,
                                              height:20,
                                              child: Image(image: AssetImage('assets/close-red-icon.png'),color: global.mainBlackColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height:10),
                                setupAlertDialoadContainer()
//                                new ListView.builder
//                                  (
//                                    shrinkWrap: true,
//                                    scrollDirection: Axis.vertical,
//                                    itemCount: global.AvatarMap.length,
//                                    itemBuilder: (BuildContext ctxt, int index) {
//
//                                      return Container(
//                                        child: AvatarList(index:index,onImageSelected: (selectedImage){
//
//                                          print(LOGTAG+" selectedImage->"+selectedImage.toString());
//                                          setAvatar(selectedImage);
//                                          Navigator.of(context).pop();
//
//                                        },),
//                                      );
//                                    }
//                                )
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

  Widget setupAlertDialoadContainer() {
    return Container(
        height: 300.0,
        width: MediaQuery.of(context).size.width, 
        child:  new ListView.builder
          (
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: 8,
            itemBuilder: (BuildContext ctxt, int index) {

              return Container(
                child: AvatarList(index:index,onImageSelected: (selectedImage){

                  print(LOGTAG+" selectedImage->"+selectedImage.toString());
                  setAvatar(selectedImage);
                  Navigator.of(context).pop();

                },),
              );
            }
        )
    );
  }

  void setAvatar(selectedAvatar) async
  {
    AvatarClass avatarClass = new AvatarClass(avatar:selectedAvatar );
    var jsonBody = jsonEncode(avatarClass);

    print(LOGTAG + " setAvatar jsonbody->" + jsonBody.toString());

    Response response = await global.apiClass.SetAvatar(jsonBody);
    if (response != null)
    {
      print(LOGTAG + " setAvatar statusCode->" + response.statusCode.toString());
      print(LOGTAG + " setAvatar body->" + response.body.toString());
      if (response.statusCode == 200)
      {
        global.myObject.avatar=selectedAvatar;
        setState(() {});
        global.helperClass.showAlertDialog(context, "", "Profile image updated successfully", false, "");

      }
      else if (response.statusCode == 400)
      {

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
                            child: new Text("Profile",style: TextStyle(fontSize: global.font18, color: global.mainBlackColor,fontWeight: FontWeight.w600,fontFamily: 'MulishRegular'))
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
                child:Container(
                    height: 150,
                    // margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child:new Column(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Flexible(
                                flex:2,
                                fit:FlexFit.tight,
                                child:GestureDetector(
                                  onTap: (){
                                    changeUserAvatar();
                                  },
                                  child: new Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      decoration:new BoxDecoration(
                                          color: global.whiteColor,
                                          border: Border.all(
                                            color: Color(0xffc4c4c4),
                                            width: 0.5,
                                          ),
                                          image:  DecorationImage(
                                            image: global.myObject==null?AssetImage("assets/Avatar/default-avatar.png"):(global.myObject.avatar.toString().toLowerCase().contains("default")?AssetImage("assets/Avatar/default-avatar.png"):AssetImage(global.AvatarMap[global.myObject.avatar])),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                                      ),
                                      child: new Container(
                                        width: MediaQuery.of(context).size.width,
                                        // child: global.myObject==null?Image.asset("assets/Avatar/default-avatar.png"):(global.myObject.avatar.toString().toLowerCase().contains("default")?Image.asset("assets/Avatar/default-avatar.png"):Image.asset(global.AvatarMap[global.myObject.avatar])),
                                      )
                                  ),
                                )
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
                                                  new Text(global.myObject.name.toString(), maxLines: 10,style: TextStyle(fontSize: global.font15, color: global.darkBlack,fontFamily: 'MulishRegular'))
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
                                                new Text(global.myObject.email.toString(),
                                                  maxLines: 10,
                                                  style: TextStyle(fontSize: global.font15, color: global.darkBlack,fontFamily: 'MulishRegular'),
                                                )
                                              ],
                                            )
                                        )
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
                                                  global.myObject.phone!=null?(global.myObject.phone.length!=0?new Text(global.myObject.phone.toString(), style: TextStyle(fontSize: global.font15, color: global.darkBlack,fontFamily: 'MulishRegular')):new Text("NA", maxLines: 10, style: TextStyle(fontSize: global.font15, color: global.darkBlack,fontFamily: 'MulishRegular'))):
                                                  new Text("NA", maxLines: 10, style: TextStyle(fontSize: global.font15, color: global.darkBlack,fontFamily: 'MulishRegular'))
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
                      ],
                    )

                )
            )
        )
    );
  }
}

