import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/GeofenceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;

class GeofenceDetailsScreen extends StatefulWidget
{
  GeofenceDetailsScreen({Key key,this.index,this.geofenceObject}) : super(key: key);
  int index;
  GeofenceObject geofenceObject;


  @override
  _GeofenceDetailsScreenState createState() => _GeofenceDetailsScreenState();
}

class _GeofenceDetailsScreenState extends State<GeofenceDetailsScreen>
{
  String LOGTAG="GeofenceDetailsScreen";
  Completer<GoogleMapController> _controller = Completer();
  Set<Polygon> _polygons=new HashSet<Polygon>();
  Set<Marker> _markers=new HashSet<Marker>();
  List<LatLng> listofLatLngs=new List();
  List<LatLng> initialListOfLatLngs=new List();
  int _polygonIdCounter=1;
  int _markerIdCounter=1;
  LatLng _center=new LatLng(18.6, 73.7);
  BitmapDescriptor customIcon1;

  String attributeStr="";
  bool nameValidate=false;
  bool descValidate=false;
  bool atttrValidate=false;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final attrController = TextEditingController();


  @override
  void initState(){
    super.initState();

    global.lastFunction="";
    if(widget.geofenceObject!=null)
    {
      attributeStr=json.encode(widget.geofenceObject.attributes);
      attrController.text=attributeStr;
      nameController.text=widget.geofenceObject.name.toString();
      descController.text=widget.geofenceObject.description.toString();
      setPolygon();
    }
    setState(() {});
  }

  void setPolygon() async
  {

    List<dynamic> objectLatLngList=new List();
    objectLatLngList.add(widget.geofenceObject.area);

    List<dynamic> tempDataList=objectLatLngList.elementAt(0);

    print(LOGTAG+" tempDataList->"+tempDataList.length.toString());
    listofLatLngs.clear();

    for(int k=0;k<tempDataList.length;k++)
    {
      var tempData=tempDataList.elementAt(k);
      double lat=tempData["x"];
      double lng=tempData["y"];
      LatLng point=new LatLng(lat, lng);
      print(LOGTAG+" lat->"+lat.toString()+" lng->"+lng.toString());
      _setMarkers(point);
      listofLatLngs.add(point);
    }
    initialListOfLatLngs.addAll(listofLatLngs);
    initialListOfLatLngs.removeLast();
    _setPolygon();
    setState(() {});
  }

