import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'package:thingsuptrackapp/activities/TaggedDriverDetailsScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helperClass/DriverObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfDrivers.dart';
import 'package:thingsuptrackapp/helpers/ListOfTaggedDrivers.dart';



class DriverTaggingScreen extends StatefulWidget
{
  @override
  _DriverTaggingScreenState createState() => _DriverTaggingScreenState();
}

class _DriverTaggingScreenState extends State<DriverTaggingScreen>
{
  String LOGTAG="DriverTaggingScreen";

  List<DeviceObjectOwned> listofDevices=new List();
  List<DriverObject> listOfDrivers=new List();
  List<TaggedDriverObject> listOfTaggedDrivers=new List();
  ScrollController _scrollController=new ScrollController();
  bool isResponseReceived=false;
  bool isTaggedDriverFound=false;

  @override
  void initState()
  {
    getTaggedDrivers();
    getDrivers();
    super.initState();
  }

  void getDrivers() async
  {

    global.myDrivers.clear();


    Response response=await global.apiClass.GetDrivers();
    if(response!=null)
    {
      print(LOGTAG+" getDrivers statusCode->"+response.statusCode.toString());
      print(LOGTAG+" getDrivers->"+response.body.toString());

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
            int driverid = payloadList.elementAt(i)['driverid'];
            String name = payloadList.elementAt(i)['name'];
            String phone = payloadList.elementAt(i)['phone'];
            String photo = payloadList.elementAt(i)['photo'];
            String attributes = payloadList.elementAt(i)['attributes'];
            DriverObject driverObject = new DriverObject(id: id.toString(), driverid: driverid.toString(), name: name, phone: phone, photo: photo, attributes: attributes);
            global.myDrivers.putIfAbsent(id.toString(), () => driverObject);
          }
        }
      }
    }
  }

  void getTaggedDrivers() async
  {
    isResponseReceived=false;
    isTaggedDriverFound=false;
    listOfDrivers.clear();
    global.myUsers.clear();
    if(mounted){
      setState(() {});
    }

    Response response=await global.apiClass.GetTaggedDrivers();
    if(response!=null)
    {
      print(LOGTAG+" getTaggedDrivers statusCode->"+response.statusCode.toString());
      print(LOGTAG+" getTaggedDrivers->"+response.body.toString());

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
            String uniqueid = payloadList.elementAt(i)['uniqueid'];
            String name = payloadList.elementAt(i)['name'];

            TaggedDriverObject taggedDriverObject = new TaggedDriverObject(id: id.toString(), uniqueid: uniqueid, name: name);
            listOfTaggedDrivers.add(taggedDriverObject);
          }
          isResponseReceived = true;
          if (listOfTaggedDrivers.length > 0) {
            isTaggedDriverFound = true;
          }
          if(mounted){
            setState(() {});
          }

        }
        else
        {
          String status=resBody['status'];
          if(status.toString().compareTo("Drivers not found")==0)
          {
            isResponseReceived=true;
            isTaggedDriverFound = false;
            if(mounted){
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

  void onTabClicked(int index, TaggedDriverObject driverObject) async
  {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TaggedDriverDetailsScreen(index: index,driverObject: driverObject))).then((value) => ({

      if(global.lastFunction.toString().contains("tagDriver")){
        global.helperClass.showAlertDialog(context, "", "Driver tagged to device successfully", false, "")
      }
      else if(global.lastFunction.toString().contains("untagDriver")){
        global.helperClass.showAlertDialog(context, "", "Driver untagged from device successfully", false, "")
      },
      getTaggedDrivers()
    }));
  }


  void deleteConfirmationPopup(TaggedDriverObject driverObject,int selindex)
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
                          new Text("Are you sure you want to untag \'"+driverObject.name.toString()+"\' from \'"+driverObject.uniqueid.toString()+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
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
                                    untagDriver(driverObject,selindex);
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

  void untagDriver(TaggedDriverObject deviceObject,int index) async
  {
    isResponseReceived=false;
    if(mounted){
      setState(() {});
    }

    String id=deviceObject.id;
    String uniqueid=deviceObject.uniqueid;

    Response response=await global.apiClass.UntagDriverFromDevice(id,uniqueid);
    if(response!=null)
    {
      print(LOGTAG+" untagDriver statusCode->"+response.statusCode.toString());
      print(LOGTAG+" untagDriver body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        listOfTaggedDrivers.removeAt(index);
        isResponseReceived=true;
        if(listOfTaggedDrivers.length==0)
        {
          isTaggedDriverFound=false;
        }
        if(mounted) {
          setState(() {});
        }
        print(LOGTAG+" untagUserFromDevice->"+resBody.toString());

      }
      else if (response.statusCode == 400)
      {
        isResponseReceived=true;
        if(mounted){
          setState(() {});
        }
        global.helperClass.showAlertDialog(context, "", "Driver Not Found", false, "");
      }
      else if (response.statusCode == 500)
      {
        isResponseReceived=true;
        if(mounted){
          setState(() {});
        }
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
      }
    }
    else
    {
      isResponseReceived=true;
      if(mounted){
        setState(() {});
      }
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
    }

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
          body: isResponseReceived?(
              !isTaggedDriverFound?new Stack(
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
                          child: new Text('No Tagged Driver Found', style: TextStyle(fontSize: global.font16, color: Color(0xff30242A),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
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
                                  child: ListOfTaggedDrivers(index: index, taggedDriverObject: listOfTaggedDrivers[index],onTabCicked: (flag){
                                    if(flag.toString().compareTo("Delete")==0)
                                    {
                                      deleteConfirmationPopup(listOfTaggedDrivers[index],index);
                                    }
                                  },
                                  ),
                                );
                              }, childCount: listOfTaggedDrivers.length)
                          )
                        ]
                    ),
                  )
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
          floatingActionButton:FloatingActionButton(
            child: new Container(
              child:Icon(Icons.add,color: global.whiteColor,),
            ),
            backgroundColor: global.mainColor,
            onPressed: () {
              onTabClicked(null,null);
            },
          ),
        )
    );
  }
}
