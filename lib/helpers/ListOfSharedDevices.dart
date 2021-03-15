
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/helperClass/SharedDeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class ListOfSharedDevices extends StatefulWidget
{
  ListOfSharedDevices({Key key,this.index,this.sharedDeviceObject,this.onTabClicked}) : super(key: key);
  int index;
  ValueChanged<String> onTabClicked;
  SharedDeviceObject sharedDeviceObject;

  @override
  _ListOfSharedDevicesState createState() => _ListOfSharedDevicesState();
}

class _ListOfSharedDevicesState extends State<ListOfSharedDevices>
{

  String LOGTAG="ListOfSharedDevices";
  bool status = false;
  final tokenController=new TextEditingController();
  DeviceObjectAllAccount deviceObject;

  @override
  void initState(){
    super.initState();

    if(widget.sharedDeviceObject.token!=null)
    {
      String tokenData=global.sharedDevicePrefix.toString()+widget.sharedDeviceObject.token.toString();
      tokenController.text=tokenData;
    }

  }

  @override
  Widget build(BuildContext context) {

    final tokenField = TextField(

      style:TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      controller: tokenController,
      readOnly: true,
      decoration:InputDecoration(
        filled: true,
        fillColor: Color(0xffEffffff),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff2D9F4C),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xff2D9F4C),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        hintText: "Token",
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    return new Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Container(
            padding: EdgeInsets.fromLTRB(0,10,10,10),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: new BoxDecoration(
              color: global.whiteColor,
              border: Border.all(color:Color(0xffc4c4c4), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child:new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child:  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text((widget.index+1).toString(), style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                    ],
                  ),
                ),
                Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(widget.sharedDeviceObject.name.toString(), style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.w600,fontFamily: 'MulishRegular')),
                        SizedBox(height: 10,),
                        new Container(
                          child: tokenField,
                        )
                      ],
                    )
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          widget.onTabClicked("Delete");
                        },
                        child: new Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.fromLTRB(5,5,5,5),
                            // margin: EdgeInsets.fromLTRB(5,5,5,5),
                            //  width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                              color: global.transparent,
                              border: Border.all(color: Color(0xffc4c4c4),width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8.0),),
                            ),
                            child: new SvgPicture.asset('assets/delete-icon.svg',height: 20)
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}