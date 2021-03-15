import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/activities/DriverDetailsScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helperClass/DriverObject.dart';
import 'package:thingsuptrackapp/helpers/ListOfDrivers.dart';



class DriverScreen extends StatefulWidget
{
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen>
{
  String LOGTAG="DriverScreen";

  List<DriverObject> listOfDrivers=new List();
  List<DriverObject> currentlistOfDrivers=new List();
  ScrollController _scrollController=new ScrollController();
  bool isResponseReceived=false;
  bool isDriverFound=false;

  @override
  void initState()
  {
    getDrivers();
    super.initState();
  }


  void getDrivers() async
  {
    isResponseReceived=false;
    isDriverFound=false;
    listOfDrivers.clear();
    currentlistOfDrivers.clear();
    global.myUsers.clear();
    if(mounted){
      setState(() {});
    }

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
            listOfDrivers.add(driverObject);
          }
          isResponseReceived = true;
          if (listOfDrivers.length > 0)
          {
            isDriverFound = true;
            currentlistOfDrivers.addAll(listOfDrivers);
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
            isDriverFound = false;
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

  void onTabClicked(int index, DriverObject driverObject) async
  {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DriverDetailsScreen(index: index,driverObject: driverObject))).then((value) => ({

      if(global.lastFunction.toString().contains("addDriver")){
        global.helperClass.showAlertDialog(context, "", "Driver added successfully", false, "")
      }
      else if(global.lastFunction.toString().contains("updateDriver")){
        global.helperClass.showAlertDialog(context, "", "Driver updated successfully", false, "")
      },
      getDrivers()
    }));
  }


  void deleteConfirmationPopup(DriverObject driverObject,int selindex)
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
                          new Text("Are you sure you want to delete the \'"+driverObject.name.toString()+"\'?", maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
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
                                    deleteDriver(driverObject,selindex);
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

  void deleteDriver(DriverObject driverObject,int index) async
  {
    isResponseReceived=false;
    if(mounted){
      setState(() {});
    }

    Response response=await global.apiClass.DeleteDriver(driverObject.id);
    if(response!=null)
    {
      print(LOGTAG+" deleteDriver statusCode->"+response.statusCode.toString());
      print(LOGTAG+" deleteDriver body->"+response.body.toString());

      if (response.statusCode == 200)
      {
        var resBody = json.decode(response.body);
        int finalIndex=0;
        for(int s=0;s<listOfDrivers.length;s++)
        {
          DriverObject dObj=listOfDrivers.elementAt(s);
          if(dObj.id.compareTo(driverObject.id)==0)
          {
            finalIndex=s;
          }
        }
        listOfDrivers.removeAt(finalIndex);
        currentlistOfDrivers.removeAt(index);
        isResponseReceived=true;
        currentlistOfDrivers.clear();
        currentlistOfDrivers.addAll(listOfDrivers);
        if(currentlistOfDrivers.length==0)
        {
          isDriverFound=false;
        }
        if(mounted){
          setState(() {});
        }
        global.helperClass.showAlertDialog(context, "", "Driver deleted successfully", false, "");

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


  void sortList(String searchSTR) async
  {
    currentlistOfDrivers.clear();
    for(int k=0;k<listOfDrivers.length;k++)
    {
      DriverObject driverObject=listOfDrivers.elementAt(k);
      if(driverObject.name.toString().toLowerCase().contains(searchSTR.toString().toLowerCase()))
      {
        currentlistOfDrivers.add(driverObject);
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
              !isDriverFound?new Stack(
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
                                child: new Text('No Driver Added Yet', style: TextStyle(fontSize: global.font16, color: global.mainBlackColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
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
                                    child:new Text('Add Driver',textAlign: TextAlign.center, style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
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
                                                hintText: ' Search Driver By Name',
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
                                  child: ListOfDrivers(index: index, driverObject: currentlistOfDrivers[index],onTabCicked: (flag){
                                    if(flag.toString().compareTo("Edit")==0)
                                    {
                                      onTabClicked(index, currentlistOfDrivers[index]);
                                    }
                                    else if(flag.toString().compareTo("Delete")==0)
                                    {
                                      deleteConfirmationPopup(currentlistOfDrivers[index],index);
                                    }
                                  },
                                  ),
                                );
                              }, childCount: currentlistOfDrivers.length)
                          )
                        ]
                    ),
                  )
                ],
              )
          ):new Container(
              color: global.screenBackColor,
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
