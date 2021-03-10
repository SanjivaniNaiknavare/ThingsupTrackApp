import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfHomeScreenDevices.dart';


class HomeScreenBottomSheet extends StatefulWidget
{
  HomeScreenBottomSheet({Key key,this.scrollController}) : super(key: key);
  ScrollController scrollController;

  HomeScreenBottomSheetState createState()=> HomeScreenBottomSheetState();
}


class HomeScreenBottomSheetState extends State<HomeScreenBottomSheet> {

  String LOGTAG="HomeScreenBottomSheet";
  int selectedType=0;
  bool isResponseReceived=false;
  bool isDeviceFound=false;
  List<DeviceObjectAllAccount> currentListOfDevices=new List();
  List<DeviceObjectAllAccount> listOfDevices=new List();

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  void getDevices() async
  {
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
            bool isMoving=false;
            bool isIdle=false;
            bool isOffline=false;
            bool isStopped=false;
            String status="Stoppepd";

            int id = payloadList.elementAt(i)['id'];
            String uniqueid = payloadList.elementAt(i)['uniqueid'];
            String name = payloadList.elementAt(i)['name'];
            String type = payloadList.elementAt(i)['type'];
            String phone = payloadList.elementAt(i)['phone'];
            String model = payloadList.elementAt(i)['model'];
            String contact = payloadList.elementAt(i)['contact'];
            var latlngStatic = payloadList.elementAt(i)['static'];

            String lastUpdate=payloadList.elementAt(i)['lastupdate'];
            var speedData=payloadList.elementAt(i)['speed'];
            int valid=payloadList.elementAt(i)['valid'];
            double latitude=payloadList.elementAt(i)['latitude'];
            double longitude=payloadList.elementAt(i)['longitude'];
            int accuracy=payloadList.elementAt(i)['accuracy'];
            var attributeData=payloadList.elementAt(i)['attributes'];
            Map<String,dynamic> attributes=new Map();
            int movingData=payloadList.elementAt(i)['moving'];
            int ignitionData=payloadList.elementAt(i)['ignition'];
            int statusData=payloadList.elementAt(i)['status'];

            double speed=0;

            if(speedData!=null)
            {
              speed=double.parse(speedData.toString());
              speed = double.parse((speed).toStringAsFixed(2));
            }

            if(attributeData!=null)
            {
              attributes=jsonDecode(attributeData);
            }

            if(lastUpdate!=null)
            {
              lastUpdate=lastUpdate.replaceAll("T", " ");
              lastUpdate=lastUpdate.replaceAll(".000Z", "");
            }

            if(ignitionData==0 && statusData==1 && movingData==1)
            {
              isMoving=true;
              status="Moving";
            }

            if(ignitionData==1 && statusData==1 && movingData==0)
            {
              isIdle=true;
              status="Idle";
            }

            if(statusData==0)
            {
              isOffline=true;
              status="Offline";
            }


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


            DeviceObjectAllAccount deviceObjectAllAccount = new DeviceObjectAllAccount(id: id,
                name: name,
                uniqueid: uniqueid,
                static: static,
                groupid: null,
                phone: phone.toString(),
                model: model.toString(),
                contact: contact.toString(),
                type: type,
                lastUpdate:lastUpdate,
                speed: speed,valid: valid,latitude: latitude,longitude: longitude,attributes: attributes,
                accuracy: accuracy,moving: isMoving,idle: isIdle,offline: isOffline,stopped: isStopped,status: status);

            listOfDevices.add(deviceObjectAllAccount);
            global.myDevices.putIfAbsent(uniqueid, () => deviceObjectAllAccount);
          }
          sortList();

          isResponseReceived=true;
          if(listOfDevices.length>0)
          {
            isDeviceFound=true;
          }

          print(LOGTAG+" listOfDevices->"+listOfDevices.length.toString());
          setState(() {});

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

