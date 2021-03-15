import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class AvatarList extends StatefulWidget
{
  AvatarList({Key key,this.index,this.onImageSelected}) : super(key: key);
  int index;
  ValueChanged<String> onImageSelected;

  @override
  _AvatarListState createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList>
{

  String LOGTAG="AvatarList";
  int imgIndex=0;

  @override
  void initState(){
    super.initState();

    if(widget.index>=8)
    {
      int tempIndex=widget.index%8;
      imgIndex = tempIndex + 1;
    }
    else
    {
      imgIndex = widget.index + 1;
    }
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {

    return new Row(
      children: <Widget>[
        Flexible(
            flex:1,
            fit: FlexFit.tight,
            child:GestureDetector(
              onTap: (){
                widget.onImageSelected("M"+imgIndex.toString());
              },
              child: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width/3,
                  margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: global.whiteColor,
                    image:  DecorationImage(
                      image:  AssetImage("assets/Avatar/M-Avatar-"+imgIndex.toString()+".png"),
                      fit: BoxFit.cover,
                    ),
                  )
              ),
            )
        ),
        Flexible(
            flex:1,
            fit: FlexFit.tight,
            child:GestureDetector(
              onTap: (){
                widget.onImageSelected("W"+imgIndex.toString());
              },
              child: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width/3,
                  margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: global.whiteColor,
                    image:  DecorationImage(
                      image:  AssetImage("assets/Avatar/W-Avatar-"+imgIndex.toString()+".png"),
                      fit: BoxFit.cover,
                    ),
                  )
              ),
            )
        )
      ],
    );
  }
}