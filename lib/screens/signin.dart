import 'package:EasyChat/services/auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1db954),
        title: Text("EasyChat"),
        toolbarHeight: 60.0,
        elevation: 5.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff29323c),
              Color(0xff485563),
            ],
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              AuthMethods().signInWithGoogle(context);
            },
            child: Container(
              width: 250.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      10.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign in with Google ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Image.asset('assets/images/google.png', height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
