import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/activities/SearchDeviceHomeScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helperClass/MyObject.dart';
import 'package:thingsuptrackapp/helpers/HomeScreenDeviceDetails.dart';
import 'package:thingsuptrackapp/helpers/HomeScreenDriverInfo.dart';
import 'package:thingsuptrackapp/helpers/ListOfHomeScreenDevices.dart';
import 'package:thingsuptrackapp/helpers/ShareDevicePopup.dart';
import 'package:web_socket_channel/io.dart';


class HomeScreenBottomSheet extends StatefulWidget
{
  HomeScreenBottomSheet({Key key,this.scrollController,this.onDevicesReceived,this.onDeviceSelected,this.onDevicesUpdated}) : super(key: key);
  ScrollController scrollController;
  ValueChanged<List<DeviceObjectAllAccount>> onDevicesReceived;
  ValueChanged<List<DeviceObjectAllAccount>> onDevicesUpdated;
  ValueChanged<DeviceObjectAllAccount> onDeviceSelected;

  HomeScreenBottomSheetState createState()=> HomeScreenBottomSheetState();
}


class HomeScreenBottomSheetState extends State<HomeScreenBottomSheet> {

  String LOGTAG="HomeScreenBottomSheet";
  int selectedType=0;
  bool isResponseReceived=false;
  bool isDeviceFound=false;
  List<DeviceObjectAllAccount> currentListOfDevices=new List();
  List<DeviceObjectAllAccount> listOfDevices=new List();
  bool expandFlag=false;
  bool isShowDriverInfo=false;
  DeviceObjectAllAccount expandDeviceObject;

  int totalDevices=0;
  int movingDevices=0;
  int idleDevices=0;
  int offlineDevices=0;
  int stoppedDevices=0;
  int alertDevices=0;
  int today_midnight=0;

  @override
  void initState() {
    super.initState();

    getUserData();

    // getDevices();
    // socketConnect();

  }

  void getUserData() async
  {

    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);
    today_midnight = lastMidnight.millisecondsSinceEpoch;

    Response response=await global.apiClass.GetUser();
    print(LOGTAG+" getUser response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG + " getUser statusCode->" + response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG + " getuser->" + resBody.toString());

        int reslength = resBody.toString().length;
        print(LOGTAG + " resBody length->" + reslength.toString());

        if (reslength > 30)
        {
          Map<String, dynamic> payloadList = resBody;
          bool disabled = false;
          bool twelvehourformat = false;

          int id = payloadList['id'];
          String name = payloadList['name'];
          String email = payloadList['email'];
          String password = payloadList['password'];
          String role = payloadList['role'];
          String phone = payloadList['phone'];
          String mode = payloadList['mode'];
          String avatar = payloadList['avatar'];
          String custommap = payloadList['custommap'];
          String attributes = payloadList['attributes'];
          int disabledData = payloadList['disabled'];
          int twelvehourformatData = payloadList['twelvehourformat'];
          if (disabledData == 0)
          {
            disabled = false;
          }
          if (twelvehourformatData == 1)
          {
            twelvehourformat = true;
          }

          MyObject myObject = new MyObject(id: id,
              email: email,
              name: name,
              password: password,
              role: role,
              disabled: disabled,
              phone: phone,
              twelvehourformat: twelvehourformat,
              custommap: custommap,
              attributes: attributes,
              mode: mode,
              avatar: avatar);
          global.myObject = myObject;
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
      getDevices();
    }
    else
    {
      getDevices();
    }
  }

