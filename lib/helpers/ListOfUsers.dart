import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/UserObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter_svg/flutter_svg.dart';



class ListOfUsers extends StatefulWidget
{
  ListOfUsers({Key key,this.index,this.userObject,this.onTabCicked}) : super(key: key);
  int index;
  ValueChanged<String> onTabCicked;
  UserObject userObject;

  @override
  _ListOfUsersState createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers>
{

  String LOGTAG="ListOfUsers";
  bool status = false;

  @override
  void initState(){
    super.initState();

    print(LOGTAG+" isUserDisabled->"+widget.userObject.disabled.toString());

    if(widget.userObject.disabled)
    {
      status=false;
    }
    else
    {
      status=true;
    }

    setState(() {});
  }

  void disableUser() async
  {
    String userid=widget.userObject.email.toString();

    UserIDClass userIDClass=new UserIDClass(userid: userid);
    var jsonBody=jsonEncode(userIDClass);
    print(LOGTAG+" disableUser jsonbody->"+jsonBody.toString());

    Response response=await global.apiClass.DisableUser(jsonBody);
    print(LOGTAG+" disableUser response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" disableUser statusCode->"+response.statusCode.toString());
      print(LOGTAG+" disableUser body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        global.helperClass.showAlertDialog(context, "", "User disabled successfully", false, "");
      }
      else  if (response.statusCode == 400)
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

  void enableUser() async
  {

    String userid=widget.userObject.email.toString();

    UserIDClass userIDClass=new UserIDClass(userid: userid);
    var jsonBody=jsonEncode(userIDClass);
    print(LOGTAG+" enableUser jsonbody->"+jsonBody.toString());

    Response response=await global.apiClass.EnableUser(jsonBody);
    print(LOGTAG+" enableUser response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" enableUser statusCode->"+response.statusCode.toString());
      print(LOGTAG+" enableUser body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        global.helperClass.showAlertDialog(context, "", "User enabled successfully", false, "");
      }
      else  if (response.statusCode == 400)
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
                              width: MediaQuery.of(context).size.width,
                              child: Image(image: AssetImage("assets/dummy-user-profile.png")),
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
                                              new Text(widget.userObject.name.toString(), maxLines: 10,style: TextStyle(fontSize: global.font16, color: global.darkBlack,fontFamily: 'MulishRegular'))
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
                                            new Text(widget.userObject.email.toString(),
                                              maxLines: 10,
                                              style: TextStyle(fontSize: global.font16, color: global.darkBlack,fontFamily: 'MulishRegular'),
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
                                              widget.userObject.phone!=null?new Text(widget.userObject.phone.toString(), style: TextStyle(fontSize: global.font16, color: global.darkBlack,fontFamily: 'MulishRegular')):
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
                                            margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            decoration: new BoxDecoration(
                                              color: global.transparent,
                                              border: Border.all(color: Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                    flex:1,
                                                    fit:FlexFit.tight,
                                                    child:new Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        new Text("Status", style: TextStyle(fontSize: global.font14, color: global.darkBlack,fontFamily: 'MulishRegular')),
                                                      ],
                                                    )
                                                ),
                                                Flexible(
                                                    flex:1,
                                                    fit:FlexFit.tight,
                                                    child: Switch(
                                                      onChanged: (val){
                                                        setState(() {
                                                          status = val;
                                                        });
                                                        if(val)
                                                        {
                                                          enableUser();
                                                        }
                                                        else
                                                        {
                                                          disableUser();
                                                        }
                                                      },
                                                      value: status,
                                                      activeColor: Color(0xff0E4DA4),
                                                      activeTrackColor: Color(0xff0E4DA4).withOpacity(0.24),
                                                      inactiveThumbColor: Color(0xff0E4DA4).withOpacity(0.3),
                                                      inactiveTrackColor:Color(0xff0E4DA4).withOpacity(0.24),
                                                    )
                                                )
                                              ],
                                            )
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