import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class HelperClass
{
  String LOGTAG="HelperClass";

  void setFonts(double dpr, double height)
  {
    double unitHeightValue;
    if (dpr <= 2.5)
    {
      unitHeightValue = 2.5;
    }
    else
    {
      if (height < 700)
      {
        unitHeightValue = 2.4;
      }
      else
      {
        unitHeightValue = 2.6;
      }
    }

    double mul12 = 4.8;
    double mul13 = 5.0;
    double mul14 = 5.5;
    double mul15 = 5.8;
    double mul16 = 6.4;
    double mul18 = 7;
    double mul20 = 7.5;

    global.font12 = mul12 * unitHeightValue;
    global.font13 = mul13 * unitHeightValue;
    global.font14 = mul14 * unitHeightValue;
    global.font15 = mul15 * unitHeightValue;
    global.font16 = mul16 * unitHeightValue;
    global.font18 = mul18 * unitHeightValue;
    global.font20 = mul20 * unitHeightValue;

  }


  bool isValidEmail(String emailAddress)
  {
    bool flag = false;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailAddress);
    flag = emailValid;
    return flag;
  }

  showAlertDialog(BuildContext context, String title, String msg,bool openSetting,String type)
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
                          new Text(msg, maxLines:3,textAlign: TextAlign.center,style: TextStyle(fontSize: global.font16,color:global.textLightGreyColor,fontStyle: FontStyle.normal)),
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



}