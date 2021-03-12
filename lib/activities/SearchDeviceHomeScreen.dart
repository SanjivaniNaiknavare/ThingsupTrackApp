import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thingsuptrackapp/helperClass/DeviceObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;
import 'package:thingsuptrackapp/helpers/SearchDeviceList.dart';


class SearchDeviceHomeScreen extends StatefulWidget
{

  SearchDeviceHomeScreen({Key key,this.listOfDevices,this.onTabClicked}) : super(key: key);
  List<DeviceObjectAllAccount> listOfDevices;
  ValueChanged<DeviceObjectAllAccount> onTabClicked;

  @override
  _SearchDeviceHomeScreenState createState() => _SearchDeviceHomeScreenState();
}

class _SearchDeviceHomeScreenState extends State<SearchDeviceHomeScreen>
{
  String LOGTAG="SearchDeviceHomeScreen";

  List<DeviceObjectAllAccount> currentListOFDevices=new List();
  bool isDriverFound=false;

  @override
  void initState()
  {
    super.initState();
    currentListOFDevices.addAll(widget.listOfDevices);
  }

  void sortList(String searchSTR) async
  {
    currentListOFDevices.clear();
    for(int k=0;k<widget.listOfDevices.length;k++)
    {
      DeviceObjectAllAccount deviceObjectAllAccount=widget.listOfDevices.elementAt(k);
      if(deviceObjectAllAccount.name.toString().toLowerCase().contains(searchSTR.toLowerCase()))
      {
        currentListOFDevices.add(deviceObjectAllAccount);
      }
    }

    setState(() {});
  }

  Future<bool> _onbackButtonPressed()
  {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: _onbackButtonPressed,
        child: Scaffold(
            appBar:AppBar(
              titleSpacing: 0.0,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex:1,
                      fit: FlexFit.tight,
                      child:new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child:  Container(
                                height: kToolbarHeight-10,
                                padding:  EdgeInsets.fromLTRB(15,0,0,0),
                                child: new Container(
                                    child: GestureDetector(
                                        onTap: (){_onbackButtonPressed();},
                                        child: new Container(
                                          height: 20,
                                          child:Image(image: AssetImage('assets/back-arrow.png')),
                                        )
                                    )
                                )
                            ),
                          )
                        ],
                      )
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: new Container(
                      height:kToolbarHeight-10,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          prefixIcon:  Icon(Icons.search,color: Color(0xff3C74DC)),
                          filled: true,
                          fillColor: Color(0xffF4F8FF),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffE6EFFB),width: 2), borderRadius: BorderRadius.circular(8.0),),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffE6EFFB),width: 2), borderRadius: BorderRadius.circular(8.0),),
                          hintText: ' Search Device By Name',
                          hintStyle: TextStyle(fontSize: global.font15,color:Color(0xff3C74DC),fontStyle: FontStyle.normal,fontFamily: 'MulishRegular'),
                        ),
                        onChanged: (value) {
                          sortList(value);
                        },
                      ),
                    ),
                  )

                ],
              ),
              backgroundColor:global.screenBackColor,
            ),
            body: new Container(
              height: MediaQuery.of(context).size.height,
              color: global.screenBackColor,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: new ListView.builder
                (
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  itemCount: currentListOFDevices.length,
                  itemBuilder: (BuildContext ctxt, int index) {

                    return Container(
                      child: SearchDeviceList(index:index,deviceObject: currentListOFDevices[index],onTabClicked: (selectedDevice){

                        print(LOGTAG+" searchDeviceSelcted->");
                        widget.onTabClicked(currentListOFDevices[index]);
                        _onbackButtonPressed();

                      },),
                    );
                  }
              ),
            )
        )
    );
  }
}
