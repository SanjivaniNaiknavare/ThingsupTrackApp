import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/activities/AllAPIScreen.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'ForgetPassword.dart';
import 'dart:convert';

class SignIn extends StatefulWidget
{
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn>
{
  String LOGTAG="SignIn";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String emailaddress = "";
  String password="";

  bool emailadd_validate = false;
  bool password_validate = false;
  bool isResponseReceived=true;
  bool obscureText=true;


  bool forgetPassVis=true;

  @override
  void initState()
  {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }


  void login() async
  {

    SharedPreferences prefs;
    String idToken="";
    String token="";
    String decodedUserJson="";
    List<String> idTokenList;
    int decodelength=0;
    int modData=0;
    var resBody;
    emailaddress=emailController.text;
    password=passwordController.text;

    if(emailaddress.isEmpty || emailaddress==" " || emailaddress.length==0)
    {
      emailadd_validate=true;
    }
    if (password.isEmpty || password==" " || password.length==0)
    {
      password_validate = true;
    }

    setState(() { });

    if(!emailadd_validate && !password_validate)
    {
      if(global.helperClass.isValidEmail(emailaddress))
      {
        setState(() { isResponseReceived=false; });

        global.firebaseInstance.signInWithEmailAndPassword(email: emailaddress, password: password).then((currentUser) async =>
        {
          print(LOGTAG+" userToken->"+currentUser.toString()),

          idToken=await currentUser.user.getIdToken(true),
          global.idToken=idToken,

          print(LOGTAG+"idToken->"+idToken.toString()),

          idTokenList=idToken.split("."),

          print(LOGTAG+" idTokenList length->"+idTokenList.length.toString()),

          decodelength=idTokenList[1].length,

          print(LOGTAG+" decodelength->"+decodelength.toString()),

          if(decodelength%4!=0)
            {
              modData=decodelength%4,
              for(int k=0;k<modData;k++)
                {
                  idTokenList[1]=idTokenList[1]+"=",
                }
            },



//          decodedUserJson = utf8.decode(base64.decode(idTokenList[1])),
//          print(LOGTAG+" decodedUserJson->"),
//          print(decodedUserJson),
//          resBody=json.decode(decodedUserJson.toString()),
//
//          global.userRole=resBody["role"],
//          global.userID=resBody["user_id"],
//
          prefs = await SharedPreferences.getInstance(),
          prefs.setBool("LoggedInStatus",true),
          setState(() { isResponseReceived=false; }),

          print(LOGTAG+" just before home screen called"),

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()))

        }).catchError((err) => ({

          setState(() { isResponseReceived=true; }),

          if(err.toString().contains("firebase_auth/user-not-found"))
            {
              global.helperClass.showAlertDialog(context, "", "User with given email address and password not found", false, ""),
            },

          if(err.toString().contains("firebase_auth/wrong-password"))
            {
              global.helperClass.showAlertDialog(context, "", "Incorrect Password", false, ""),
            },

          if(err.toString().contains("firebase_auth/unknown"))
            {
              global.helperClass.showAlertDialog(context, "", "Please check internet connection", false, ""),
            }

        }));
      }
      else
      {
        global.helperClass.showAlertDialog(context, "", "Please provide valid email address", false, "");
      }
    }

  }

  void forgetPassword()
  {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ForgetPassword()));
  }




  @override
  Widget build(BuildContext context) {

    final emailaddressField = TextField(
      onTap: () {
        setState(() { emailadd_validate = false; });
      },
      style:TextStyle( color:Color.fromRGBO(0, 0, 0, 0.87),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'PoppinsRegular'),
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
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'PoppinsRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5,color: Color(0xffBF4C4C),), borderRadius: BorderRadius.circular(12.0),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5,color: Color(0xffc0c0c0)), borderRadius: BorderRadius.circular(12.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        hintText: "Email address",
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'PoppinsRegular'),
      ),
    );

    final passwordField = TextField(
      onTap: () {
        setState(() { password_validate = false; });
      },
      style:TextStyle( color:Color.fromRGBO(0, 0, 0, 0.87),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'PoppinsRegular'),
      keyboardType: TextInputType.text,
      cursorColor: global.mainColor,
      obscureText: obscureText,
      controller: passwordController,
      decoration:!password_validate?InputDecoration(
        suffixIcon:IconButton(
          icon: Icon(
            !obscureText ? Icons.visibility : Icons.visibility_off,
            color: global.darkGreyColor,
          ),
          onPressed: () { setState(() { obscureText = !obscureText; }); },
        ),
        filled: true,
        fillColor: Color(0xffF7F7F7),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Color(0xff819BD0),), borderRadius: BorderRadius.circular(12.0),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Color(0xff819BD0)), borderRadius: BorderRadius.circular(12.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        hintText: "Password",
        hintStyle: TextStyle( color:Color.fromRGBO(0, 0, 0, 0.4),fontSize:global.font14,fontStyle: FontStyle.normal,fontFamily: 'PoppinsRegular'),
      ):InputDecoration(
        filled: true,
        fillColor: global.errorTextFieldFillColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5,color: Color(0xffBF4C4C),), borderRadius: BorderRadius.circular(12.0),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5,color: Color(0xffc0c0c0)), borderRadius: BorderRadius.circular(12.0),),
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        hintText: "Password",
        hintStyle: TextStyle(fontSize: global.font15,color:global.popupDarkGreyColor,fontStyle: FontStyle.normal,fontFamily: 'PoppinsRegular'),
      ),
    );

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar:
        PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child:
          AppBar(title: new Text(""),
            backgroundColor: global.screenBackColor,
            elevation: 0,
          ),
        ),
        body: isResponseReceived? new Container(
            height:MediaQuery.of(context).size.height,
            color: global.screenBackColor,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SingleChildScrollView(
                child: new Stack(
                  children: <Widget>[
                    new Container(
                        height:MediaQuery.of(context).size.height,
                        child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                  flex:2,
                                  fit:FlexFit.tight,
                                  child: new Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          flex:2,
                                          fit: FlexFit.tight,
                                          child:new Row(
                                            children: <Widget>[
                                              Flexible(
                                                flex:1,
                                                fit: FlexFit.tight,
                                                child: new Container(),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child: new Container(
                                                    decoration: new BoxDecoration(
                                                      image: new DecorationImage(
                                                        image: ExactAssetImage('assets/Splash_screen_logo.png'),
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    )
                                                ),
                                              ),
                                              Flexible(
                                                flex:1,
                                                fit: FlexFit.tight,
                                                child: new Container(),
                                              )
                                            ],
                                          ),
                                        ),
                                        new Flexible(
                                          flex:1,
                                          fit: FlexFit.tight,
                                          child:new Container(
                                              child:new Text("Welcome Back",style: TextStyle(fontSize: global.font22, color: Color(0xff3F414E),fontWeight: FontWeight.normal,fontFamily: 'PoppinsBold'))
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                              Flexible(
                                  flex:5,
                                  fit:FlexFit.tight,
                                  child:
                                  new Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 50,
                                          child: emailaddressField,
                                        ),
                                        SizedBox(height: 15,),
                                        SizedBox(
                                          height: 50,
                                          child: passwordField,
                                        ),
                                        SizedBox(height:20,),
                                        new Container(width: 0,height: 0,),
                                        Container(
                                          height: 45,
                                          width: MediaQuery.of(context).size.width,
                                          child: new RaisedButton(
                                              onPressed: () {
                                                login();
                                              },
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                                              color: global.mainColor,
                                              child:new Text('LOGIN', style: TextStyle(fontSize: global.font14, color: global.whiteColor,fontWeight: FontWeight.normal,fontFamily: 'PoppinsSemiBold'))

                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){ forgetPassword(); },
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                              child: new Text('Forget Password?', style: TextStyle(fontSize: global.font14, color: Color(0xff3F414E),fontWeight: FontWeight.normal,fontFamily: 'PoppinsRegular'),
                                              )),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                              Flexible(
                                flex:2,
                                fit:FlexFit.tight,
                                child:  new Container(

                                ),
                              )
                            ]
                        )
                    ),
                  ],
                )
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
        )
    );
  }
}
