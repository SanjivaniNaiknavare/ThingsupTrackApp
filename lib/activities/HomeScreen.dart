import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsuptrackapp/activities/DeviceManagementScreen.dart';
import 'package:thingsuptrackapp/activities/GeofenceManagementScreen.dart';
import 'package:thingsuptrackapp/activities/GeofenceScreen.dart';
import 'package:thingsuptrackapp/activities/UserManagementScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helpers/HomeScreenBottomSheet.dart';
import 'package:thingsuptrackapp/helpers/NavDrawer.dart';



class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  final textController = TextEditingController();
  BuildContext mContext;

  String LOGTAG="HomeScreen";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isResponseReceived=false;
  bool isDeviceFound=false;
  List<DeviceObjectAllAccount> listOfDevices=new List();


  Set<Marker> _markers=new HashSet<Marker>();

  List<Marker> _markerList=new List();

  int _markerIdCounter=1;
  LatLng _center=new LatLng(18.6, 73.7);
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  @override
  void initState()
  {
    super.initState();

    print(LOGTAG+" initState called");
    // getDevices();
    // getUserData();

  }

  void getUserData() async
  {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;
    print(LOGTAG+" idToken->"+idToken.toString());

    List<String> idTokenList=idToken.split(".");
    int decodelength=idTokenList[1].length;
    if(decodelength%4!=0)
    {
      int modData=decodelength%4;
      for(int k=0;k<modData;k++)
      {
        idTokenList[1]=idTokenList[1]+"=";
      }
    }

    print(LOGTAG+" idTokenList->"+idTokenList[1].length.toString());

    String decodedUserJson = utf8.decode(base64.decode(idTokenList[1]));
    print(LOGTAG+" decodedUserJson->"+decodedUserJson);

    String role="";
    var resBody=json.decode(decodedUserJson.toString());
    role=resBody["role"];
    global.userRole=role;
    global.userName=resBody["name"];
    global.userID=_auth.currentUser.uid;
    print(LOGTAG+" role->"+global.userRole.toString());
    print(LOGTAG+" userID->"+global.userID.toString());

    idToken=global.idToken.toString();
    setState(() {});

  }





  Future<bool> _willPopCallback() async
  {
    if (Platform.isAndroid)
    {
      SystemNavigator.pop();
    }
    else if (Platform.isIOS)
    {
      exit(0);
    }
    return true;
  }


  void logoutUser() async{

    await global.firebaseInstance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("LoggedInStatus",false);
    Navigator.pushNamedAndRemoveUntil(context, "/SignIn", (r) => false);
  }

  @override
  void dispose() async
  {
    super.dispose();
  }

  void updateUI(BuildContext context,int value) async
  {
    if(value==2)
    {

    }
    else if(value==3)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementScreen(),),);
    }
    else if(value==4)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceManagementScreen(),),);
    }
    else if(value==5)
    {
      //geofence
      Navigator.push(context, MaterialPageRoute(builder: (context) => GeofenceManagementScreen(),),);
    }
    else if(value==6)
    {

    }
    else if(value==7)
    {
      await global.firebaseInstance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("LoggedInStatus",false);
      Navigator.pushNamedAndRemoveUntil(context, "/SignIn", (r) => false);

    }
  }


  void _onMapCreated(GoogleMapController controller)
  {
    mapController=controller;
    _controller.complete(controller);
  }

  void setMarkers() async
  {
    for(int k=0;k<listOfDevices.length;k++)
    {
      DeviceObjectAllAccount deviceObjectAllAccount = listOfDevices.elementAt(k);
      double rotation=0;
      double lat = deviceObjectAllAccount.latitude;
      double lng = deviceObjectAllAccount.longitude;
      var rot=deviceObjectAllAccount.course;
      String name=deviceObjectAllAccount.name.toString();
      if(rot!=null)
      {
        rotation=rot.toDouble();
      }
      String assetSTR="assets/"+global.currentAppMode.toString()+"/"+deviceObjectAllAccount.type.toString()+".svg";

      if (lat != null && lng != null)
      {
        LatLng point = new LatLng(lat, lng);
        BitmapDescriptor bitmapDescriptor = await global.helperClass.bitmapDescriptorFromSvgAsset(context, assetSTR);

        final String markerIdVal = 'marker_id_$_markerIdCounter';
        _markerIdCounter++;

        Marker marker=new Marker(
            icon: bitmapDescriptor,
            markerId: MarkerId(markerIdVal),
            position: point,
            rotation: rotation,
            infoWindow: InfoWindow(
              title: name,
            ), anchor: Offset(0, 0)
        );

        setState(() {
          _markers.add(marker);
          _markerList.add(marker);
        });
      }
    }
    checkMarkers();
  }

  void checkMarkers() async
  {
    LatLngBounds bounds = await getBounds(_markerList);
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    this.mapController.animateCamera(cameraUpdate);
  }

  Future<LatLngBounds> getBounds(List<Marker> markers) {

    Future<LatLngBounds> fuBounds=Future.value(new LatLngBounds(southwest:  LatLng(0, 0), northeast: LatLng(0, 0)));

    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    fuBounds=Future.value(bounds);
    return fuBounds;
  }

  void changePositionToSelectedDevice(DeviceObjectAllAccount deviceObjectAllAccount)
  {
    double lat=deviceObjectAllAccount.latitude;
    double lng=deviceObjectAllAccount.longitude;

    print(LOGTAG+" lat->"+lat.toString()+" lng->"+lng.toString());

    if(lat!=null && lng!=null)
    {
      _center=new LatLng(lat,lng);

      LatLngBounds bounds = LatLngBounds(northeast: LatLng(lat, lng), southwest: LatLng(lat, lng),);
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
      this.mapController.animateCamera(cameraUpdate);
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    mContext=context;
    return new WillPopScope (
        onWillPop: _willPopCallback,
        child:Scaffold(
            extendBodyBehindAppBar: true,
            key: _scaffoldKey,
            drawer: NavDrawer(optionSelected: (value){
              updateUI(context,value);
            }),
            appBar:AppBar(
              titleSpacing: 0.0,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding:  EdgeInsets.fromLTRB(25,0,0,0),
                      child:  GestureDetector(
                          onTap: (){
                            _scaffoldKey.currentState.openDrawer();
                            setState(() {});
                          },
                          child:new Container(
                              decoration: new BoxDecoration(
                                color: global.whiteColor,
                                border: Border.all(color: Color(0xffc4c4c4),width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(8.0),),
                              ),
                              padding: EdgeInsets.all(10),
                              child:SvgPicture.asset('assets/sidemenu-icon.svg')
                          )
                      )
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
            ),
            body:new Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child:  new Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child:  GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition:CameraPosition(
                          target: _center,
                          zoom: 10.0,
                        ),
                        markers: _markers,

                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                          ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                          ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                          ..add(Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer())),
                        onTap: (point){

                        },
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.2,
                    minChildSize: 0.2,
                    maxChildSize: 1.0,

                    builder: (BuildContext context, ScrollController scrollController){
                      return HomeScreenBottomSheet(scrollController: scrollController,onDevicesReceived: (value){

                        listOfDevices.addAll(value);
                        setMarkers();


                      },onDeviceSelected: (device){

                        changePositionToSelectedDevice(device);

                      },);
                    },
                  )
                ]
            )
        )
    );
  }
}