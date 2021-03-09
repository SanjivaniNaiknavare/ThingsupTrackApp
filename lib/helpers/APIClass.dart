

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';
import 'package:thingsuptrackapp/global.dart' as global;

class APIClass
{

  String LOGTAG="APIClass";
  String SERVER_URL="https://dev.trackapi.thingsup.io";
  int timeoutPeriod=10000;


  Future<Response> AddUser(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/user/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" idToken->"+idToken.toString());
    print(LOGTAG+" addUser url->"+url.toString());

    Response response = await put(url, headers: headers, body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> GetUser() async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/user/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> UpdateUser(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);

    String url = SERVER_URL+"/api/user/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Response response = await post(url, headers: headers,body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> DeleteUser(String userid) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/user/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Map<String, String> queryParams = {
      'userid': userid,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);

    print(LOGTAG+" delete url->"+url);

    Response response = await delete(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> GetChildUsers() async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/user/childs";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> AddDevice(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" idToken->"+idToken.toString());
    print(LOGTAG+" AddDevice url->"+url.toString());

    Response response = await put(url, headers: headers, body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> UpdateDevice(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" idToken->"+idToken.toString());
    print(LOGTAG+" AddDevice url->"+url.toString());

    Response response = await post(url, headers: headers, body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> DeleteDevice(String uniqueid) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Map<String, String> queryParams = {
      'uniqueid': uniqueid,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);

    print(LOGTAG+" delete device url->"+url);


    Response response = await delete(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> GetAccountDevices() async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> GetDeviceDetails(String uniqueid) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device/details";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Map<String, String> queryParams = {
      'uniqueid': uniqueid,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);

    print(LOGTAG+" GetDeviceDetails url->"+url);

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> GetOwnedDevices() async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device/owned";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };


    print(LOGTAG+" GetOwnedDevices url->"+url);

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> GetTaggedDevices(String userid) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device/tag";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Map<String, String> queryParams = {
      'userid': userid,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);


    print(LOGTAG+" GetOwnedDevices url->"+url);

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> TagUserToDevice(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device/tag";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" TagUserToDevice url->"+url);

    Response response = await post(url, headers: headers,body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> UntagUserFromDevice(String uniqueid,String taguserid) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device/tag";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Map<String, String> queryParams = {
      'uniqueid': uniqueid,
      'taguserid': taguserid,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);


    print(LOGTAG+" UntagUserFromDevice url->"+url);

    Response response = await delete(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> EnableUser(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/user/enable";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" EnableUser url->"+url);

    Response response = await post(url, headers: headers,body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> DisableUser(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/user/disable";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" DisableUser url->"+url);

    Response response = await post(url, headers: headers,body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> AddGeofence(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/geofence";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" DisableUser url->"+url);

    Response response = await put(url, headers: headers,body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> GetGeofence() async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/geofence";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" GetGeofence url->"+url);

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> DeleteGeofence(String id) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/geofence";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Map<String, String> queryParams = {
      'id': id
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);

    print(LOGTAG+" DeleteGeofence url->"+url);

    Response response = await delete(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> UpdateGeofence(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/geofence";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" UpdateGeofence url->"+url);

    Response response = await post(url, headers: headers,body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> GetGeofenceDetails(String id) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/geofence/details";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };
    Map<String, String> queryParams = {
      'id': id
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);

    print(LOGTAG+" GetGeofenceDetails url->"+url);

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> GetDeviceHistoryData(String uniqueid,String starttime,String endtime) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device/history";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };
    Map<String, String> queryParams = {
      'uniqueid': uniqueid,
      'starttime': starttime,
      'endtime': endtime,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);

    print(LOGTAG+" GetDeviceHistoryData url->"+url);

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> GetSharingDevices() async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device/sharing";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" GetSharingDevices url->"+url);

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

  Future<Response> DeleteSharingDevice(String id) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/device/sharing";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Map<String, String> queryParams = {
      'id': id,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);

    print(LOGTAG+" DeleteSharingDevice url->"+url);

    Response response = await delete(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> GetDrivers() async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/driver/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" GetDrivers url->"+url);

    Response response = await get(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> AddDriver(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/driver/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" AddDriver url->"+url);

    Response response = await put(url, headers: headers,body: jsonBody).catchError((error,stacktrace){
      print(error);
      return null;
    }).timeout(Duration(milliseconds: 30000),onTimeout: (){
      print("Timeout error");
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> UpdateDriver(String jsonBody) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/driver/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    print(LOGTAG+" UpdateDriver url->"+url);

    Response response = await post(url, headers: headers,body: jsonBody).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }


  Future<Response> DeleteDriver(String id) async
  {
    Future<Response> flag=Future.value(null);
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: defaultApp);
    String idToken=await _auth.currentUser.getIdToken(true);
    global.idToken=idToken;

    String url = SERVER_URL+"/api/driver/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer "+idToken,
    };

    Map<String, String> queryParams = {
      'id': id,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    url = url + '?' + queryString;
    url=Uri.decodeComponent(url);

    print(LOGTAG+" DeleteDriver url->"+url);

    Response response = await delete(url, headers: headers).catchError((error,stacktrace){
      return null;
    }).timeout(Duration(milliseconds: timeoutPeriod),onTimeout: (){
      return null;
    });
    flag=Future.value(response);
    return flag;
  }

}