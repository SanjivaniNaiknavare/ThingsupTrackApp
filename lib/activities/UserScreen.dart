import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/activities/GeofenceDetailsScreen.dart';
import 'package:thingsuptrackapp/activities/UserDetailsScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/UserObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfGeofences.dart';
import 'package:thingsuptrackapp/helpers/ListOfUsers.dart';


class UserScreen extends StatefulWidget
{
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
{
  String LOGTAG="UserScreen";

  List<UserObject> listOfUsers=new List();
  ScrollController _scrollController=new ScrollController();
  bool isResponseReceived=false;
  bool isUserFound=false;

  @override
  void initState()
  {
    getUsers();
    super.initState();


  }

  void getUsers() async
  {

    isResponseReceived=false;
    isUserFound=false;
    listOfUsers.clear();
    setState(() {});


    Response response=await global.apiClass.GetChildUsers();
    print(LOGTAG+" getChildUsers response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getChildUsers statusCode->"+response.statusCode.toString());
      print(LOGTAG+" getChildUsers->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);

        List<dynamic> payloadList=resBody;

        for (int i = 0; i < payloadList.length; i++)
        {
          int id= payloadList.elementAt(i)['id'];
          String email= payloadList.elementAt(i)['email'];
          String name = payloadList.elementAt(i)['name'];
          String password = payloadList.elementAt(i)['password'];
          String role = payloadList.elementAt(i)['role'];
          int disabledInt = payloadList.elementAt(i)['disabled'];
          String phone = payloadList.elementAt(i)['phone'];
          int twelvehourformatInt= payloadList.elementAt(i)['twelvehourformat'];
          String customMap=payloadList.elementAt(i)['custommap'];
          bool disabled=false;
          bool twelvehourformat=false;

          if(disabledInt==1)
          {
            disabled=true;
          }

          if(twelvehourformatInt==1)
          {
            twelvehourformat=true;
          }



          UserObject userObject=new UserObject(id: id,email: email,name: name,password: password,role: role,disabled: disabled,phone: phone,twelvehourformat: twelvehourformat,custommap: customMap,devices: "");
          listOfUsers.add(userObject);

        }

        isResponseReceived=true;
        if(listOfUsers.length>0)
        {
          isUserFound=true;
        }
        setState(() {});

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

  void onTabClicked(int index, UserObject userObject) async
  {

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserDetailsScreen(index: index,userObject: userObject,))).then((value) => ({

      if(global.lastFunction.toString().contains("addUser"))
        {
          global.helperClass.showAlertDialog(context, "", "User added successfully", false, "")
        }
      else if(global.lastFunction.toString().contains("updateUser")){
        global.helperClass.showAlertDialog(context, "", "User updated successfully", false, "")
      }
      else if(global.lastFunction.toString().contains("deleteUser")){
          global.helperClass.showAlertDialog(context, "", "User deleted successfully", false, "")
        },
      getUsers()
    }));
  }


  Future<bool> _onbackButtonPressed()
  {
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {

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
                    child:  new Text("User Management",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                ),
              ],
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: (){
                  onTabClicked(null,null);
                },
                child: new Container(
                  width: 50,
                  child: Icon(Icons.add,color: global.appbarTextColor,),
                ),
              )
            ],
            backgroundColor:global.screenBackColor,
          ),
          body: isResponseReceived?(
              !isUserFound?new Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  new Container(
                    color: global.screenBackColor,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                    width: MediaQuery.of(context).size.width,
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            Flexible(
                                flex:1,
                                fit:FlexFit.tight,
                                child:new Container()
                            ),
                            Flexible(
                              flex:2,
                              fit:FlexFit.tight,
                              child:new Container(
                                padding: EdgeInsets.all(10),
                                // child:Image(image: AssetImage('assets/no-device-found.png')),
                              ),
                            ),
                            Flexible(
                                flex:1,
                                fit:FlexFit.tight,
                                child:new Container()
                            )
                          ],
                        ),
                        new Container(
                          color: global.screenBackColor,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: new Text('No Geofence Found', style: TextStyle(fontSize: global.font16, color: Color(0xff30242A),fontWeight: FontWeight.normal,fontFamily: 'PoppinsRegular')),
                        )
                      ],
                    ),
                  ),
                ],
              ):new Stack(
                children: <Widget>[
                  new Container(
                    color: global.screenBackColor,
                    margin:EdgeInsets.fromLTRB(8,10,8,10),
                    child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: <Widget>[
                          SliverList(
                              delegate: SliverChildBuilderDelegate((context, index)
                              {
                                return Container(
                                  color: global.transparent,
                                  child: ListOfUsers(index: index, userObject: listOfUsers[index],onTabCicked: (flag){

                                    onTabClicked(index,listOfUsers[index]);

                                  },
                                  ),
                                );
                              }, childCount: listOfUsers.length)
                          )
                        ]
                    ),
                  )
                  //showBottomFragment?showBottomSheet(deviceMAC,deviceIndex):new Container(width: 0,height: 0,)
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
    );
  }
}
