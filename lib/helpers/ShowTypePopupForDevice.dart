import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter/rendering.dart';

class ShowTypePopupForDevice extends StatefulWidget
{
  ShowTypePopupForDevice({Key key,this.selectedType}) : super(key: key);
  ValueChanged< String> selectedType;

  @override
  ShowTypePopupForDeviceState createState() => ShowTypePopupForDeviceState();
}

class ShowTypePopupForDeviceState extends State<ShowTypePopupForDevice>
{
  String LOGTAG="ShowTypePopupForDevice";
  List <String> deviceTypeList = ['animal','bicycle','boat','box','bus','car','container','crane','default','freezer','helicopter','home','motorcycle','navigation','offroad','person','pickup','plane','rickshow','room','scooter','ship','tank','tanker','tractor','train','tram','tree','truck','van','warehouse'];
  String selectedVar="";

  void updateUI(String selectedVar)
  {
    widget.selectedType(selectedVar);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context)
  {
    return new Row(
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
                  deviceTypeList.length>0?SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: deviceTypeList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return  GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap:(){
                              selectedVar=deviceTypeList[index].toString();
                              updateUI(selectedVar);
                            },
                            child: new Container(
                                child: Container(
                                    decoration:BoxDecoration(
                                      border: Border(bottom: BorderSide(color: global.textLightGreyColor, width: 0.5,),),
                                    ),
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
                                                child: new Text(deviceTypeList[index].toString(), style: TextStyle(fontSize: global.font16,color:Color(0xff414141),fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),),
                                              ),
                                              new Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child:new Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Opacity(
                                                          opacity: 0,
                                                          child:  Checkbox(
                                                            onChanged: (bool flag) {
                                                            },
                                                            value: false,
                                                          ),
                                                        )
                                                      ]
                                                  )
                                              )
                                            ],
                                          )
                                        ]
                                    )
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
    );
  }
}