  void socketConnect() async
  {

    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    String socketURL="wss://dev.trackapi.thingsup.io/socket.io/?EIO=4&transport=websocket&authorization=Bearer "+idToken.toString();

    int count=0;
    // var inputJson='42["DeviceUpdate",{"id":375968,"name":"TestDevice2","uniqueid":"121","lastupdate":"2021-03-12T07:51:20.000Z","positionid":375968,"groupid":0,"ownerid":2,"attributes":"{\\"sat\\": 7, \\"hdop\\": 0.9, \\"io68\\": 0, \\"pdop\\": 1, \\"rssi\\": 5, \\"event\\": 0, \\"io200\\": 0, \\"power\\": 0, \\"temp1\\": 25, \\"motion\\": true, \\"battery\\": 3.857, \\"distance\\": 7.32, \\"ignition\\": false, \\"odometer\\": 8124, \\"operator\\": 40490, \\"priority\\": 0, \\"gpsStatus\\": 1, \\"totalDistance\\": 9018161.78}","static":null,"status":1,"moving":0,"ignition":0,"phone":"","model":"","contact":"","type":"tanker","disabled":0,"created_at":"2021-02-27T06:26:35.000Z","protocol":"teltonika","deviceid":6,"servertime":"2021-03-12T07:51:20.000Z","devicetime":"2021-03-12T07:51:14.000Z","fixtime":"2021-03-12T07:51:14.000Z","valid":1,"latitude":18.5059699,"longitude":73.9459983,"altitude":578,"speed":0,"course":104,"address":null,"accuracy":0,"network":null}]';

    var channel =IOWebSocketChannel.connect(Uri.parse(socketURL));
    print("connection closeCode->"+channel.closeCode.toString());
    print("connection closeReason->"+channel.closeReason.toString());
    channel.stream.listen((message) {

      print(message);
      if(message.toString().startsWith("0{"))
      {
        channel.sink.add('40');
      }
      if(message.toString().compareTo("2")==0)
      {
        channel.sink.add('3');
      }


      //  print(LOGTAG+" message->"+message.toString());

      if (message.toString().contains('42["DeviceUpdate"'))
      {
        print(LOGTAG+" deviceUpdate string  found");
        var jsonStr = message.toString().substring(18, message.toString().indexOf("]"));
        var resBody=json.decode(jsonStr.toString());

        print(LOGTAG+" resBody->");
        print(resBody);

        Map<String,dynamic> payloadList = resBody;

        bool isMoving=false;
        bool isIdle=false;
        bool isOffline=false;
        bool isStopped=false;
        String status="Stopped";

        int id = payloadList['id'];
        int deviceid=payloadList['deviceid'];
        String uniqueid = payloadList['uniqueid'];
        String name = payloadList['name'];
        String type = payloadList['type'];
        String phone = payloadList['phone'];
        String model = payloadList['model'];
        String contact = payloadList['contact'];
        var latlngStatic = payloadList['static'];

        String lastUpdate2=payloadList['lastupdate'];
        String lastUpdate="";
        if(lastUpdate2!=null)
        {
          var strToDateTime = DateTime.parse(lastUpdate2.toString());
          int miliTime=strToDateTime.millisecondsSinceEpoch;
          var formattedDate;
          print(LOGTAG+" miliTime->"+miliTime.toString());
          if(global.myObject!=null)
          {
            if (global.myObject.twelvehourformat)
            {
              var date = DateTime.fromMillisecondsSinceEpoch(miliTime);
              if(miliTime>today_midnight)
              {
                formattedDate = global.TodaytwelveHrFormatter.format(date);
                lastUpdate="today, "+formattedDate.toString();
              }
              else
              {
                formattedDate = global.twelveHrFormatter.format(date);
                lastUpdate=formattedDate.toString();
              }
            }
            else
            {
              var date = DateTime.fromMillisecondsSinceEpoch(miliTime);
              if(miliTime>today_midnight)
              {
                formattedDate = global.TodaytwentyfourHrFormatter.format(date);
                lastUpdate="today, "+formattedDate.toString();
              }
              else
              {
                formattedDate = global.twentyfourHrFormatter.format(date);
                lastUpdate=formattedDate.toString();
              }
            }
          }
          else
          {
            var date = DateTime.fromMillisecondsSinceEpoch(miliTime);
            formattedDate = global.twelveHrFormatter.format(date);
            lastUpdate=formattedDate.toString();
          }
        }

        var speedData=payloadList['speed'];
        int valid=payloadList['valid'];


        double latitude=0;
        double longitude=0;
        if(payloadList['latitude']!=null)
        {
          if(payloadList['latitude']==0)
          {
            latitude=0;
          }
          else{
            latitude=payloadList['latitude'];
          }
        }
        else{
          latitude=payloadList['latitude'];
        }

        if(payloadList['longitude']!=null)
        {
          if(payloadList['longitude']==0)
          {
            longitude=0;
          }
          else{
            longitude=payloadList['longitude'];
          }
        }
        else
        {
          longitude=payloadList['longitude'];
        }

        int accuracy=payloadList['accuracy'];
        var attributeData=payloadList['attributes'];
        Map<String,dynamic> attributes=new Map();
        int movingData=payloadList['moving'];
        int ignitionData=payloadList['ignition'];
        int statusData=payloadList['status'];
        int course=payloadList['course'];

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

        if(ignitionData==0 && statusData==1 && movingData==0)
        {
          isStopped=true;
          status="Stopped";
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
            latitude=lat;
            longitude=lng;
          }
        }


        DeviceObjectAllAccount deviceObjectAllAccount = new DeviceObjectAllAccount(id: id,
            deviceid: deviceid,
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
            accuracy: accuracy,moving: isMoving,idle: isIdle,offline: isOffline,stopped: isStopped,status: status,course: course);

        if(expandDeviceObject!=null)
        {
          String expandName=expandDeviceObject.name.toString();
          String expandUniqueID=expandDeviceObject.uniqueid.toString();
          if(deviceObjectAllAccount.name.toString().compareTo(expandName)==0 && deviceObjectAllAccount.uniqueid.toString().compareTo(expandUniqueID)==0)
          {
            print(LOGTAG+" inside expand object match");
            expandDeviceObject.attributes=attributes;
            expandDeviceObject.lastUpdate=lastUpdate;
            isShowDriverInfo=false;
          }
        }

        for(int k=0;k<listOfDevices.length;k++)
        {
          int j=k;
          DeviceObjectAllAccount devObject=listOfDevices.elementAt(k);
          if(devObject.name.toString().compareTo(name)==0 && devObject.uniqueid.toString().compareTo(uniqueid)==0)
          {
            print(LOGTAG+" updated device found in my acc attributes->"+attributes.toString());
            devObject.lastUpdate=lastUpdate;
            devObject.model=model;
            devObject.contact=contact;
            devObject.type=type;
            devObject.speed=speed;
            devObject.valid=valid;
            devObject.latitude=latitude;
            devObject.longitude=longitude;
            devObject.attributes=attributes;
            devObject.accuracy=accuracy;
            devObject.moving=isMoving;
            devObject.idle=isIdle;
            devObject.offline=isOffline;
            devObject.stopped=isStopped;
            devObject.status=status;
            devObject.course=course;
          }
        }

        setState(() {});
        widget.onDevicesUpdated(listOfDevices);
        print(LOGTAG+" listOFDevices length->"+listOfDevices.length.toString());
        changeDeviceCount();
      }

      //channel.sink.close(status.goingAway);
    });

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
    // print(LOGTAG+" getAccountDevices response->"+response.toString());

