import 'package:visionchat/services/auth.dart';
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
        elevation: 5.0,
        toolbarHeight: 60.0,
        title: Text(
          "VisionChat",
          style: TextStyle(
            color: Color(0xff121212),
            fontSize: 30.0,
          ),
        ),
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
        child: Stack(
          children: [
            Center(
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
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(
                          5.0,
                          10.0,
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
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 60.0),
              child: Text(
                "Application by Niloy Sikdar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
