import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/activities/GeofenceDetailsScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/GeofenceObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfGeofences.dart';


class GeofenceScreen extends StatefulWidget
{
  @override
  _GeofenceScreenState createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen>
{
  String LOGTAG="GeofenceScreen";

  List<GeofenceObject> listOfGeofence=new List();
  ScrollController _scrollController=new ScrollController();
  bool isResponseReceived=false;
  bool isGeofenceFound=false;

  @override
  void initState()
  {
    getGeofence();
    super.initState();


  }

  void getGeofence() async
  {
    listOfGeofence.clear();
    isResponseReceived=false;
    isGeofenceFound=false;
    setState(() {});

    Response response=await global.apiClass.GetGeofence();
    print(LOGTAG+" getGeofence response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" getGeofence statusCode->"+response.statusCode.toString());
      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" getGeofence->"+resBody.toString());

        int resLength=resBody.toString().length;

        if(resLength>40)
        {
          List<dynamic> payloadList = resBody;
          for (int i = 0; i < payloadList.length; i++)
          {
            int id = payloadList.elementAt(i)['id'];
            int geofenceid = payloadList.elementAt(i)['geofenceid'];
            String name = payloadList.elementAt(i)['name'];
            String description = payloadList.elementAt(i)['description'];
            List<dynamic> tempList = payloadList.elementAt(i)['area'];
            List<dynamic> latlngList = tempList.elementAt(0);
            AttributeClass attributeClass;

            var attr = payloadList.elementAt(i)['attributes'];

            Map sensorMap = json.decode(attr);
            for (var key in sensorMap.keys)
            {
              attributeClass = new AttributeClass(key, sensorMap[key]);
            }
            GeofenceObject geofenceObject = new GeofenceObject(id: id, geofenceid: geofenceid, name: name, description: description, area: latlngList, attributes: attributeClass);
            listOfGeofence.add(geofenceObject);
          }

          isResponseReceived = true;
          if (listOfGeofence.length > 0)
          {
            isGeofenceFound = true;
          }
          setState(() {});
        }
        else
        {
          String status=resBody['status'];
          if(status.toString().compareTo("Geofences not found")==0)
          {
            isResponseReceived=true;
            isGeofenceFound=false;
            setState(() {});
          }

        }
      }
      else if (response.statusCode == 500)
      {
        global.helperClass.showAlertDialog(context, "", "Internal Server Error", false, "");
        isResponseReceived=true;
        isGeofenceFound=false;
        setState(() {});
      }
    }
    else
    {
      global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, "");
      isResponseReceived=true;
      isGeofenceFound=false;
      setState(() {});
    }
  }

  void onTabClicked(int index, GeofenceObject geofenceObject) async
  {

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GeofenceDetailsScreen(index: index,geofenceObject: geofenceObject,))).then((value) => ({

      if(global.lastFunction.toString().contains("addGeofence"))
        {
          global.helperClass.showAlertDialog(context, "", "Geofence added successfully", false, "")
        }
      else if(global.lastFunction.toString().contains("updateGeofence")){
        global.helperClass.showAlertDialog(context, "", "Geofence updated successfully", false, "")
      },

      getGeofence()
    }));
  }

  void deleteGeofence(GeofenceObject geofenceObject,int index) async
  {
    isResponseReceived=false;
    setState(() {});

    int id=geofenceObject.id;

    Response response=await global.apiClass.DeleteGeofence(id.toString());
    print(LOGTAG+" deleteGeofence response->"+response.toString());

    if(response!=null)
    {
      print(LOGTAG+" deleteGeofence statusCode->"+response.statusCode.toString());
      print(LOGTAG+" deleteGeofence body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        print(LOGTAG+" deleteGeofence->"+resBody.toString());
        listOfGeofence.removeAt(index);
        if(listOfGeofence.length==0)
        {
          isGeofenceFound=false;
        }
        isResponseReceived=true;
        setState(() {});
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

  void deleteConfirmationPopup(GeofenceObject geofenceObject,int index)
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
                          new Text("Are you sure you want to delete the \'"+geofenceObject.name.toString()+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xffdcdcdc), width: 1.0,),
                        ),
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
                                    deleteGeofence(geofenceObject,index);
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
              !isGeofenceFound?new Stack(
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
                          flex:2,
                          fit:FlexFit.tight,
                          child:
                          new Column(
                            children: <Widget>[
                              Flexible(
                                flex:1,
                                fit:FlexFit.tight,
                                child:new Container(
                                    padding: EdgeInsets.all(10),
                                    child:new SvgPicture.asset('assets/geofence-not-found.svg')
                                ),
                              ),
                              new Container(
                                color: global.screenBackColor,
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: new Text('No Geofence Added Yet', style: TextStyle(fontSize: global.font16, color: Color(0xff30242A),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                              )
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
                                  child: ListOfGeofences(index: index, geofenceObject: listOfGeofence[index],onTabCicked: (flag){

                                    if(flag.toString().compareTo("Edit")==0)
                                    {
                                      onTabClicked(index, listOfGeofence[index]);
                                    }
                                    else if(flag.toString().compareTo("Delete")==0){
                                      deleteConfirmationPopup(listOfGeofence[index], index);
                                    }

                                  },
                                  ),
                                );
                              }, childCount: listOfGeofence.length)
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
        )
    );
  }
}
