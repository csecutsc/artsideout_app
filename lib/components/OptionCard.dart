import 'package:artsideout_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artsideout_app/components/common.dart';

class OptionCard extends StatefulWidget { 
  OptionCard(this.title, this.image, this.link);
  
  final String title;
  final String image;
  final Widget link;

  @override _OptionCardState createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  Widget build(BuildContext context) {
    return Container( 
      height: MediaQuery.of(context).size.height / 5, 
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration( 
        color: Color(0xFFEE7B5A), 
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack( 
        children: <Widget>[
          PlatformSvg.asset( 
            widget.image, 
            width: 300,
            fit: BoxFit.fill, 
          ),
          Positioned( 
            left: 30,
            top: 115,
            bottom: 0,
            right: 0, 
            child: Text(
              widget.title,
              style: TextStyle( 
                fontSize: 30, 
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Material( 
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: widget.link,
          ),
        ],
      ),
    );
  }
}
