import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfDevices.dart';
import 'package:thingsuptrackapp/helpers/TagDevicePopup.dart';

class UserDevicesScreen extends StatefulWidget
{
  @override
  _UserDevicesScreenState createState() => _UserDevicesScreenState();
}

class _UserDevicesScreenState extends State<UserDevicesScreen>
{
  String LOGTAG="UserDevicesScreen";
  bool isResponseReceived=true;
  bool isAPICalled=false;
  bool isDeviceFound=false;
  bool sensorValidate=false;
  String _selectedUser;
  String lastSelectedUser="";
  ScrollController _scrollController=new ScrollController();
  List<String> listOfUsers=new List();
  List<DeviceObjectAllAccount> listOfDevices=new List();


  @override
  void initState()
  {
    super.initState();

    listOfUsers.add("sanju@gmail.com");
    listOfUsers.add("sanju10@gmail.com");
    listOfUsers.add("sanju11@gmail.com");

  }

  Future<bool> _onbackButtonPressed()
  {
    Navigator.of(context).pop();
  }

  void searchDevice() async
  {

    lastSelectedUser=_selectedUser;
    listOfDevices.clear();

    if(_selectedUser==null)
    {
      global.helperClass.showAlertDialog(context, "", "Please select user", false, "");
    }
    else if(_selectedUser.isEmpty || _selectedUser == " " || _selectedUser.length == 0)
    {
      global.helperClass.showAlertDialog(context, "", "Please select user", false, "");
    }
    else
    {
      isResponseReceived=false;
      isDeviceFound=false;
      setState(() {});

      Response response=await global.apiClass.GetTaggedDevices(_selectedUser);
      if(response!=null)
      {
        print(LOGTAG+" getTaggedDevices statusCode->"+response.statusCode.toString());
        print(LOGTAG+" getTaggedDevices body->"+response.body.toString());
        if (response.statusCode == 200)
        {
          var resBody = json.decode(response.body);
          if(resBody.toString().contains("Devices not found"))
          {
            isResponseReceived=true;
            setState(() {});
            global.helperClass.showAlertDialog(context, "", "Device not found", false, "");
          }
          else
          {
            List<dynamic> payloadList=resBody;
            print(LOGTAG+" payloadList->"+payloadList.length.toString());

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
                if (datamap.length > 0) {
                  double lat = datamap['lat'];
                  double lng = datamap['lng'];
                  static = new LatLngClass(lat: lat, lng: lng);
                }
              }

              DeviceObjectAllAccount deviceObjectAllAccount=new DeviceObjectAllAccount(name: name,uniqueid: uniqueid,static: static,groupid: null,phone: phone.toString(),model: model.toString(),contact: contact.toString(),type: type);
              listOfDevices.add(deviceObjectAllAccount);
            }

            isResponseReceived=true;
            if(listOfDevices.length>0)
            {
              isDeviceFound=true;
            }

            setState(() {});

          }
        }
        else if (response.statusCode == 400)
        {
          isResponseReceived=true;
          setState(() {});
          global.helperClass.showAlertDialog(context, "", "User is not Child/Access Denied", false, "");
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
        global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
      }

    }
  }

  void unTagDevice(String deviceUniqueID,int index) async
  {
    String uniqueid=deviceUniqueID;
    String taguserid=lastSelectedUser;

    Response response=await global.apiClass.UntagUserFromDevice(uniqueid,taguserid);
    print(LOGTAG+" untagUserFromDevice response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" untagUserFromDevice statusCode->"+response.statusCode.toString());
      print(LOGTAG+" untagUserFromDevice body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        listOfDevices.removeAt(index);
        setState(() {});
        print(LOGTAG+" untagUserFromDevice->"+resBody.toString());
      }
      else if (response.statusCode == 400)
      {
        global.helperClass.showAlertDialog(context, "", "User is not Child/Access Denied", false, "");
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

  void deleteConfirmationPopup(String devUniqueID,DeviceObjectAllAccount deviceObject,int index)
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
                          new Text("Are you sure you want to untag the \'"+deviceObject.name.toString()+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
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
                                    unTagDevice(devUniqueID,index);
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

  void showTagDevicePopup() async
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
                                          new Text("Tag Devices", style: TextStyle(fontSize: global.font20,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishSemiBold')),
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
                                              child: Image(image: AssetImage('assets/close-red-icon.png')),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height:10),
                                TagDevicePopup(deviceList: listOfDevices,selecteduserID: lastSelectedUser,),
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

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: _onbackButtonPressed,
        child: Scaffold(
//            appBar:AppBar(
//              titleSpacing: 0.0,
//              elevation: 5,
//              automaticallyImplyLeading: false,
//              title: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  Container(
//                      padding:  EdgeInsets.fromLTRB(15,0,0,0),
//                      child:  GestureDetector(
//                          onTap: (){_onbackButtonPressed();},
//                          child: new Container(
//                            height: 25,
//                            child:Image(image: AssetImage('assets/back-arrow.png')),
//                          )
//                      )
//                  ),
//                  Container(
//                      padding:  EdgeInsets.fromLTRB(15,0,0,0),
//                      child:  new Text("UserDevices",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
//                  ),
//                ],
//              ),
//              backgroundColor:global.screenBackColor,
//            ),
            body:new Container(
                child:  new Container(
                  color: global.screenBackColor,
                  margin:EdgeInsets.fromLTRB(8,10,8,10),
                  child: CustomScrollView(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child:new Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex:3,
                                        fit: FlexFit.tight,
                                        child: Container(
                                            height: 50,
                                            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                                            decoration: !sensorValidate?BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Color(0xffEFF0F6), border: Border.all(color:Color(0xffEFF0F6),)):BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: global.errorTextFieldFillColor, border: Border.all(color:Color(0xffEFF0F6),)),
                                            child: new DropdownButtonHideUnderline(
                                                child: new DropdownButton<String>(
                                                  hint: Text('Select User',style: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular')),
                                                  isExpanded: true,
                                                  onTap: () {
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  value: _selectedUser,
                                                  items: listOfUsers.map((String value) {
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
                                                    sensorValidate=false;
                                                    setState(() {_selectedUser=newval;});
                                                  },
                                                )
                                            )
                                        ),
                                      ),
                                      Flexible(
                                        flex:1,
                                        fit: FlexFit.tight,
                                        child:  GestureDetector(
                                            onTap: searchDevice,
                                            child:Container(
                                                height: 50,
                                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                decoration: BoxDecoration(color: Color(0xff0176fe), border: Border.all(color: Color(0xff0176fe), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                                                child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.search,color: global.whiteColor,)

                                                    ]
                                                )
                                            )
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        isResponseReceived && isDeviceFound?SliverList(
                            delegate:SliverChildListDelegate(
                                [
                                  new Container(
                                      height: 50,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: global.mainColor,
                                          border: Border.all(color: global.mainColor, width: 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        ),
                                        padding: EdgeInsets.fromLTRB(0,2,0,2),
                                        child: FlatButton(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          child: Text('Tag Device',style: TextStyle(fontSize: global.font15,fontStyle: FontStyle.normal,fontFamily: 'MulishBold'),),
                                          textColor: global.whiteColor,
                                          onPressed: () {
                                            showTagDevicePopup();
                                          },
                                        ),
                                      )
                                  )
                                ]
                            ) ):SliverList(
                            delegate:SliverChildListDelegate(
                                [
                                  new Container(width: 0,height: 0,)
                                ]
                            )),

                        isResponseReceived?(isDeviceFound?SliverList(
                            delegate: SliverChildBuilderDelegate((context, index)
                            {
                              return Container(
                                color: global.transparent,
                                child: ListOfDevices(index: index, deviceObject: listOfDevices[index],onTabClicked: (flag){

                                  deleteConfirmationPopup(listOfDevices[index].uniqueid,listOfDevices[index],index);

                                },
                                ),
                              );
                            }, childCount: listOfDevices.length)):SliverList(
                            delegate: SliverChildListDelegate(
                                [
                                  isAPICalled?new Container(
                                      height: MediaQuery.of(context).size.height,
                                      child: new Text("No device found",style: TextStyle(fontSize: global.font16, color: Color(0xff30242A),fontWeight: FontWeight.normal,fontFamily: 'PoppinsRegular'),)):new Container(width: 0,height: 0,)
                                ]
                            )
                        )
                        ): SliverList(
                          delegate: SliverChildListDelegate(
                              [
                                new Container(
                                    padding: EdgeInsets.fromLTRB(0, (MediaQuery.of(context).size.height/4)+20, 0, 0),
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
                              ]
                          ),
                        )
                      ]
                  ),
                )
            )
        )
    );
  }
}