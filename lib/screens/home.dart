import 'package:EasyChat/screens/chatscreen.dart';
import 'package:EasyChat/screens/signin.dart';
import 'package:EasyChat/services/auth.dart';
import 'package:EasyChat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = true;
  Stream userStream;
  TextEditingController searchUserController = TextEditingController();

  onSearchBtnClick() async {
    setState(() {
      isSearching = !isSearching;
    });
    userStream = await DatabaseMethods()
        .getUserbyUsername(searchUserController.text.trim());
    setState(() {});
  }

  Widget searchUserTile({String profilepic, String displayName}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.all(20.0),
        padding:
            EdgeInsets.only(left: 15.0, top: 10.0, right: 5.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.network(
                profilepic,
                height: 50.0,
                width: 50.0,
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchUserResult() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return searchUserTile(
                    profilepic: ds["userProfilePic"],
                    displayName: ds["displayName"],
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
      },
    );
  }

  Widget chatRoomList() {
    return Container();
  }

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
                        labelText: "Search username",
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
                            if (searchUserController.text != "") {
                              onSearchBtnClick();
                            }
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
            !isSearching ? searchUserResult() : chatRoomList(),
          ],
        ),
      ),
    );
  }
}
