import 'package:EasyChat/screens/signin.dart';
import 'package:EasyChat/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = true;
  TextEditingController searchUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1db954),
        elevation: 5.0,
        toolbarHeight: 60.0,
        title: Text(
          "EasyChat",
          style: TextStyle(
            color: Color(0xff121212),
            fontSize: 30.0,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                Icons.logout,
                size: 30.0,
                color: Color(0xff121212),
              ),
            ),
          ),
        ],
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
        child: Column(
          children: [
            Container(
              height: 70.0,
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.grey[300],
                boxShadow: kElevationToShadow[6],
              ),
              child: Row(
                children: [
                  !isSearching
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearching = !isSearching;
                              searchUserController.text = "";
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.arrow_back,
                              size: 40.0,
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: TextField(
                      controller: searchUserController,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        labelText: "Search",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  isSearching
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearching = !isSearching;
                              searchUserController.text = "";
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              size: 40.0,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
