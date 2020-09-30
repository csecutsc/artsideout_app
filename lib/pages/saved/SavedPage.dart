import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:math' as math;

import 'package:artsideout_app/theme.dart';
import 'package:artsideout_app/components/common/PlatformSvg.dart';
import 'package:artsideout_app/components/saved/SavedLogin.dart';
import 'package:artsideout_app/components/saved/SavedItems.dart';

class SavedPage extends StatefulWidget {
  @override 
  _SavedPageState createState() => _SavedPageState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, 
      double shrinkOffset, 
      bool overlapsContent) 
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

@immutable 
class CurrentUser {
  final bool isInitialValue;
  final User data; 
  const CurrentUser._(this.data, this.isInitialValue);
  factory CurrentUser.create(User data) => CurrentUser._(data, false);
  static const initial = CurrentUser._(null, true);
}

class _SavedPageState extends State<SavedPage> {
  @override 
  void initState() {
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    return StreamProvider.value( 
      initialData: CurrentUser.initial,
      value: FirebaseAuth.instance.authStateChanges().map((user) => CurrentUser.create(user)),
      child: Consumer<CurrentUser>( 
        builder: (context, user, _) => Scaffold(
          backgroundColor: Color(0xFFFCEAEB),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: user.isInitialValue 
            ? Scaffold(body: const Text("Loading...")) 
            : user.data != null ? SavedItems() : SavedLogin()
        ),
      ),
    );
  }
}