  void sortList()
  {

    if(selectedType==0)
    {
      currentListOfDevices.addAll(listOfDevices);
    }

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        width: MediaQuery.of(context).size.width,
        color: global.whiteColor,
        child:Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10.0),
            child: CustomScrollView(
                controller: widget.scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            new Column(
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                      color: global.whiteColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      child: Container(
                                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                                          child:new Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Container(
                                                width:20,
                                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd0d0d0),
                                                  border: Border.all(color: Color(0xffd0d0d0), width: 1.0),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(2.0)),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    )
                                ),
                                new Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex:1,
                                      fit: FlexFit.tight,
                                      child: new Row(
                                        children: <Widget>[
                                          new Text('Devices :',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font16, color: Color(0xff121212),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex:1,
                                      fit: FlexFit.tight,
                                      child: new Row(
                                        children: <Widget>[

                                          Flexible(
                                              flex:1,
                                              fit: FlexFit.tight,
                                              child:new Container()
                                          ),
                                          Flexible(
                                              flex:1,
                                              fit: FlexFit.tight,
                                              child:new Container()
                                          ),
                                          Flexible(
                                            flex:1,
                                            fit: FlexFit.tight,
                                            child: GestureDetector(
                                              onTap: (){

                                              },
                                              child: new Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 35,
                                                  margin: EdgeInsets.fromLTRB(5,0,5,0),
                                                  child:new SvgPicture.asset('assets/search-icon.svg',)
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                              flex:1,
                                              fit: FlexFit.tight,
                                              child:
                                              GestureDetector(
                                                onTap: (){

                                                },
                                                child: new Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 35,
                                                    margin: EdgeInsets.fromLTRB(5,0,5,0),
                                                    child:new SvgPicture.asset('assets/notification-icon.svg',)
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height:10)
                              ],
                            )
                          ]
                      )
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            new Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: GestureDetector(
                                          onTap: (){
                                            selectedType=0;
                                            setState(() {});
                                          },
                                          child: new Container(
                                              margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                                              padding: EdgeInsets.fromLTRB(5,10,5,10),
                                              decoration: new BoxDecoration(
                                                color: global.whiteColor,
                                                border: Border.all(color: selectedType==0?Color(0xff3C74DC):Color(0xffc4c4c4),width: 1),
                                                borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                              ),
                                              child:new Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  new Text("3", style: TextStyle(fontSize: global.font16, color: Color(0xff3C74DC),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                  SizedBox(height: 5,),
                                                  new Text('Total',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                ],
                                              )
                                          ),
                                        )
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: GestureDetector(
                                        onTap: (){
                                          selectedType=1;
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                            padding: EdgeInsets.fromLTRB(5,10,5,10),
                                            decoration: new BoxDecoration(
                                              color: global.whiteColor,
                                              border: Border.all(color: selectedType==1?Color(0xff2D9F4C):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Text("3", style: TextStyle(fontSize: global.font16, color: Color(0xff2D9F4C),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                SizedBox(height: 5,),
                                                new Text('Moving', textAlign: TextAlign.center,style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: GestureDetector(
                                        onTap: (){
                                          selectedType=2;
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                            padding: EdgeInsets.fromLTRB(5,10,5,10),
                                            decoration: new BoxDecoration(
                                              color: global.whiteColor,
                                              border: Border.all(color: selectedType==2?Color(0xffF29900):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Text("3", style: TextStyle(fontSize: global.font16, color: Color(0xffF29900),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                SizedBox(height: 5,),
                                                new Text('Idle', textAlign: TextAlign.center,style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                              ],
                                            )
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                new Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: GestureDetector(
                                        onTap: (){
                                          selectedType=3;
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                                            padding: EdgeInsets.fromLTRB(5,10,5,10),
                                            decoration: new BoxDecoration(
                                              color: global.whiteColor,
                                              border: Border.all(color: selectedType==3?Color(0xff6B6B6B):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Text("3", style: TextStyle(fontSize: global.font16, color: Color(0xff6B6B6B),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                SizedBox(height: 5,),
                                                new Text('Offline', textAlign: TextAlign.center,style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: GestureDetector(
                                        onTap: (){
                                          selectedType=4;
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                            padding: EdgeInsets.fromLTRB(5,10,5,10),
                                            decoration: new BoxDecoration(
                                              color: global.whiteColor,
                                              border: Border.all(color: selectedType==4?Color(0xffAF7126):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Text("3", style: TextStyle(fontSize: global.font16, color: Color(0xffAF7126),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                SizedBox(height: 5,),
                                                new Text('Stopped', textAlign: TextAlign.center,style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: GestureDetector(
                                        onTap: (){
                                          selectedType=5;
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                            padding: EdgeInsets.fromLTRB(5,10,5,10),
                                            decoration: new BoxDecoration(
                                              color: global.whiteColor,
                                              border: Border.all(color: selectedType==5?Color(0xffE51B1A):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Text("0", style: TextStyle(fontSize: global.font16, color: Color(0xffE51B1A),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                SizedBox(height: 5,),
                                                new Text('Alert', textAlign: TextAlign.center, style: TextStyle(fontSize: global.font12, color: Color(0xff121212),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                              ],
                                            )
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ]
                      )
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index)
                      {
                        return Center
                          (
                          child:Container(
                            child: ListOfHomeScreenDevices(index: index,scrollController:widget.scrollController,deviceObjectAllAccount: currentListOfDevices.elementAt(index),onTabCicked: (value){

                            },),
                          ),
                        );
                      }, childCount: currentListOfDevices.length)
                  )
                ]
            )
        )
    );
  }
}