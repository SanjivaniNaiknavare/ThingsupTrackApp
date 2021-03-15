import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helperClass/SharedDeviceObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfSharedDevices.dart';

class UserSharedDevicesScreen extends StatefulWidget
{
  @override
  _UserSharedDevicesScreenState createState() => _UserSharedDevicesScreenState();
}

class _UserSharedDevicesScreenState extends State<UserSharedDevicesScreen>
{

  String LOGTAG = "UserSharedDevicesScreen";

  bool isResponseReceived = true;
  bool isAPICalled = false;
  bool isDeviceFound = false;
  bool sensorValidate = false;

  ScrollController _scrollController=new ScrollController();
  List<SharedDeviceObject> listOfDevices = new List();
  List<SharedDeviceObject> currentlistOfDevices = new List();


  @override
  void initState()
  {
    super.initState();


    getSharedDevices();

  }


  void getSharedDevices() async
  {
    isResponseReceived=false;
    isDeviceFound=false;
    listOfDevices.clear();
    currentlistOfDevices.clear();

    if(mounted) {
      setState(() {});
    }

    Response response=await global.apiClass.GetSharingDevices();
    print(LOGTAG+" getSharedDevices response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getSharedDevices statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG + " getSharedDevices->" + resBody.toString());

        int resLength=resBody.toString().length;
        if (resLength>40)
        {
          List<dynamic> payloadList = resBody;
          print(LOGTAG + " payloadList->" + payloadList.length.toString());

          for (int i = 0; i < payloadList.length; i++)
          {
            int id = payloadList.elementAt(i)['id'];
            int deviceid = payloadList.elementAt(i)['deviceid'];
            int userid = payloadList.elementAt(i)['userid'];
            String token = payloadList.elementAt(i)['token'];
            String name="";

            for(var key in global.myDevices.keys)
            {
              DeviceObjectAllAccount deviceObjectAllAccount=global.myDevices[key];
              print(LOGTAG+" name->"+deviceObjectAllAccount.name.toString()+" device id->"+deviceObjectAllAccount.deviceid.toString());
              if(deviceObjectAllAccount.deviceid!=null)
              {
                if (deviceObjectAllAccount.deviceid.compareTo(deviceid) == 0)
                {
                  name = deviceObjectAllAccount.name;
                }
              }
            }

            SharedDeviceObject sharedDeviceObject = new SharedDeviceObject(id: id, deviceid: deviceid, userid: userid, token: token,name: name);
            listOfDevices.add(sharedDeviceObject);
          }

          isResponseReceived = true;
          if (listOfDevices.length > 0)
          {
            currentlistOfDevices.addAll(listOfDevices);
            isDeviceFound = true;
          }
          if(mounted) {
            setState(() {});
          }
        }
        else
        {
          String status=resBody['status'];
          if(status.toString().contains("Devices not found"))
          {
            isResponseReceived = true;
            isDeviceFound = false;
            if (mounted) {
              setState(() {});
            }
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

  Future<bool> _onbackButtonPressed() {
    Navigator.of(context).pop();
  }

  void deleteSharing(int id,int listindex) async
  {

    isResponseReceived=false;
    if(mounted) {
      setState(() {});
    }

    Response response=await global.apiClass.DeleteSharingDevice(id.toString());
    if(response!=null)
    {
      print(LOGTAG+" deleteSharing statusCode->"+response.statusCode.toString());
      print(LOGTAG+" deleteSharing body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        isResponseReceived=true;
        listOfDevices.removeAt(listindex);
        if(mounted) {
          setState(() {});
        }
        global.helperClass.showAlertDialog(context, "", "Device sharing deleted successfully", false, "");
      }
      else if (response.statusCode == 400)
      {
        isResponseReceived=true;
        if(mounted) {
          setState(() {});
        }
        global.helperClass.showAlertDialog(context, "", "User Not Found", false, "");
      }
      else if (response.statusCode == 500)
      {
        isResponseReceived=true;
        if(mounted) {
          setState(() {});
        }
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      isResponseReceived=true;
      if(mounted) {
        setState(() {});
      }
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }
  }


  void deleteConfirmationPopup(SharedDeviceObject deviceObject,int index)
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
                          new Text("Are you sure you want to delete the \'"+"DeviceName"+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
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
                                    deleteSharing(deviceObject.id,index);
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


  void sortList(String searchSTR) async
  {
    currentlistOfDevices.clear();
    for(int k=0;k<listOfDevices.length;k++)
    {
      SharedDeviceObject sharedDeviceObject=listOfDevices.elementAt(k);
      if(sharedDeviceObject.name.toString().toLowerCase().contains(searchSTR.toString().toLowerCase()))
      {
        currentlistOfDevices.add(sharedDeviceObject);
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
              !isDeviceFound?new Container(
                  color:global.screenBackColor,
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
                                        child:new SvgPicture.asset('assets/no-device-found.svg')
                                    ),
                                  ),
                                  new Container(
                                    color: global.screenBackColor,
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: new Text('No Device Shared Yet', style: TextStyle(fontSize: global.font16, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                                flex:1,
                                fit:FlexFit.tight,
                                child:new Container()
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ):new Container(
                  color:global.screenBackColor,
                  child:new Stack(
                    children: <Widget>[
                      new Container(
                        color: global.screenBackColor,
                        margin:EdgeInsets.fromLTRB(8,10,8,10),
                        child: CustomScrollView(
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
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
                                                    hintText: ' Search Device By Name',
                                                    hintStyle: TextStyle(fontSize: global.font15,color:Color(0xff3C74DC),fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
                                                  ),
                                                  onChanged: (value) {
                                                    sortList(value);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )

                                      ]
                                  )
                              ),
                              SliverList(
                                  delegate: SliverChildBuilderDelegate((context, index)
                                  {
                                    return Container(
                                      color: global.transparent,
                                      child: ListOfSharedDevices(index: index, sharedDeviceObject: currentlistOfDevices[index],onTabClicked: (flag){
                                        deleteConfirmationPopup(currentlistOfDevices[index], index);
                                      },
                                      ),
                                    );
                                  }, childCount: currentlistOfDevices.length)
                              )
                            ]
                        ),
                      )
                      //showBottomFragment?showBottomSheet(deviceMAC,deviceIndex):new Container(width: 0,height: 0,)
                    ],
                  )
              )
          ):new Container(
              color:global.screenBackColor,
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