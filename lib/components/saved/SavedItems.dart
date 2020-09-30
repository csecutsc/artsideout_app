import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/pages/saved/SavedPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:artsideout_app/theme.dart';
import 'package:artsideout_app/components/common/PlatformSvg.dart';
import 'package:artsideout_app/components/activity/ActivityCard.dart';
//TODO: GraphQL 

class SavedItems extends StatefulWidget {
  @override 
  State<StatefulWidget> createState() => _SavedItemsState();
}

var uidglobal;

class _SavedItemsState extends State<SavedItems> {
  @override 
  Widget build(BuildContext context) {
    final uid = Provider.of<CurrentUser>(context)?.data?.uid;
    uidglobal = uid;
    CollectionReference user = FirebaseFirestore.instance.collection('saved-$uid');

    if (user == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
        child: Text(
          "Something went wrong. :(",
          style: TextStyle( 
              fontWeight: FontWeight.bold,  
              fontSize: 30,
              fontFamily: 'Roboto',
              color: ColorConstants.PRIMARY,
          ),
        ),
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: user.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
              child: Text(
                "Something went wrong. :(",
                style: TextStyle( 
                    fontWeight: FontWeight.bold,  
                    fontSize: 30,
                    fontFamily: 'Roboto',
                    color: ColorConstants.PRIMARY,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
              child: Text(
                "Loading...",
                style: TextStyle( 
                    fontWeight: FontWeight.bold,  
                    fontSize: 30,
                    fontFamily: 'Roboto',
                    color: ColorConstants.PRIMARY,
                ),
              ),
            );
          }

          return new Scaffold( 
            backgroundColor: Color(0xFFFCEAEB),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 50, left: 40),
                  child: Text(
                    "Saved",
                    style: TextStyle( 
                        fontWeight: FontWeight.bold,  
                        fontSize: 36,
                        fontFamily: 'Roboto',
                        color: ColorConstants.PRIMARY,
                    ),
                  ),
                ),
                Flexible( 
                  child: ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      return new ActivityCard(
                        title: document.data()['title'],
                        desc: document.data()['desc'],
                        time: new Map<String, String>.from(document.data()['time']),
                        zone: document.data()['zone']
                      );
                    }).toList()
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}