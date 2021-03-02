import 'dart:async';
import 'package:thingsuptrackapp/activities/SignIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:open_mail_app/open_mail_app.dart';

class ForgetPasswordCheck extends StatefulWidget
{
  @override
  _ForgetPasswordCheckState createState() => _ForgetPasswordCheckState();
}

class _ForgetPasswordCheckState extends State<ForgetPasswordCheck> with WidgetsBindingObserver
{
  String LOGTAG="ForgetPasswordCheck";
  bool isMailAppOpened=false;
  Timer switchTimer;

  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if(state == AppLifecycleState.resumed)
    {
      if(isMailAppOpened)
      {
        switchTimer=Timer.periodic(Duration(milliseconds:200), (timer)
        {
          if(switchTimer.isActive)
          {
            switchTimer.cancel();
          }
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SignIn()));
        });
      }
    }
  }

  void openEmailApp() async
  {
    var result = await OpenMailApp.openMailApp(nativePickerTitle: 'Select email app to open',);
    if (!result.didOpen && !result.canOpen)
    {
      global.helperClass.showAlertDialog(context, "", "No mail apps found", false, "");
    }
    else if (!result.didOpen && result.canOpen)
    {
      showDialog(
        context: context,
        builder: (_) {
          return MailAppPickerDialog(
            mailApps: result.options,
          );
        },
      );
    }
    else
    {
      isMailAppOpened=true;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        titleSpacing: 0.0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding:  EdgeInsets.fromLTRB(15,0,0,0),
                child:  GestureDetector(
                  onTap: (){Navigator.of(context).pop();},
                  child: new Container(
                    height: 25,
                    child:Image(image: AssetImage('assets/back-arrow.png')),
                  )
                )
            ),
          ],
        ),
        backgroundColor:global.screenBackColor,
      ),
      body: new Container(
          color: global.screenBackColor,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child:new Column(
            children: <Widget>[
              Flexible(
                flex:1,
                fit: FlexFit.tight,
                child: new Row(
                  children: <Widget>[
                    Flexible(
                      flex:1,
                      fit:FlexFit.tight,
                      child: new Container(),
                    ),
                    Flexible(
                      flex:1,
                      fit:FlexFit.tight,
                      child:  new Container(
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(border: Border.all(width: 0.0,color:Color(0xff3C74DC)), color: global.mainColor, borderRadius: BorderRadius.all(Radius.circular(22.0)),
                        ),
                        child:new Container(
                          child:Image(image: AssetImage('assets/check-mail-icon.png')),
                        )
                      ),
                    ),
                    Flexible(
                      flex:1,
                      fit:FlexFit.tight,
                      child: new Container(),
                    )
                  ],
                ),
              ),
              Flexible(
                  flex:3,
                  fit: FlexFit.tight,
                  child:new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      new Text('Check your mail', style: TextStyle(fontSize: global.font22, color: Color(0xff3F414E),fontWeight: FontWeight.normal,fontFamily: 'PoppinsBold')),
                      SizedBox(height: 20,),
                      new Text('We have sent a password recover instructions to your email', textAlign:TextAlign.center,style: TextStyle(fontSize: global.font14, color: Color(0xff3F414E),fontWeight: FontWeight.normal,fontFamily: 'PoppinsRegular')),
                    ],
                  )
              ),
              Flexible(
                  flex:1,
                  fit: FlexFit.tight,
                  child:new Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: new RaisedButton(
                              onPressed: () {  openEmailApp(); },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                              color: global.mainColor,
                              child:new Text('Open email app', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'PoppinsRegular'))
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ],
          )
      ),
    );
  }
}
