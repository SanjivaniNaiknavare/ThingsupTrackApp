import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/helperClass/UserObject.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class ListOfUsers extends StatefulWidget
{
  ListOfUsers({Key key,this.index,this.userObject,this.onTabCicked}) : super(key: key);
  int index;
  ValueChanged<bool> onTabCicked;
  UserObject userObject;

  @override
  _ListOfUsersState createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers>
{

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child:GestureDetector(
            onTap: (){
              widget.onTabCicked(true);
            },
            child:new Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                child:Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    height: 76,
                    decoration: new BoxDecoration(
                      color: global.screenBackColor,
                      boxShadow: [BoxShadow(color: Color.fromRGBO(18,18,18,0.1), blurRadius: 22.0, offset: Offset(0,8),),],
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child:new Row(
                      children: <Widget>[

                        Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(widget.userObject.name.toString(), style: new TextStyle(fontSize: global.font16, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                new Text(widget.userObject.email.toString(), style: new TextStyle(fontSize: global.font14, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),
                                new Text("Role: "+widget.userObject.role.toString(), style: new TextStyle(fontSize: global.font14, color: Color(0xff121212), fontWeight: FontWeight.normal,fontFamily: 'MulishRegular')),

                              ],
                            )
                        ),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                              ],
                            )
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(Icons.chevron_right,color: Color(0xffD3616A),),
                        )
                      ],
                    )
                )
            )
        )
    );
  }
}