import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/UserObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class ListOfUsers extends StatefulWidget
{
  ListOfUsers({Key key,this.index,this.userObject,this.onTabCicked}) : super(key: key);
  int index;
  ValueChanged<bool> onTabCicked;
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
        child:GestureDetector(
            onTap: (){
              widget.onTabCicked(true);
            },
            child:new Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                child:Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    height: 76,
                    decoration: new BoxDecoration(
                      color: global.screenBackColor,
                      boxShadow: [BoxShadow(color: Color.fromRGBO(18,18,18,0.1), blurRadius: 22.0, offset: Offset(0,8),),],
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child:new Row(
                      children: <Widget>[

                        Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(widget.userObject.name.toString(), style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                new Text(widget.userObject.email.toString(), style: new TextStyle(fontSize: global.font14, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                new Text("Role: "+widget.userObject.role.toString(), style: new TextStyle(fontSize: global.font14, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),

                              ],
                            )
                        ),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  flex:2,
                                  fit: FlexFit.tight,
                                  child: new Text("Disable User",style: TextStyle(fontSize: global.font14, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'),),
                                ),
                                Flexible(
                                  flex:1,
                                  fit:FlexFit.tight,
                                  child: FlutterSwitch(
                                    value: status,
                                    onToggle: (val) {
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
                                  ),
                                )
                              ],
                            )
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(Icons.chevron_right,color: Color(0xffD3616A),),
                        )
                      ],
                    )
                )
            )
        )
    );
  }
}