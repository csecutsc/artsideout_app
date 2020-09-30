import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:artsideout_app/theme.dart';
import 'package:artsideout_app/components/common/PlatformSvg.dart';

class SavedLogin extends StatefulWidget {
  @override 
  State<StatefulWidget> createState() => _SavedLoginState();
}

class _SavedLoginState extends State<SavedLogin> {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final loginForm = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loggingIn = false;
  String errorMessage;

  @override 
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  List<Widget> buildGoogleSignInFields() => [
    RaisedButton( 
      onPressed: signInWithGoogle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PlatformSvg.asset(
            "assets/icons/google.svg",
            width: 40,
            height: 40,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 40 / 1.618),
            child: const Text("Sign In with Google"),
          ),
        ],
      ),
    ),
    if (loggingIn) Container(
      width: 22,
      height: 22, 
      margin: const EdgeInsets.only(top: 12),
      child: const CircularProgressIndicator(),
    ),
  ];

  Widget buildErrorScreen() => Container( 
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 20),
    child: Text( 
      errorMessage,
      style: const TextStyle( 
        fontSize: 14,
      ),
    ),
  );

  void setLoggingIn([bool loggingIn = true, String errorMessage]) {
    if (mounted) {
      setState(() {
        loggingIn = loggingIn;
        errorMessage = errorMessage;
      });
    }
  }

  void signInWithGoogle() async {
    setLoggingIn();
    String errorMessage;

    try {
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await auth.signInWithCredential(credential);
    } catch (e, s) {
      debugPrint("Google Sign In Failed: $e. $s");
      errorMessage = "Login failed, please try again.";
    } finally {
      setLoggingIn(false, errorMessage);
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Container( 
        alignment: Alignment.topCenter,
        child: SingleChildScrollView( 
          child: Container( 
            constraints: const BoxConstraints( // TODO: use ScreenUtils to scale, for some reason editor shows redbar when used
              maxWidth: 550 
            ),
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 50), 
            child: Form( 
              key: loginForm,
              child: Column( 
                children: <Widget>[
                  const SizedBox(
                    height: 10
                  ),
                  const Text(
                    "Log in to access your saved page.",
                    style: TextStyle( 
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox( 
                    height: 10
                  ),
                  if (errorMessage != null) buildErrorScreen(),
                  ...buildGoogleSignInFields() 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}