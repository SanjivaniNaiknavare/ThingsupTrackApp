import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsuptrackapp/global.dart' as global;


class AttributeTable extends StatefulWidget
{
  AttributeTable({Key key,this.index,this.keyData,this.valueData}) : super(key: key);
  int index;
  String keyData;
  String valueData;

  @override
  _AttributeTableState createState() => _AttributeTableState();
}

class _AttributeTableState extends State<AttributeTable>
{

  String LOGTAG="AttributeTable";

  @override
  void initState(){
    super.initState();


  }

  @override
  Widget build(BuildContext context) {

    return new Row(
      children: <Widget>[
        Flexible(
            flex:1,
            fit: FlexFit.tight,
            child:Container(
              height: 50,
                decoration: new BoxDecoration(
                  color: widget.index==0?Color(0xffafafaf):global.whiteColor,
                  border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(0.0),),
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(widget.keyData.toString(), style: TextStyle(fontSize: global.font14, color: Color(0xff121212),fontFamily: 'MulishRegular'))
                  ],
                )
            )
        ),
        Flexible(
            flex:1,
            fit: FlexFit.tight,
            child:Container(
              height: 50,
                decoration: new BoxDecoration(
                  color:  widget.index==0?Color(0xffafafaf):global.whiteColor,
                  border: Border.all(color: Color(0xffc4c4c4),width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(0.0),),
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(widget.valueData.toString(), style: TextStyle(fontSize: global.font14, color: Color(0xff121212),fontFamily: 'MulishRegular'))
                  ],
                )
            )
        )
      ],
    );
  }
}