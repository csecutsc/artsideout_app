import 'package:artsideout_app/components/OptionCard.dart';
import 'package:artsideout_app/components/activitycard.dart';
import 'package:artsideout_app/pages/art/MasterArtPage.dart';
import 'package:artsideout_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:artsideout_app/components/common.dart';
import 'package:artsideout_app/pages/home/HomePage.dart';
import 'package:artsideout_app/pages/activity/MasterActivityPage.dart';
import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';

class ActivityWebMenu extends StatefulWidget {
  ActivityWebMenu(this.activityCard);

  Widget activityCard;

  @override 
  _ActivityWebMenuState createState() =>_ActivityWebMenuState();
}

class _ActivityWebMenuState extends State<ActivityWebMenu> {
  Widget build(BuildContext context) {
    return Expanded( 
      flex: 71,
      child: Container( 
        color: Color(0xFFFCEAEB),
        child: Stack( 
          fit: StackFit.passthrough, 
          overflow: Overflow.clip, 
          children: <Widget>[ 
            Positioned( 
              top: MediaQuery.of(context).size.height / 5, 
              width: MediaQuery.of(context).size.width, 
              height: MediaQuery.of(context).size.height, 
              child: PlatformSvg.asset(
                "assets/icons/roadBg.svg",
                width: 1200, 
                alignment: Alignment(-1.0, 0.2),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 20,
              bottom: MediaQuery.of(context).size.height / 3,
              child: Padding( 
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  "Activities",
                  style: TextStyle( 
                    fontWeight: FontWeight.bold,  
                    fontSize: 45.0,
                    fontFamily: 'Roboto',
                    color: asoPrimary,
                  ),
                ),  
              ),
            ),
            Positioned( 
              top: MediaQuery.of(context).size.height / 10, 
              right: 20, 
              left: 20, 
              bottom: 0, 
              child: Row( 
                children: <Widget>[
                  Expanded( 
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 100),                  
                        OptionCard(
                          "Featured",
                          "assets/icons/aboutConnections.svg",
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                // TODO: Make Featured page?
                                MaterialPageRoute(builder: (context) => HomePage()), 
                              );
                            }
                          ),
                        ),
                        SizedBox(height: 30),
                        OptionCard(
                          "Saved",
                          "assets/icons/saved.svg",
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                // TODO: Make Saved page
                                MaterialPageRoute(builder: (context) => HomePage()), 
                              );
                            }
                          ),
                        ),
                        SizedBox(height: 30),
                        OptionCard(
                          "Art",
                          "assets/icons/installation.svg",
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                // TODO: Make Saved page
                                MaterialPageRoute(builder: (context) => MasterArtPage()), 
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded( 
                    flex: 7, 
                    child: widget.activityCard,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}