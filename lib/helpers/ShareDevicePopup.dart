import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/helperClass/APIRequestBodyClass.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:url_launcher/url_launcher.dart';

class ShareDevicePopup extends StatefulWidget
{
  ShareDevicePopup({Key key,this.deviceObjectAllAccount}) : super(key: key);
  DeviceObjectAllAccount deviceObjectAllAccount;

  @override
  ShareDevicePopupState createState() => ShareDevicePopupState();
}

class ShareDevicePopupState extends State<ShareDevicePopup>
{
  String LOGTAG="ShareDevicePopup";

  bool timeValidate=false;
  String selectedTime;
  bool isResponseReceived=true;
  bool isDeviceShared=false;
  bool isLinkCopied=false;
  final deviceController=new TextEditingController();
  List<String> intervalList=["15 min","1 hr","3 hrs","8 hrs","24 hrs"];
  final key = new GlobalKey<ShareDevicePopupState>();
  double popupHeight=200;

  @override
  void initState(){
    super.initState();

    deviceController.text=widget.deviceObjectAllAccount.name.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) => getHeight());
    setState(() {});
  }
  void getHeight() {

    final BuildContext context = key.currentContext;
    if(context.size.height!=null)
    {
      if(context.size.height!=0)
      {
        popupHeight=context.size.height;
      }
    }
    print(context.size.height);
  }

  void shareDevice()async
  {
    isResponseReceived=false;
    setState(() {});
    if(selectedTime==null)
    {
      global.helperClass.showAlertDialog(context, "", "Please select time interval", false, "");
    }
    else
    {

      if(selectedTime.isEmpty || selectedTime==" " || selectedTime.length==0)
      {
        global.helperClass.showAlertDialog(context, "", "Please select time interval", false, "");
      }
      else
      {
        int interval=0;

        if(selectedTime.toString().compareTo("15 min")==0)
        {
          interval=15*60;
        }
        else if(selectedTime.toString().compareTo("1 hr")==0)
        {
          interval=60*60;
        }
        else if(selectedTime.toString().compareTo("3 hrs")==0)
        {
          interval=3*60*60;
        }
        else if(selectedTime.toString().compareTo("8 hrs")==0)
        {
          interval=8*60*60;
        }
        else if(selectedTime.toString().compareTo("24 hrs")==0)
        {
          interval=24*60*60;
        }

        SharingDeviceClass sharingDeviceClass = new SharingDeviceClass(uniqueid: widget.deviceObjectAllAccount.uniqueid, interval:interval);
        var jsonBody = jsonEncode(sharingDeviceClass);
        print(LOGTAG + " shareDevice jsonbody->" + jsonBody.toString());

        Response response = await global.apiClass.CreateSharingToken(jsonBody);
        if (response != null)
        {
          print(LOGTAG + " shareDevice statusCode->" + response.statusCode.toString());
          print(LOGTAG + " shareDevice body->" + response.body.toString());

          if (response.statusCode == 200)
          {
            var resBody=json.decode(response.body);
            String token=resBody['token'];
            isDeviceShared=!isDeviceShared;
            deviceController.text=global.sharedDevicePrefix.toString()+token.toString();

            isResponseReceived=true;
            setState(() {});
          }
          else if (response.statusCode == 400)
          {
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
    }
  }

  _launchURL(String url) async
  {
    if (await canLaunch(url))
    {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {

    final deviceField = TextField(
        enabled: false,
        textInputAction: TextInputAction.done,
        style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
        cursorColor: global.mainColor,
        obscureText: false,
        controller: deviceController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffffffff),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffc4c4c4),width: 0.5), borderRadius: BorderRadius.circular(8.0),),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: widget.deviceObjectAllAccount==null?"Device ID":widget.deviceObjectAllAccount.name.toString(),
          hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
        )
    );



    return isResponseReceived? new Container(
        key: key,
        padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
        width: MediaQuery.of(context).size.width,
        child:
        new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              !isDeviceShared?new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      child:new Text("Device ID :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                  ),
                ],
              ):new Container(width: 0,height: 0,),
              SizedBox(height: 5,),

              new Container(
                height:50,
                width: MediaQuery.of(context).size.width,
                child: deviceField,
              ),
              SizedBox(height: 10,),
              !isDeviceShared?new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      child:new Text("Interval :",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                  ),
                ],
              ):new Container(width: 0,height: 0,),
              SizedBox(height: 5,),
              !isDeviceShared?Flexible(
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 10.0, right: 15.0),
                    decoration: !timeValidate?BoxDecoration(borderRadius: BorderRadius.circular(10.0), color:global.transparent, border: Border.all(color:Color(0xffc4c4c4),width: 0.5)):BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: global.errorTextFieldFillColor, border: Border.all(color:Color(0xffc4c4c4),width: 0.5,)),
                    child: new DropdownButtonHideUnderline(
                        child: new DropdownButton<String>(
                            hint: Text('Select Interval',style: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular')),
                            isExpanded: true,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            value: selectedTime,
                            items: intervalList.map((String value) {
                              return new DropdownMenuItem<String>(
                                  value: value,
                                  child:
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          value,
                                          style: TextStyle(fontSize: global.font15,color:global.darkBlack,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ]
                                  )
                              );
                            }).toList(),
                            onChanged: (newval)
                            {
                              timeValidate = false;
                              setState(() {selectedTime = newval;});
                            }
                        )
                    )
                ),
              ):new Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: (){

                        final Uri params = Uri(
                          scheme: 'mailto',
                          //path: 'email@example.com',
                          query: 'subject=Track App Shared Device Link &body='+deviceController.text.toString(), //add subject and body here
                        );

                        var url = params.toString();
                        _launchURL(url.toString());

                      },
                      child: new Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(8,8,8,8),
                          margin: EdgeInsets.fromLTRB(5,5,0,5),
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                            color: global.transparent,
                            border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(8.0),),
                          ),
                          child: new SvgPicture.asset('assets/share-mail-icon.svg')
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: (){

                        _launchURL("whatsapp://send?text="+deviceController.text.toString()+" &phone=");

                      },
                      child: new Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(8,8,8,8),
                          margin: EdgeInsets.fromLTRB(5,5,0,5),
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                            color: global.transparent,
                            border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(8.0),),
                          ),
                          child: new SvgPicture.asset('assets/share-whatsapp-icon.svg')
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: (){
                        String urlData="https://twitter.com/intent/tweet?url="+deviceController.text.toString();
                        _launchURL(urlData);
                        //_launchURL("https://twitter.com/intent/tweet?url=https://dev.track.thingsup.io/livedata?token=a73UPGpbNF");
                      },
                      child: new Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(8,8,8,8),
                          margin: EdgeInsets.fromLTRB(5,5,0,5),
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                            color: global.transparent,
                            border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(8.0),),
                          ),
                          child: new SvgPicture.asset('assets/share-twitter-icon.svg')
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: (){
                        String urlData="https://www.facebook.com/sharer/sharer.php?u="+deviceController.text.toString();
                        _launchURL(urlData);
                        //_launchURL("https://www.facebook.com/sharer/sharer.php?u=https://dev.track.thingsup.io/livedata?token=a73UPGpbNF");
                      },
                      child: new Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(8,8,8,8),
                          margin: EdgeInsets.fromLTRB(5,5,0,5),
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                            color: global.transparent,
                            border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(8.0),),
                          ),
                          child: new SvgPicture.asset('assets/share-fb-icon.svg')
                      ),
                    ),
                  )
                ],
              ),
              isLinkCopied?SizedBox(height: 10,):new Container(width: 0,height: 0,),
              isLinkCopied?new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      child:new Text("Link Copied",style: new TextStyle(fontSize: global.font12, color: Color.fromRGBO(18, 18, 18, 0.7), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                  ),
                ],
              ):new Container(width: 0,height: 0,),
              SizedBox(height: 20,),
              new Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: new RaisedButton(
                    onPressed: () {
                      if(!isDeviceShared)
                      {
                        shareDevice();
                      }
                      else {
                        Clipboard.setData(ClipboardData(text: deviceController.text)).then((value) {
                          isLinkCopied=true;
                          setState(() {});
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    color: Color(0xff2D9F4C),
                    child:!isDeviceShared?new Text('Share', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')):
                    new Text('Copy Link', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                ),
              ),
            ]
        )
    ):new Container(
        height: popupHeight,
        child:Center(
          child:new Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(global.secondaryBlueColor),
              backgroundColor: global.lightGreyColor,
              strokeWidth: 5,),
          ),
        )
    );
  }
}