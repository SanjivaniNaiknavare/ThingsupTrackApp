import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter/rendering.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';

class ShowDevicePopupForUser extends StatefulWidget
{
  ShowDevicePopupForUser({Key key,this.deviceList,this.selectedDeviceList,this.selectedDevices}) : super(key: key);
  List<DeviceObjectOwned> deviceList;
  List<String> selectedDeviceList;
  ValueChanged< List<String>> selectedDevices;

  @override
  ShowDevicePopupForUserState createState() => ShowDevicePopupForUserState();
}

class ShowDevicePopupForUserState extends State<ShowDevicePopupForUser>
{
  String LOGTAG="ShowDevicePopupForUser";
  List<String> selectedDeviceList=new List();

  @override
  void initState(){
    super.initState();

    if(widget.selectedDeviceList.length>0)
    {
      selectedDeviceList.addAll(widget.selectedDeviceList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        new Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child:new Column(
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
                          new Text("Select devices", style: TextStyle(fontSize: global.font18,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishSemiBold')),
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
                            onTap:(){Navigator.of(context).pop();},
                            child:  new Container(
                              height:20,
                              width:20,
                              child:Image(image: AssetImage("assets/close-red-icon.png")),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: global.popupBackColor,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(0,10, 0, 10),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              widget.deviceList.length>0?SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  itemCount: widget.deviceList.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {

                                    bool _secValue=false;
                                    if(widget.selectedDeviceList.length!=0)
                                    {
                                      if(selectedDeviceList.contains(widget.deviceList.elementAt(index).uniqueid))
                                      {
                                        _secValue=true;
                                      }
                                    }
                                    else
                                    {
                                      if (selectedDeviceList.contains(widget.deviceList.elementAt(index).uniqueid))
                                      {
                                        _secValue = true;
                                      }
                                    }
                                    return new Container(
                                        child: Container(
                                            decoration:BoxDecoration(border: Border(bottom: BorderSide(color: global.textLightGreyColor, width: 0.5,),),),
                                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            margin: EdgeInsets.fromLTRB(0,0, 15, 0),
                                            child: new Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Flexible(
                                                          flex: 3,
                                                          fit: FlexFit.tight,
                                                          child:new Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              new Text(widget.deviceList.elementAt(index).uniqueid.toString()+"["+widget.deviceList.elementAt(index).name.toString()+"]", style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),)
                                                            ],
                                                          )
                                                      ),
                                                      new Flexible(
                                                          flex: 1,
                                                          fit: FlexFit.tight,
                                                          child:new Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[
                                                                Checkbox(
                                                                  onChanged: (bool flag) {
                                                                    _secValue=flag;
                                                                    String currentname=widget.deviceList.elementAt(index).uniqueid.toString();
                                                                    if(flag)
                                                                    {
                                                                      if(!selectedDeviceList.contains(currentname))
                                                                      {
                                                                        selectedDeviceList.add(currentname);
                                                                      }
                                                                    }
                                                                    else
                                                                    {
                                                                      print(selectedDeviceList);
                                                                      if(selectedDeviceList.contains(currentname))
                                                                      {
                                                                        selectedDeviceList.remove(currentname);
                                                                      }
                                                                    }
                                                                    setState(() {});
                                                                  },
                                                                  value: _secValue,
                                                                ),
                                                              ]
                                                          )
                                                      )
                                                    ],
                                                  )
                                                ]
                                            )
                                        )
                                    );
                                  },
                                ),
                              ):new Container(width: 0,height: 0,),
                              SizedBox(height: 10,),
                            ],
                          )
                      ),
                    ),
                  ],
                )
              ],
            )
        ),
        SizedBox(height: 20,),
        new Container(
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xffdcdcdc), width: 1.0,),),),
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
                      child: Text("Cancel", style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
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
                      child: Text("OK", style: TextStyle(fontSize: global.font16,color:global.mainColor,fontStyle: FontStyle.normal)),
                      onPressed: () async {
                        widget.selectedDevices(selectedDeviceList);
                      },
                    )
                  ],
                )
            )
          ],
        ),
      ],
    );
  }
}