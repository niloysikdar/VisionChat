import 'package:visionchat/screens/chatscreen.dart';
import 'package:visionchat/screens/signin.dart';
import 'package:visionchat/services/auth.dart';
import 'package:visionchat/services/database.dart';
import 'package:visionchat/services/sharedprefhelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = true;
  String myname, myUsername, myEmail, myProfilePic;
  Stream userStream, recentChatRooms;
  TextEditingController searchUserController = TextEditingController();

  onSearchBtnClick() async {
    setState(() {
      isSearching = !isSearching;
    });
    userStream = await DatabaseMethods()
        .getUserbyUsername(searchUserController.text.trim());
    setState(() {});
  }

  getMyInfoFromSharedPref() async {
    myname = await SharedPrefHelper().getDisplayName();
    myUsername = await SharedPrefHelper().getUserName();
    myEmail = await SharedPrefHelper().getUserEmail();
    myProfilePic = await SharedPrefHelper().getUserProfilePic();
  }

  getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) == 1) {
      return "$user1\_$user2";
    } else {
      return "$user2\_$user1";
    }
  }

  Widget searchUserTile(
      {String profilepic, String displayName, String userName}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomId(myUsername, userName);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUsername, userName],
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatWithUserName: userName,
                    chatWithUserDisplayName: displayName,
                    chatWithUserprofilepic: profilepic,
                  )),
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
                child: profilepic != null
                    ? Image.network(
                        profilepic,
                        height: 50.0,
                        width: 50.0,
                      )
                    : Container(
                        height: 50.0,
                        width: 50.0,
                      )),
            SizedBox(width: 15.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName != null ? displayName : " ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userName != null ? userName : " ",
                    style: TextStyle(
                      fontSize: 15.0,
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
                    userName: ds["userName"],
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
    return StreamBuilder(
      stream: recentChatRooms,
      builder: (context, snapshot) {
        return (snapshot.hasData)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return RecentChatListTile(
                    chatRoomId: ds.id,
                    myUserName: myUsername,
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getRecentChatRooms() async {
    recentChatRooms = await DatabaseMethods().getRecentChatRooms(myUsername);
    setState(() {});
  }

  onScrenLoading() async {
    await getMyInfoFromSharedPref();
    getRecentChatRooms();
  }

  @override
  initState() {
    onScrenLoading();
    super.initState();
  }

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
      body: ListView(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
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
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 20.0, bottom: 10.0),
                  child: Text(
                    "Welcome , $myname",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  child: Text(
                    "Your Username : $myUsername",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Container(
                  height: 70.0,
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                                if (searchUserController.text != "" &&
                                    searchUserController.text != myUsername) {
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
        ],
      ),
    );
  }
}

class RecentChatListTile extends StatefulWidget {
  final String chatRoomId, myUserName;
  RecentChatListTile({this.chatRoomId, this.myUserName});
  @override
  _RecentChatListTileState createState() => _RecentChatListTileState();
}

class _RecentChatListTileState extends State<RecentChatListTile> {
  String profilepic, displayName, userName;
  getThisUserInfo() async {
    userName =
        widget.chatRoomId.replaceAll(widget.myUserName, "").replaceAll("_", "");
    QuerySnapshot querySnapshot =
        await DatabaseMethods().getThisUserDetails(userName);
    profilepic = "${querySnapshot.docs[0]["userProfilePic"]}";
    displayName = "${querySnapshot.docs[0]["displayName"]}";
    userName = "${querySnapshot.docs[0]["userName"]}";
    setState(() {});
  }

  @override
  initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatWithUserName: userName,
              chatWithUserDisplayName: displayName,
              chatWithUserprofilepic: profilepic,
            ),
          ),
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
              child: (profilepic != null)
                  ? Image.network(
                      profilepic,
                      height: 50.0,
                      width: 50.0,
                    )
                  : Container(
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
                    displayName != null ? displayName : " ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userName != null ? userName : " ",
                    style: TextStyle(
                      fontSize: 15.0,
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
}
