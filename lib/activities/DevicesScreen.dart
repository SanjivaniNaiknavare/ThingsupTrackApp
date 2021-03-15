import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<DeviceObjectAllAccount> currentListOfDevices=new List();
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
    currentListOfDevices.clear();
    isResponseReceived=false;
    isDeviceFound=false;
    listOfDevices.clear();
    global.myDevices.clear();

    if(mounted) {
      setState(() {});
    }

    Response response=await global.apiClass.GetAccountDevices();
    print(LOGTAG+" getAccountDevices response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getAccountDevices statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getAccountDevices->"+resBody.toString());


        int reslength=resBody.toString().length;
        print(LOGTAG+" resBody length->"+reslength.toString());


        if(reslength>50)
        {
          List<dynamic> payloadList = resBody;
          print(LOGTAG + " payloadList->" + payloadList.length.toString());

          for (int i = 0; i < payloadList.length; i++)
          {
            int id = payloadList.elementAt(i)['id'];
            int deviceid = payloadList.elementAt(i)['deviceid'];
            String uniqueid = payloadList.elementAt(i)['uniqueid'];
            String name = payloadList.elementAt(i)['name'];
            String type = payloadList.elementAt(i)['type'];
            String phone = payloadList.elementAt(i)['phone'];
            String model = payloadList.elementAt(i)['model'];
            String contact = payloadList.elementAt(i)['contact'];
            var latlngStatic = payloadList.elementAt(i)['static'];
            LatLngClass static;
            if (latlngStatic != null)
            {
              Map<String, dynamic> datamap = json.decode(latlngStatic);
              if (datamap.length > 0)
              {
                double lat = datamap['lat'];
                double lng = datamap['lng'];
                static = new LatLngClass(lat: lat, lng: lng);
              }
            }

            DeviceObjectAllAccount deviceObjectAllAccount = new DeviceObjectAllAccount(id: id, deviceid:deviceid,name: name, uniqueid: uniqueid, static: static, groupid: null, phone: phone.toString(), model: model.toString(), contact: contact.toString(), type: type);
            listOfDevices.add(deviceObjectAllAccount);
            global.myDevices.putIfAbsent(uniqueid, () => deviceObjectAllAccount);
          }

          isResponseReceived=true;
          if(listOfDevices.length>0)
          {
            currentListOfDevices.addAll(listOfDevices);
            isDeviceFound=true;
          }
          if(mounted) {
            setState(() {});
          }
        }
        else
        {
          String status=resBody['status'];
          if(status.toString().compareTo("Devices not found")==0)
          {
            isResponseReceived=true;
            isDeviceFound=false;
            if(mounted) {
              setState(() {});
            }
          }
        }
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


  void deleteDevice(DeviceObjectAllAccount deviceObjectAllAccount,int index) async
  {
    isResponseReceived=false;
    setState(() {});

    String uniqueId=deviceObjectAllAccount.uniqueid.toString();

    Response response=await global.apiClass.DeleteDevice(uniqueId);
    if(response!=null)
    {
      print(LOGTAG+" deleteDelete statusCode->"+response.statusCode.toString());
      print(LOGTAG+" deleteDelete body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);

        int finalIndex=0;
        for(int s=0;s<listOfDevices.length;s++)
        {
          DeviceObjectAllAccount dObj=listOfDevices.elementAt(s);
          if(dObj.uniqueid.compareTo(uniqueId)==0)
          {
            finalIndex=s;
            global.myDevices.remove(uniqueId);
          }
        }
        listOfDevices.removeAt(finalIndex);
        currentListOfDevices.removeAt(index);
        isResponseReceived=true;
        currentListOfDevices.addAll(listOfDevices);
        if(currentListOfDevices.length==0)
        {
          isDeviceFound=false;
        }
        setState(() {});
        global.helperClass.showAlertDialog(context, "", "Device deleted successfully", false, "");
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

  void deleteConfirmationPopup(DeviceObjectAllAccount deviceObjectAllAccount,int index)
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
                          new Text("Are you sure you want to delete the \'"+deviceObjectAllAccount.name.toString()+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
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
                                    deleteDevice(deviceObjectAllAccount,index);
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
    currentListOfDevices.clear();
    for(int k=0;k<listOfDevices.length;k++)
    {
      DeviceObjectAllAccount deviceObjectAllAccount=listOfDevices.elementAt(k);
      if(deviceObjectAllAccount.name.toString().toLowerCase().contains(searchSTR.toString().toLowerCase()))
      {
        currentListOfDevices.add(deviceObjectAllAccount);
      }
    }
    setState(() {});
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
              !isDeviceFound?new Container(
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
                                    child: new Container(
                                        padding: EdgeInsets.all(10),
                                        child:new SvgPicture.asset('assets/no-device-found.svg')
                                    ),
                                  ),
                                  new Container(
                                    color: global.screenBackColor,
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: new Text('No Device Added Yet', style: TextStyle(fontSize: global.font16, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
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
                                        child:new Text('Add Device',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                                      color: global.transparent,
                                      child: ListOfDevices(index: index, deviceObject: currentListOfDevices[index],onTabClicked: (flag){

                                        if(flag.toString().contains("Edit"))
                                        {
                                          onTabClicked(index,currentListOfDevices[index]);
                                        }
                                        else
                                        {
                                          deleteConfirmationPopup(currentListOfDevices[index],index);
                                        }
                                      },
                                      ),
                                    );
                                  }, childCount: currentListOfDevices.length)
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