  void addGeofence() async
  {
    nameValidate = false;
    descValidate = false;

    String nameData = nameController.text;
    String descData = descController.text;

    if (nameData.isEmpty || nameData == " " || nameData.length == 0)
    {
      nameValidate = true;
    }
    else
    {
      nameValidate = false;
    }

    if (descData.isEmpty || descData == " " || descData.length == 0)
    {
      descValidate = true;
    }
    else
    {
      descValidate = false;
    }


    setState(() {});

    if (!nameValidate && !descValidate)
    {
      if (initialListOfLatLngs.length>=3)
      {
        LatLng point = initialListOfLatLngs.elementAt(0);
        initialListOfLatLngs.add(point);
        print(LOGTAG + " " + initialListOfLatLngs.length.toString());

        String name = nameData;
        String description = descData;
        List<LatLngClass> area = new List();
        AttributeClass attributes;

        for (int k = 0; k < initialListOfLatLngs.length; k++)
        {
          LatLng latLng = initialListOfLatLngs.elementAt(k);
          LatLngClass latLngClass = new LatLngClass(lat: latLng.latitude, lng: latLng.longitude);
          area.add(latLngClass);
        }

        attributes = new AttributeClass("", "");

        AddGeofenceClass addGeofenceClass = new AddGeofenceClass(name: name, description: description, area: area, attributes: attributes);
        var jsonBody = jsonEncode(addGeofenceClass);
        print(LOGTAG + " addGeofence jsonbody->" + jsonBody.toString());

        Response response = await global.apiClass.AddGeofence(jsonBody);

        if (response != null)
        {
          print(LOGTAG + " addGeofence statusCode->" + response.statusCode.toString());
          print(LOGTAG + " addGeofence body->" + response.body.toString());

          if (response.statusCode == 200)
          {
            var resBody = json.decode(response.body);
            global.lastFunction="addGeofence";
            _onbackButtonPressed();
          }
          else if (response.statusCode == 400)
          {
            var resBody = json.decode(response.body);
            String status = resBody['status'];

            if (status.toString().contains("Geofence Doesn't Exist"))
            {
              global.helperClass.showAlertDialog(context, "", "Geofence Doesn't Exist", false, "");
            }
            else if (status.toString().contains("Geofence Update Failed"))
            {
              global.helperClass.showAlertDialog(context, "", "Geofence Update Failed", false, "");
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
      else
      {
        global.helperClass.showAlertDialog(context, "", "Please select valid polygon for geofence", false, "");
      }
    }
  }

  void updateGeofence() async
  {
    LatLng point=initialListOfLatLngs.elementAt(0);
    initialListOfLatLngs.add(point);
    print(LOGTAG+" "+ initialListOfLatLngs.length.toString());

    nameValidate=false;
    descValidate=false;

    String nameData=nameController.text;
    String descData=descController.text;

    if(nameData.isEmpty || nameData==" " || nameData.length==0)
    {
      nameValidate=true;
    }
    else
    {
      nameValidate=false;
    }

    if(descData.isEmpty || descData==" " || descData.length==0)
    {
      descValidate=true;
    }
    else
    {
      descValidate=false;
    }

    setState(() {});

    if(!nameValidate && !descValidate && !atttrValidate)
    {
      String id=widget.geofenceObject.id.toString();
      String name=nameData;
      String description=descData;
      List<LatLngClass> area=new List();
      AttributeClass attributes;

      for(int k=0;k<initialListOfLatLngs.length;k++)
      {
        LatLng latLng=initialListOfLatLngs.elementAt(k);
        LatLngClass latLngClass=new LatLngClass(lat: latLng.latitude,lng:latLng.longitude );
        area.add(latLngClass);
      }

      attributes = new AttributeClass("", "");

      UpdateGeofenceClass updateGeofenceClass=new UpdateGeofenceClass(name: name,description: description,area: area,attributes: attributes,id:id);
      var jsonBody=jsonEncode(updateGeofenceClass);
      print(LOGTAG+" updateGeofence jsonbody->"+jsonBody.toString());

      Response response=await global.apiClass.UpdateGeofence(jsonBody);

      if(response!=null)
      {

        print(LOGTAG+" updateGeofence statusCode->"+response.statusCode.toString());
        print(LOGTAG+" updateGeofence body->"+response.body.toString());

        if (response.statusCode == 200)
        {
          var resBody = json.decode(response.body);
          global.lastFunction="updateGeofence";
          _onbackButtonPressed();
        }
        else if (response.statusCode == 400)
        {
          var resBody = json.decode(response.body);
          String status=resBody['status'];

          if(status.toString().contains("Geofence Doesn't Exist"))
          {
            global.helperClass.showAlertDialog(context, "", "Geofence Doesn't Exist", false, "");
          }
          else if(status.toString().contains("Geofence Update Failed"))
          {
            global.helperClass.showAlertDialog(context, "", "Geofence Update Failed", false, "");
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
  }



  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(
        Polygon(
          polygonId: PolygonId(polygonIdVal),
          points: listofLatLngs,
          strokeWidth: 4,
          strokeColor: global.darkGreyColor,
          fillColor: global.darkGreyColor.withOpacity(0.15),
        ));
  }



  void _setMarkers(LatLng point) async
  {
    final Uint8List markerIcon = await global.helperClass.getBytesFromAsset('assets/marker-icon.png', 20);
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      _markers.add(
        Marker(
            icon:  BitmapDescriptor.defaultMarker,
            markerId: MarkerId(markerIdVal),
            position: point,
            anchor: Offset(0.5,0.5)
        ),
      );
    });
  }

  Future<bool> _onbackButtonPressed()
  {
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context){

    final nameField = TextField(
      onTap: () {
        setState(() {nameValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: nameController,
      decoration:!nameValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5,), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.geofenceObject==null?"Name":widget.geofenceObject.name.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.geofenceObject==null?"Name":widget.geofenceObject.name.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );


    final descriptionField = TextField(
      onTap: () {
        setState(() {descValidate = false;});
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: descController,
      decoration:!descValidate? InputDecoration(
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.geofenceObject==null?"Description":widget.geofenceObject.description.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.geofenceObject==null?"Description":widget.geofenceObject.description.toString(),
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );


    return WillPopScope(
        onWillPop: _onbackButtonPressed,
        child: Scaffold(
            appBar:AppBar(
              titleSpacing: 0.0,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
//                      child:  new Text("Geofence Details",style: TextStyle(fontSize: global.font18, color: global.mainColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
//                  ),
                  Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child:new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child:  Container(
                                height: kToolbarHeight-10,
                                padding:  EdgeInsets.fromLTRB(15,0,0,0),
                                child: new Container(
                                    child: GestureDetector(
                                        onTap: (){_onbackButtonPressed();},
                                        child: new Container(
                                          height: 20,
                                          child:Image(image: AssetImage('assets/back-arrow.png')),
                                        )
                                    )
                                )
                            ),
                          )
                        ],
                      )
                  ),
                  Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: new Text("Geofence Details",style: TextStyle(fontSize: global.font18, color: global.mainBlackColor,fontWeight: FontWeight.w600,fontFamily: 'MulishRegular'))
                          ),
                        ],
                      )
                  ),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child:new Container()
                  )
                ],
              ),
              backgroundColor:global.screenBackColor,
            ),
            body:Container(
                color: global.screenBackColor,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child:SingleChildScrollView(

                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        widget.geofenceObject!=null?new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                child:new Text("Name :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                            ),
                          ],
                        ):new Container(width: 0,height: 0,),
                        SizedBox(height: 5,),
                        new Row(
                          children: <Widget>[
                            Flexible(
                                flex:1,
                                fit:FlexFit.tight,
                                child: new Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: SizedBox(
                                    height: 50,
                                    child: nameField,
                                  ),
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        widget.geofenceObject!=null?new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                child:new Text("Description :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                            ),
                          ],
                        ):new Container(width: 0,height: 0,),
                        SizedBox(height: 5,),
                        new Row(
                          children: <Widget>[
                            Flexible(
                                flex:1,
                                fit:FlexFit.tight,
                                child: new Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child:SizedBox(
                                    height: 50,
                                    child: descriptionField,
                                  ),
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child:  GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition:CameraPosition(
                              target: _center,
                              zoom: 10.0,
                            ),
                            polygons: _polygons,
                            markers: _markers,
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                              ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                              ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                              ..add(Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer())),
                            onTap: (point){
                              initialListOfLatLngs.add(point);
                              listofLatLngs.add(point);
                              setState(() {
                                _setMarkers(point);
                                _setPolygon();
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 15,),
                        widget.geofenceObject!=null?new Row(
                          children: <Widget>[

                            Flexible(
                              flex:1,
                              fit: FlexFit.tight,
                              child: new Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: new RaisedButton(
                                    onPressed: () {
                                      updateGeofence();
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                    color: Color(0xff2D9F4C),
                                    child:new Text('Update Geofence', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                                ),
                              ),
                            )
                          ],
                        ):new Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: new RaisedButton(
                              onPressed: () {
                                addGeofence();
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              color: Color(0xff2D9F4C),
                              child:new Text('Add Geofence', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                          ),
                        ),
                      ],
                    )
                )
            )
        )
    );
  }
}