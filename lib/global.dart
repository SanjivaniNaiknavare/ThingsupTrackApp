import 'package:firebase_core/firebase_core.dart';
import 'package:thingsuptrackapp/HelperClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/helpers/APIClass.dart';
import 'helperClass/DeviceObject.dart';


Color greenColor=Color(0xff00D355);
Color darkBlack=Color(0xff121212);
Color whiteColor=Color(0xffffffff);
Color redColor=Color(0xffe51b1a);
Color blueColor=Color(0xff0176fe);
Color darkGreyColor=Color(0xff414141);
Color lightGreyColor=Color(0xffe5e5e5);
Color textDarkGreyColor=Color(0xff484848);
Color textLightGreyColor=Color(0xff808081);
Color checkboxColor=Color(0xff2C98F0);
Color cardBackColor=Color(0xfff0f0f3);
Color screenBackColor=Color(0xfffbfcfe);
Color popupBackColor=Color(0xfff0f0f3);
Color popupDarkGreyColor=Color(0xff414141).withOpacity(0.5);
Color secondaryBlueColor=Color(0xff0176FE);
Color appbarTextColor=Color(0xff121212);
Color appbarBackColor=Color(0xffffffff);
Color mainColor=Color(0xff0175fe);
Color lightBlueColor=Color(0x500176fe);
Color errorTextFieldFillColor=Color(0x20BF4C4C);
Color transparent=Color(0x00f50057);
Color lowPriorityColor=Color(0xffFBCF34).withOpacity(0.2);
Color medPriorityColor=Color(0xffF36E0E).withOpacity(0.2);
Color highPriorityColor=Color(0xffE51B1A).withOpacity(0.2);
Color allokColor=Color.fromRGBO(39, 172, 92, 0.2);

double font12=12;
double font13=13;
double font14=14;
double font15=15;
double font16=16;
double font17=17;
double font18=18;
double font20=20;
double font22=22;
double font24=24;
double font26=26;


FirebaseAuth firebaseInstance;
HelperClass helperClass;
APIClass apiClass;
String idToken="";


User currentUser;
String userID="";
String userName="";
String userRole="manager";
String lastFunction="";



List<DeviceObjectOwned> listofOwnedDevices=new List();
Map<String,dynamic> myDevices=new Map();
Map<String,dynamic> myUsers=new Map();
Map<String,dynamic> myDrivers=new Map();

