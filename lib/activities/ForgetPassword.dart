import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'ForgetPasswordCheck.dart';

class ForgetPassword extends StatefulWidget
{
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
{
  String LOGTAG="ForgetPassword";
  bool emailadd_validate=false;
  String emailaddress;
  final emailController = TextEditingController();
  bool isResponseReceived=true;

  @override
  void initState()
  {
    super.initState();
  }

  void resetPassword()
  {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    emailaddress=emailController.text;

    if(emailaddress.isEmpty || emailaddress==" " || emailaddress.length==0 )
    {
      emailadd_validate=true;
    }
    setState(() { });

    if(!emailadd_validate)
    {
      if (global.helperClass.isValidEmail(emailaddress))
      {
        setState(() { isResponseReceived=false; });

        global.firebaseInstance.sendPasswordResetEmail(email: emailaddress).then((value) => ({

          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ForgetPasswordCheck())).then((value) => ({
            setState(() { isResponseReceived=true; }),
          }))

        })).catchError((err) =>({

          setState(() { isResponseReceived=true; }),
          if(err.toString().contains("firebase_auth/user-not-found"))
            {
              global.helperClass.showAlertDialog(context, "", "User not found", false, ""),
            },
          if(err.toString().contains("firebase_auth/unknown"))
            {
              global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, ""),
            },
        }));
      }
      else
      {
        global.helperClass.showAlertDialog(context, "", "Please provide valid email address", false, "");
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final emailaddressField = TextField(
      onTap: () {
        setState(() {  emailadd_validate = false; });
      },
      style:TextStyle( color:Color.fromRGBO(0, 0, 0, 0.87),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      cursorColor: global.mainColor,
      obscureText: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: !emailadd_validate?InputDecoration(
        filled: true,
        fillColor: Color(0xffF7F7F7),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Color(0xff819BD0),), borderRadius: BorderRadius.circular(12.0),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Color(0xff819BD0)), borderRadius: BorderRadius.circular(12.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        hintText: "Email address",
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5,color: Color(0xffBF4C4C),), borderRadius: BorderRadius.circular(12.0),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5,color: Color(0xffc0c0c0)), borderRadius: BorderRadius.circular(12.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        hintText: "Email address",
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                    onTap: (){  Navigator.of(context).pop(); },
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
      body: isResponseReceived?new Container(
          color: global.screenBackColor,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child:new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 25,),
              new Text('Forget Password', style: TextStyle(fontSize: global.font22, color: Color(0xff3F414E),fontWeight: FontWeight.normal,fontFamily: 'MulishSemiBold')),
              SizedBox(height: 20,),
              new Text('Enter the email associated with your account and we’ll send an email with instructions to reset your password.', style: TextStyle(fontSize: global.font15, color: Color(0xff3F414E),fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                child: emailaddressField,
              ),
              SizedBox(height: 20,),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: new RaisedButton(
                    onPressed: () { resetPassword(); },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                    color: global.mainColor,
                    child:new Text('SUBMIT', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'MulishRegular'))
                ),
              ),
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
    );
  }
}