    if(response!=null)
    {
      //print(LOGTAG+" getAccountDevices statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        //  print(LOGTAG+" getAccountDevices body->"+response.body);

        //print(LOGTAG+" getAccountDevices resBody->"+resBody.toString());

        int reslength=resBody.toString().length;
        //  print(LOGTAG+" resBody length->"+reslength.toString());

        if(reslength>50)
        {
          List<dynamic> payloadList = resBody;


          for (int i = 0; i < payloadList.length; i++)
          {
            bool isMoving=false;
            bool isIdle=false;
            bool isOffline=false;
            bool isStopped=false;
            String status="";




            int id = payloadList.elementAt(i)['id'];
            int deviceid = payloadList.elementAt(i)['deviceid'];
            String uniqueid = payloadList.elementAt(i)['uniqueid'];
            String name = payloadList.elementAt(i)['name'];
            String type = payloadList.elementAt(i)['type'];
            String phone = payloadList.elementAt(i)['phone'];
            String model = payloadList.elementAt(i)['model'];
            String contact = payloadList.elementAt(i)['contact'];
            var latlngStatic = payloadList.elementAt(i)['static'];

            //String lastUpdate=payloadList.elementAt(i)['lastupdate'];
            String lastUpdate2=payloadList.elementAt(i)['lastupdate'];
            String lastUpdate="";
            if(lastUpdate2!=null)
            {
              var strToDateTime = DateTime.parse(lastUpdate2.toString());
              int miliTime=strToDateTime.millisecondsSinceEpoch;
              var formattedDate;

              if(global.myObject!=null)
              {
                if (global.myObject.twelvehourformat)
                {
                  var date = DateTime.fromMillisecondsSinceEpoch(miliTime);
                  if(miliTime>today_midnight)
                  {
                    formattedDate = global.TodaytwelveHrFormatter.format(date);
                    lastUpdate="today, "+formattedDate.toString();
                  }
                  else
                  {
                    formattedDate = global.twelveHrFormatter.format(date);
                    lastUpdate=formattedDate.toString();
                  }
                }
                else
                {
                  var date = DateTime.fromMillisecondsSinceEpoch(miliTime);
                  if(miliTime>today_midnight)
                  {
                    formattedDate = global.TodaytwentyfourHrFormatter.format(date);
                    lastUpdate="today, "+formattedDate.toString();
                  }
                  else
                  {
                    formattedDate = global.twentyfourHrFormatter.format(date);
                    lastUpdate=formattedDate.toString();
                  }
                }
              }
              else
              {
                var date = DateTime.fromMillisecondsSinceEpoch(miliTime);
                formattedDate = global.twelveHrFormatter.format(date);
                lastUpdate=formattedDate.toString();
              }
            }

            var speedData=payloadList.elementAt(i)['speed'];
            int valid=payloadList.elementAt(i)['valid'];
            double latitude=0;
            double longitude=0;
            if(payloadList.elementAt(i)['latitude']!=null)
            {
              if(payloadList.elementAt(i)['latitude']==0)
              {
                latitude=0;
              }
              else{
                latitude=payloadList.elementAt(i)['latitude'];
              }
            }
            else{
              latitude=payloadList.elementAt(i)['latitude'];
            }

            if(payloadList.elementAt(i)['longitude']!=null)
            {
              if(payloadList.elementAt(i)['longitude']==0)
              {
                longitude=0;
              }
              else{
                longitude=payloadList.elementAt(i)['longitude'];
              }
            }
            else
            {
              longitude=payloadList.elementAt(i)['longitude'];
            }


            print(LOGTAG + " name**->" + name.toString());
            print(LOGTAG + " uniqueid**->" + uniqueid.toString());
            //  print(LOGTAG + " lng**->" + longitude.toString());

            int accuracy=payloadList.elementAt(i)['accuracy'];
            var attributeData=payloadList.elementAt(i)['attributes'];
            Map<String,dynamic> attributes=new Map();
            int movingData=payloadList.elementAt(i)['moving'];
            int ignitionData=payloadList.elementAt(i)['ignition'];
            int statusData=payloadList.elementAt(i)['status'];
            int course=payloadList.elementAt(i)['course'];

            double speed=0;

            totalDevices++;

            if(speedData!=null)
            {
              speed=double.parse(speedData.toString());
              speed = double.parse((speed).toStringAsFixed(2));
            }

            if(attributeData!=null)
            {
              attributes=jsonDecode(attributeData);
            }

            if(ignitionData==0 && statusData==1 && movingData==1)
            {
              isMoving=true;
              status="Moving";
              movingDevices++;
            }

            if(ignitionData==1 && statusData==1 && movingData==0)
            {
              isIdle=true;
              status="Idle";
              idleDevices++;
            }

            if(ignitionData==0 && statusData==1 && movingData==0)
            {
              isStopped=true;
              status="Stopped";
              stoppedDevices++;
            }

            if(statusData==0)
            {
              isOffline=true;
              status="Offline";
              offlineDevices++;
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
                latitude=lat;
                longitude=lng;
              }
            }


            DeviceObjectAllAccount deviceObjectAllAccount = new DeviceObjectAllAccount(id: id,deviceid: deviceid,
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
                accuracy: accuracy,moving: isMoving,idle: isIdle,offline: isOffline,stopped: isStopped,status: status,course: course);

            listOfDevices.add(deviceObjectAllAccount);
            global.myDevices.putIfAbsent(uniqueid, () => deviceObjectAllAccount);
          }

          socketConnect();
          sortList();
          widget.onDevicesReceived(listOfDevices);

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

  void changeDeviceCount() async
  {
    totalDevices=0;
    movingDevices=0;
    idleDevices=0;
    offlineDevices=0;
    stoppedDevices=0;
    alertDevices=0;

    for(int k=0;k<listOfDevices.length;k++)
    {
      DeviceObjectAllAccount devObject=listOfDevices.elementAt(k);
      String status=devObject.status;
      totalDevices++;

      if(status.toString().toLowerCase().compareTo("moving")==0)
      {
        movingDevices++;
      }
      else if(status.toString().toLowerCase().compareTo("idle")==0)
      {
        idleDevices++;
      }
      else if(status.toString().toLowerCase().compareTo("offline")==0)
      {
        offlineDevices++;
      }
      else if(status.toString().toLowerCase().compareTo("stopped")==0)
      {
        stoppedDevices++;
      }
    }

    setState(() {});

  }

  void sortList()
  {

    if(selectedType==0)
    {
      currentListOfDevices.clear();
      currentListOfDevices.addAll(listOfDevices);
    }
    else if(selectedType==1)
    {
      currentListOfDevices.clear();
      for(int k=0;k<listOfDevices.length;k++)
      {
        DeviceObjectAllAccount deviceObjectAllAccount=listOfDevices.elementAt(k);
        if(deviceObjectAllAccount.status.toString().toLowerCase().compareTo("moving")==0)
        {
          currentListOfDevices.add(deviceObjectAllAccount);
        }
      }
      setState(() {});
    }
    else if(selectedType==2)
    {
      currentListOfDevices.clear();
      for(int k=0;k<listOfDevices.length;k++)
      {
        DeviceObjectAllAccount deviceObjectAllAccount=listOfDevices.elementAt(k);
        if(deviceObjectAllAccount.status.toString().toLowerCase().compareTo("idle")==0)
        {
          currentListOfDevices.add(deviceObjectAllAccount);
        }
      }
      setState(() {});
    }
    else if(selectedType==3)
    {
      currentListOfDevices.clear();
      for(int k=0;k<listOfDevices.length;k++)
      {
        DeviceObjectAllAccount deviceObjectAllAccount=listOfDevices.elementAt(k);
        if(deviceObjectAllAccount.status.toString().toLowerCase().compareTo("offline")==0)
        {
          currentListOfDevices.add(deviceObjectAllAccount);
        }
      }
      setState(() {});
    }
    else if(selectedType==4)
    {
      currentListOfDevices.clear();
      for(int k=0;k<listOfDevices.length;k++)
      {
        DeviceObjectAllAccount deviceObjectAllAccount=listOfDevices.elementAt(k);
        if(deviceObjectAllAccount.status.toString().toLowerCase().compareTo("stopped")==0)
        {
          currentListOfDevices.add(deviceObjectAllAccount);
        }
      }
      setState(() {});
    }
    else if(selectedType==5)
    {
      currentListOfDevices.clear();
      for(int k=0;k<listOfDevices.length;k++)
      {
        DeviceObjectAllAccount deviceObjectAllAccount=listOfDevices.elementAt(k);
        if(deviceObjectAllAccount.status.toString().toLowerCase().compareTo("alert")==0)
        {
          currentListOfDevices.add(deviceObjectAllAccount);
        }
      }
      setState(() {});
    }

  }

  void showShareDevicePopup(DeviceObjectAllAccount deviceObject) async
  {

    showDialog(
        context: context,
        builder: (BuildContext context) {

          return Dialog(
            backgroundColor: global.transparent,
            child: Container(

              decoration: BoxDecoration(
                  color: global.whiteColor,
                  border: Border.all(color:global.popupBackColor, width: 1.0),
                  // borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0),
                  )
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
                                          new Text("Share Device", style: TextStyle(fontSize: global.font20,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishSemiBold')),
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
                                              child: Image(image: AssetImage('assets/close-red-icon.png'),color: global.mainBlackColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height:20),
                                ShareDevicePopup(deviceObjectAllAccount: deviceObject,),
                              ],
                            )
                        ),
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
    // TODO: implement build
    return new Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: global.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
        child:Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10.0),
            child: isResponseReceived?(!expandFlag?CustomScrollView(
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
                                                width:30,
                                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Color(0xff121212).withOpacity(0.2),
                                                  border: Border.all(color: Color(0xff121212).withOpacity(0.2), width: 0),
                                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
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
                                          new Text('Devices :',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font16, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
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

                                                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchDeviceHomeScreen(listOfDevices: listOfDevices,onTabClicked: (deviceObject){

                                                  expandDeviceObject=deviceObject;
                                                  expandFlag=true;
                                                  isShowDriverInfo=false;
                                                  setState(() {});

                                                },),),);
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
                                            sortList();
                                            setState(() {});
                                          },
                                          child: new Container(
                                              margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                                              padding: EdgeInsets.fromLTRB(0,0,0,10),
                                              decoration: new BoxDecoration(
                                                color: selectedType==0?Color(0xff3C74DC):global.whiteColor,
                                                border: Border.all(color: selectedType==0?Color(0xff3C74DC):Color(0xffc4c4c4),width: 1),
                                                borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                              ),
                                              child:new Container(
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: new BoxDecoration(
                                                    color: global.whiteColor,
                                                    borderRadius: new BorderRadius.only(
                                                      topLeft: const Radius.circular(8.0),
                                                      topRight: const Radius.circular(8.0),
                                                    )
                                                ),
                                                child: new Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text(totalDevices.toString(), style: TextStyle(fontSize: global.font16, color: Color(0xff3C74DC),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                    SizedBox(height: 5,),
                                                    new Text('Total',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font12, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                  ],
                                                ),
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
                                          sortList();
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                            padding: EdgeInsets.fromLTRB(0,0,0,10),
                                            decoration: new BoxDecoration(
                                              color: selectedType==1?Color(0xff2D9F4C):global.whiteColor,
                                              border: Border.all(color: selectedType==1?Color(0xff2D9F4C):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Container(
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: new BoxDecoration(
                                                    color: global.whiteColor,
                                                    borderRadius: new BorderRadius.only(
                                                      topLeft: const Radius.circular(8.0),
                                                      topRight: const Radius.circular(8.0),
                                                    )
                                                ),
                                                child:new Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text(movingDevices.toString(), style: TextStyle(fontSize: global.font16, color: Color(0xff2D9F4C),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                    SizedBox(height: 5,),
                                                    new Text('Moving', textAlign: TextAlign.center,style: TextStyle(fontSize: global.font12, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                  ],
                                                )
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
                                          sortList();
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                            padding: EdgeInsets.fromLTRB(0,0,0,10),
                                            decoration: new BoxDecoration(
                                              color: selectedType==2?Color(0xffF29900):global.whiteColor,
                                              border: Border.all(color: selectedType==2?Color(0xffF29900):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Container(
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: new BoxDecoration(
                                                    color: global.whiteColor,
                                                    borderRadius: new BorderRadius.only(
                                                      topLeft: const Radius.circular(8.0),
                                                      topRight: const Radius.circular(8.0),
                                                    )
                                                ),
                                                child:
                                                new Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text(idleDevices.toString(), style: TextStyle(fontSize: global.font16, color: Color(0xffF29900),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                    SizedBox(height: 5,),
                                                    new Text('Idle', textAlign: TextAlign.center,style: TextStyle(fontSize: global.font12, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                  ],
                                                )
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
                                          sortList();
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                                            padding: EdgeInsets.fromLTRB(0,0,0,10),
                                            decoration: new BoxDecoration(
                                              color: selectedType==3?Color(0xff6B6B6B):global.whiteColor,
                                              border: Border.all(color: selectedType==3?Color(0xff6B6B6B):Color(0xffc4c4c4),width:1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Container(
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: new BoxDecoration(
                                                    color: global.whiteColor,
                                                    borderRadius: new BorderRadius.only(
                                                      topLeft: const Radius.circular(8.0),
                                                      topRight: const Radius.circular(8.0),
                                                    )
                                                ),
                                                child:
                                                new Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text(offlineDevices.toString(), style: TextStyle(fontSize: global.font16, color: Color(0xff6B6B6B),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                    SizedBox(height: 5,),
                                                    new Text('Offline', textAlign: TextAlign.center,style: TextStyle(fontSize: global.font12, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                  ],
                                                )
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
                                          sortList();
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                            padding: EdgeInsets.fromLTRB(0,0,0,10),
                                            decoration: new BoxDecoration(
                                              color: selectedType==4?Color(0xffAF7126):global.whiteColor,
                                              border: Border.all(color: selectedType==4?Color(0xffAF7126):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Container(
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: new BoxDecoration(
                                                    color: global.whiteColor,
                                                    borderRadius: new BorderRadius.only(
                                                      topLeft: const Radius.circular(8.0),
                                                      topRight: const Radius.circular(8.0),
                                                    )
                                                ),
                                                child:
                                                new Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text(stoppedDevices.toString(), style: TextStyle(fontSize: global.font16, color: Color(0xffAF7126),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                    SizedBox(height: 5,),
                                                    new Text('Stopped', textAlign: TextAlign.center,style: TextStyle(fontSize: global.font12, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                  ],
                                                )
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
                                          sortList();
                                          setState(() {});
                                        },
                                        child:  new Container(
                                            margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                            padding: EdgeInsets.fromLTRB(0,0,0,10),
                                            decoration: new BoxDecoration(
                                              color: selectedType==5?Color(0xffE51B1A):global.whiteColor,
                                              border: Border.all(color: selectedType==5?Color(0xffE51B1A):Color(0xffc4c4c4),width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                            ),
                                            child:new Container(
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: new BoxDecoration(
                                                    color: global.whiteColor,
                                                    borderRadius: new BorderRadius.only(
                                                      topLeft: const Radius.circular(8.0),
                                                      topRight: const Radius.circular(8.0),
                                                    )
                                                ),
                                                child:
                                                new Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text(alertDevices.toString(), style: TextStyle(fontSize: global.font16, color: Color(0xffE51B1A),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                    SizedBox(height: 5,),
                                                    new Text('Alert', textAlign: TextAlign.center, style: TextStyle(fontSize: global.font12, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                                  ],
                                                )
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
                  currentListOfDevices.length>0?SliverList(
                      delegate: SliverChildBuilderDelegate((context, index)
                      {
                        return Center
                          (
                          child:Container(
                            child: ListOfHomeScreenDevices(index: index,expandFlag:expandFlag,scrollController:widget.scrollController,deviceObjectAllAccount: currentListOfDevices.elementAt(index),onExpandCicked: (value){

                              expandDeviceObject=currentListOfDevices.elementAt(index);
                              expandFlag=value;
                              isShowDriverInfo=false;
                              setState(() {});

                            },onDriverInfoCicked: (flag){

                              expandDeviceObject=currentListOfDevices.elementAt(index);
                              expandFlag=true;
                              isShowDriverInfo=true;
                              setState(() {});
                            },onShareCicked: (isShareClicked){
                              showShareDevicePopup(currentListOfDevices.elementAt(index));
                            },onDeviceSelected: (device) {

                              widget.onDeviceSelected(currentListOfDevices.elementAt(index));
                            }
                            ),
                          ),
                        );
                      }, childCount: currentListOfDevices.length)
                  ):SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            new Container(
                                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    new SvgPicture.asset('assets/home-no-device-found.svg'),
                                    new Text('No Device Found', style: TextStyle(fontSize: global.font14, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))

                                  ],
                                )
                            )
                          ]
                      )
                  ),
                ]
            ):new CustomScrollView(
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
                                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
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
                                        child: new GestureDetector(
                                            onTap: (){
                                              expandFlag=!expandFlag;
                                              setState(() {});
                                            },
                                            child: new Container(
                                              child: new Row(
                                                children: <Widget>[
                                                  new Container(
                                                      padding: EdgeInsets.fromLTRB(0, 2, 10, 2),
                                                      decoration: new BoxDecoration(
                                                        color: global.whiteColor,
                                                        border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                      ),
                                                      child:new Row(
                                                        children: <Widget>[
                                                          Icon(Icons.keyboard_arrow_left,color: global.mainBlackColor,),
                                                          new Text('All Devices',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font16, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),

                                                        ],
                                                      )
                                                  )
                                                ],
                                              ),
                                            )
                                        )
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
                                                isShowDriverInfo=!isShowDriverInfo;
                                                setState(() {});
                                              },
                                              child: new Container(
                                                  height: 35,
                                                  padding: EdgeInsets.fromLTRB(8,8,8,8),
                                                  margin: EdgeInsets.fromLTRB(5,5,0,5),
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: new BoxDecoration(
                                                    color: global.transparent,
                                                    border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                                  ),
                                                  child: !isShowDriverInfo?new SvgPicture.asset('assets/green-driver-icon.svg'):new SvgPicture.asset('assets/close-driver-info-icon.svg')
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                              flex:1,
                                              fit: FlexFit.tight,
                                              child:
                                              GestureDetector(
                                                onTap: (){
                                                  showShareDevicePopup(expandDeviceObject);
                                                },
                                                child:new Container(
                                                    height: 35,
                                                    padding: EdgeInsets.fromLTRB(8,8,8,8),
                                                    margin: EdgeInsets.fromLTRB(5,5,0,5),
                                                    width: MediaQuery.of(context).size.width,
                                                    decoration: new BoxDecoration(
                                                      color: global.transparent,
                                                      border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                                    ),
                                                    child: new SvgPicture.asset('assets/share-icon.svg')
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
                            new Container(
                                child:
                                !isShowDriverInfo?HomeScreenDeviceDetails(deviceObjectAllAccount:expandDeviceObject,scrollController: widget.scrollController,):
                                HomeScreenDriverInfo(deviceObjectAllAccount: expandDeviceObject,)
                            )

                          ]
                      )
                  ),
                ]
            )):new Container(
                height: MediaQuery.of(context).size.height/2,
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
            )
        )
    );
  }
}