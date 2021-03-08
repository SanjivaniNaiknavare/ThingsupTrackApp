import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/activities/DeviceDetailsScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfDevices.dart';



class DevicesScreen extends StatefulWidget
{
  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen>
{
  String LOGTAG="DevicesScreen";

  List<DeviceObjectAllAccount> listOfDevices=new List();
  ScrollController _scrollController=new ScrollController();
  bool isResponseReceived=false;
  bool isDeviceFound=false;

  @override
  void initState()
  {
    getDevices();
    super.initState();


  }

  void getDevices() async
  {

    isResponseReceived=false;
    isDeviceFound=false;
    listOfDevices.clear();

    setState(() {});

    Response response=await global.apiClass.GetAccountDevices();
    print(LOGTAG+" getAccountDevices response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getAccountDevices statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getAccountDevices->"+resBody.toString());

        List<dynamic> payloadList=resBody;

        print(LOGTAG+" payloadList->"+payloadList.length.toString());

        for (int i = 0; i < payloadList.length; i++)
        {
          int id=payloadList.elementAt(i)['id'];
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

          DeviceObjectAllAccount deviceObjectAllAccount=new DeviceObjectAllAccount(id:id,name: name,uniqueid: uniqueid,static: static,groupid: null,phone: phone.toString(),model: model.toString(),contact: contact.toString(),type: type);
          listOfDevices.add(deviceObjectAllAccount);
        }

        isResponseReceived=true;
        if(listOfDevices.length>0)
        {
          isDeviceFound=true;
        }
        setState(() {});
        print(LOGTAG+" listOfDevices->"+listOfDevices.length.toString());

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

  void onTabClicked(int index, DeviceObjectAllAccount deviceObjectAllAccount) async
  {

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DeviceDetailsScreen(index: index,deviceObjectAllAccount: deviceObjectAllAccount,))).then((value) => ({

      if(global.lastFunction.toString().contains("addDevice"))
        {
          global.helperClass.showAlertDialog(context, "", "Device added successfully", false, "")
        }
      else if(global.lastFunction.toString().contains("updateDevice")){
        global.helperClass.showAlertDialog(context, "", "Device updated successfully", false, "")
      }
      else if(global.lastFunction.toString().contains("deleteDevice")){
          global.helperClass.showAlertDialog(context, "", "Device deleted successfully", false, "")
        },
      getDevices()
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
//          appBar:AppBar(
//            titleSpacing: 0.0,
//            elevation: 5,
//            automaticallyImplyLeading: false,
//            title: Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: [
//                Container(
//                    padding:  EdgeInsets.fromLTRB(15,0,0,0),
//                    child:  GestureDetector(
//                        onTap: (){_onbackButtonPressed();},
//                        child: new Container(
//                          height: 25,
//                          child:Image(image: AssetImage('assets/back-arrow.png')),
//                        )
//                    )
//                ),
//                Container(
//                    padding:  EdgeInsets.fromLTRB(15,0,0,0),
//                    child:  new Text("Device Management",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
//                ),
//              ],
//            ),
//            actions: <Widget>[
//              GestureDetector(
//                onTap: (){
//                  onTabClicked(null,null);
//                },
//                child: new Container(
//                  width: 50,
//                  child: Icon(Icons.add,color: global.appbarTextColor,),
//                ),
//              )
//            ],
//            backgroundColor:global.screenBackColor,
//          ),
          body: isResponseReceived?(
              !isDeviceFound?new Stack(
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
                          child: new Text('No Device Found', style: TextStyle(fontSize: global.font16, color: Color(0xff30242A),fontWeight: FontWeight.normal,fontFamily: 'PoppinsRegular')),
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
                        physics: AlwaysScrollableScrollPhysics(),
                        slivers: <Widget>[
                          SliverList(
                              delegate: SliverChildBuilderDelegate((context, index)
                              {
                                return Container(
                                  color: global.transparent,
                                  child: ListOfDevices(index: index, deviceObject: listOfDevices[index],onTabClicked: (flag){

                                    onTabClicked(index,listOfDevices[index]);

                                  },
                                  ),
                                );
                              }, childCount: listOfDevices.length)
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
