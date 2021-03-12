import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/activities/UserDetailsScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helperClass/UserObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfUsers.dart';


class UserScreen extends StatefulWidget
{
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
{
  String LOGTAG="UserScreen";

  List<DeviceObjectOwned> listofDevices=new List();
  List<UserObject> listOfUsers=new List();
  List<UserObject> currentListOfUsers=new List();
  ScrollController _scrollController=new ScrollController();
  bool isResponseReceived=false;
  bool isUserFound=false;

  @override
  void initState()
  {
    getOwnedDevices();
    getUsers();
    super.initState();
  }

  void getOwnedDevices() async
  {
    listofDevices.clear();
    global.listofOwnedDevices.clear();
    Response response=await global.apiClass.GetOwnedDevices();
    if(response!=null)
    {
      print(LOGTAG+" getOwnedDevices statusCode->"+response.statusCode.toString());
      print(LOGTAG+" getOwnedDevices->"+response.body.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        List<dynamic> payloadList=resBody;

        for (int i = 0; i < payloadList.length; i++)
        {
          String uniqueid= payloadList.elementAt(i)['uniqueid'];
          String name = payloadList.elementAt(i)['name'];
          String type = payloadList.elementAt(i)['type'];
          String phone = payloadList.elementAt(i)['phone'];
          String model = payloadList.elementAt(i)['model'];
          String contact = payloadList.elementAt(i)['contact'];
          var latlngStatic=payloadList.elementAt(i)['static'];
          LatLngClass static;
          if(latlngStatic!=null)
          {
            Map<String, dynamic> datamap = json.decode(latlngStatic);
            if (datamap.length > 0)
            {
              double lat = datamap['lat'];
              double lng = datamap['lng'];
              static = new LatLngClass(lat: lat, lng: lng);
            }
          }
          DeviceObjectOwned deviceObjectOwned=new DeviceObjectOwned(name: name,uniqueid: uniqueid,static: static,groupid: null,phone: phone.toString(),model: model.toString(),contact: contact.toString(),type: type);
          listofDevices.add(deviceObjectOwned);
          global.listofOwnedDevices.add(deviceObjectOwned);
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

  void getUsers() async
  {
    isResponseReceived=false;
    isUserFound=false;
    listOfUsers.clear();
    currentListOfUsers.clear();
    global.myUsers.clear();
    setState(() {});

    Response response=await global.apiClass.GetChildUsers();
    if(response!=null)
    {
      print(LOGTAG+" getChildUsers statusCode->"+response.statusCode.toString());
      print(LOGTAG+" getChildUsers->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);

        int resLength=resBody.toString().length;
        print(LOGTAG+" resLength->"+resLength.toString());

        if(resLength>30)
        {
          List<dynamic> payloadList = resBody;
          for (int i = 0; i < payloadList.length; i++)
          {
            int id = payloadList.elementAt(i)['id'];
            String email = payloadList.elementAt(i)['email'];
            String name = payloadList.elementAt(i)['name'];
            String password = payloadList.elementAt(i)['password'];
            String role = payloadList.elementAt(i)['role'];
            int disabledInt = payloadList.elementAt(i)['disabled'];
            String phone = payloadList.elementAt(i)['phone'];
            int twelvehourformatInt = payloadList.elementAt(i)['twelvehourformat'];
            String customMap = payloadList.elementAt(i)['custommap'];
            bool disabled = false;
            bool twelvehourformat = false;

            if (disabledInt == 1)
            {
              disabled = true;
            }

            if (twelvehourformatInt == 1)
            {
              twelvehourformat = true;
            }

            UserObject userObject = new UserObject(id: id, email: email, name: name, password: password, role: role, disabled: disabled, phone: phone, twelvehourformat: twelvehourformat, custommap: customMap, devices: "");
            listOfUsers.add(userObject);
            global.myUsers.putIfAbsent(email, () => userObject);
          }
          isResponseReceived = true;
          if (listOfUsers.length > 0)
          {
            isUserFound = true;
            currentListOfUsers.addAll(listOfUsers);
          }
          setState(() {});
        }
        else
        {
          String status=resBody['status'];
          if(status.toString().compareTo("Childs not found")==0)
          {
            isResponseReceived=true;
            isUserFound = false;
            setState(() {});
          }
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

  void onTabClicked(int index, UserObject userObject) async
  {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserDetailsScreen(index: index,userObject: userObject,listofDevices:listofDevices))).then((value) => ({

      if(global.lastFunction.toString().contains("addUser")){
        global.helperClass.showAlertDialog(context, "", "User added successfully", false, "")
      }
      else if(global.lastFunction.toString().contains("updateUser")){
        global.helperClass.showAlertDialog(context, "", "User updated successfully", false, "")
      },
      getUsers()
    }));
  }


  void deleteConfirmationPopup(UserObject userObject,int selindex)
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
                          new Text("Are you sure you want to delete the \'"+userObject.email.toString()+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xffdcdcdc), width: 1.0,),),
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
                                    deleteUser(userObject.email,selindex);
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

  void deleteUser(String useremail,int index) async
  {
    isResponseReceived=false;
    setState(() {});

    Response response=await global.apiClass.DeleteUser(useremail);
    if(response!=null)
    {
      print(LOGTAG+" deleteUser statusCode->"+response.statusCode.toString());
      print(LOGTAG+" delete user->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        //listOfUsers.removeAt(index);
        int finalIndex=0;
        for(int s=0;s<listOfUsers.length;s++)
        {
          UserObject gObj=listOfUsers.elementAt(s);
          if(gObj.email.compareTo(useremail)==0)
          {
            finalIndex=s;
          }
        }
        listOfUsers.removeAt(finalIndex);
        currentListOfUsers.removeAt(index);
        isResponseReceived=true;
        currentListOfUsers.addAll(listOfUsers);
        if(currentListOfUsers.length==0)
        {
          isUserFound=false;
        }
        setState(() {});
        global.helperClass.showAlertDialog(context, "", "User deleted successfully", false, "");
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



  Future<bool> _onbackButtonPressed()
  {
    Navigator.of(context).pop();
  }

  void sortList(String searchSTR) async
  {
    currentListOfUsers.clear();
    for(int k=0;k<listOfUsers.length;k++)
    {
      UserObject userObject=listOfUsers.elementAt(k);
      if(userObject.name.toString().toLowerCase().contains(searchSTR.toString().toLowerCase()))
      {
        currentListOfUsers.add(userObject);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: _onbackButtonPressed,
        child: Scaffold(
          body: isResponseReceived?(
              !isUserFound?new Container(
                  color: global.screenBackColor,
                  child:new Stack(
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
                            Flexible(
                                flex:1,
                                fit:FlexFit.tight,
                                child:new Container()
                            ),
                            Flexible(
                              flex:4,
                              fit:FlexFit.tight,
                              child:
                              new Column(
                                children: <Widget>[
                                  Flexible(
                                    flex:1,
                                    fit:FlexFit.tight,
                                    child:
                                    new Container(
                                        padding: EdgeInsets.all(10),
                                        child:new SvgPicture.asset('assets/no-user-found.svg')
                                    ),
                                  ),
                                  new Container(
                                    color: global.screenBackColor,
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: new Text('No User Added Yet', style: TextStyle(fontSize: global.font16, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                  ),
                                  new Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    width: MediaQuery.of(context).size.width/3,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [BoxShadow(
                                          color: Color(0xff121212).withOpacity(0.25),
                                          blurRadius: 32.0,
                                          offset: new Offset(8.0, 8.0),
                                        ),
                                        ]
                                    ),
                                    child: new RaisedButton(
                                        onPressed: () {
                                          onTabClicked(null,null);
                                        },
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                                        color: global.mainColor,
                                        child:new Text('Add User',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                                flex:1,
                                fit:FlexFit.tight,
                                child:new Container()
                            ),

//                            new Row(
//                              children: <Widget>[
//                                Flexible(
//                                    flex:1,
//                                    fit:FlexFit.tight,
//                                    child:new Container()
//                                ),
//                                Flexible(
//                                  flex:2,
//                                  fit:FlexFit.tight,
//                                  child:new Container(
//                                    padding: EdgeInsets.all(10),
//                                    child:new SvgPicture.asset('assets/no-user-found.svg'),
//                                  ),
//                                ),
//                                Flexible(
//                                    flex:1,
//                                    fit:FlexFit.tight,
//                                    child:new Container()
//                                )
//                              ],
//                            ),
//                            new Container(
//                              color: global.screenBackColor,
//                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                              child: new Text('No User Added Yet', style: TextStyle(fontSize: global.font16, color: Color(0xff30242A),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
//                            ),


                          ],
                        ),
                      ),
                    ],
                  )):new Container(
                  color: global.screenBackColor,
                  child:new Stack(
                    children: <Widget>[
                      new Container(
                        color: global.screenBackColor,
                        margin:EdgeInsets.fromLTRB(8,10,8,10),
                        child: CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: <Widget>[
                              SliverList(
                                  delegate: SliverChildListDelegate(
                                      [
                                        new Row(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 5,
                                              fit: FlexFit.tight,
                                              child: new Container(
                                                height:kToolbarHeight-10,
                                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: TextField(
                                                  textAlign: TextAlign.left,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.zero,
                                                    prefixIcon:  Icon(Icons.search,color: Color(0xff3C74DC)),
                                                    filled: true,
                                                    fillColor: Color(0xffF4F8FF),
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffE6EFFB),width: 2), borderRadius: BorderRadius.circular(8.0),),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffE6EFFB),width: 2), borderRadius: BorderRadius.circular(8.0),),
                                                    hintText: ' Search User By Name',
                                                    hintStyle: TextStyle(fontSize: global.font15,color:Color(0xff3C74DC),fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
                                                  ),
                                                  onChanged: (value) {
                                                    sortList(value);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                                flex: 1,
                                                fit: FlexFit.tight,
                                                child:GestureDetector(
                                                  onTap: (){
                                                    onTabClicked(null, null);
                                                  },
                                                  child: new Container(
                                                    height: kToolbarHeight-10,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: global.mainColor),
                                                    child:Icon(Icons.add,color: global.whiteColor,),
                                                  ),
                                                )
                                            )
                                          ],
                                        )

                                      ]
                                  )
                              ),
                              SliverList(
                                  delegate: SliverChildBuilderDelegate((context, index)
                                  {
                                    return Container(
                                      color: global.screenBackColor,
                                      child: ListOfUsers(index: index, userObject: currentListOfUsers[index],onTabCicked: (flag){
                                        if(flag.toString().compareTo("Edit")==0)
                                        {
                                          onTabClicked(index, currentListOfUsers[index]);
                                        }
                                        else if(flag.toString().compareTo("Delete")==0)
                                        {
                                          deleteConfirmationPopup(currentListOfUsers[index],index);
                                        }
                                      },
                                      ),
                                    );
                                  }, childCount: currentListOfUsers.length)
                              )
                            ]
                        ),
                      )
                    ],
                  ))
          ):new Container(
              color: global.screenBackColor,
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
