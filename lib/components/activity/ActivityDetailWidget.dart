import 'package:flutter/material.dart';
import 'package:artsideout_app/graphql/Activity.dart';
import 'package:artsideout_app/theme.dart';

class ActivityDetailWidget extends StatefulWidget {
  final Activity data;

  ActivityDetailWidget(this.data);

  @override
  _ActivityDetailWidgetState createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[ 
          Card( 
            shape: RoundedRectangleBorder( 
              borderRadius: BorderRadius.circular(25.0), 
            ),
            child: Container( 
              width: 450.0, 
              height: 250.0, 
              decoration: BoxDecoration( 
                image: DecorationImage( 
                  fit: BoxFit.fill, 
                  image: NetworkImage(widget.data.imgUrl),
                ),
              ),
            ),
          ),

          SizedBox( 
            height: 15.0, 
          ),

          ListTile( 
            leading: CircleAvatar( 
              backgroundColor: asoPrimary,
              radius: 25.0,
            ),
            title: Column(
              children: <Widget>[
                Text(
                  widget.data.time["startTime"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'to',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.data.time["endTime"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: IconButton( 
              icon: Icon(Icons.bookmark), 
              color: asoPrimary, 
              onPressed: () {
                print('Save button pressed! uwu');
              },
            ),
          ),

          ListTile( 
            leading: Text( 
              widget.data.zone, 
              style: TextStyle( 
                color: asoPrimary, 
                fontWeight: FontWeight.bold, 
                fontSize: 18.0, 
              )
            )
          ),

          Divider( 
            color: Colors.black, 
            thickness: 3.0, 
            height: 0.0, 
            indent: 15.0, 
            endIndent: 15.0,
          ), 

          ListTile( 
            leading: Text( 
              'OVERVIEW', 
              style: TextStyle( 
                color: asoPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18.0, 
              ),
            ),
          ),

          Container( 
            padding: EdgeInsets.only(bottom: 25),
            child: Row( 
              children: <Widget>[ 
                SizedBox(
                  width: 16.0, 
                ), 
                Flexible( 
                  child: Text( 
                    widget.data.desc,
                  ),  
                )
              ],
            ),
          ),

          Divider( 
            color: Colors.black, 
            thickness: 1.0, 
            height: 0.0, 
            indent: 15.0, 
            endIndent: 15.0,
          ),

          
        ],
      ),
    );
  }
}
