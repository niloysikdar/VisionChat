import 'package:EasyChat/services/database.dart';
import 'package:EasyChat/services/sharedprefhelper.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final chatWithUserName, chatWithUserDisplayName, chatWithUserprofilepic;
  ChatScreen(
      {this.chatWithUserName,
      this.chatWithUserDisplayName,
      this.chatWithUserprofilepic});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  String myname, myUsername, myEmail, myProfilePic;
  TextEditingController messageTextEditingController = TextEditingController();
  Stream allMessageStream;

  getMyInfoFromSharedPref() async {
    myname = await SharedPrefHelper().getDisplayName();
    myUsername = await SharedPrefHelper().getUserName();
    myEmail = await SharedPrefHelper().getUserEmail();
    myProfilePic = await SharedPrefHelper().getUserProfilePic();
    chatRoomId = getChatRoomId(widget.chatWithUserName, myUsername);
  }

  getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) == 1) {
      return "$user1\_$user2";
    } else {
      return "$user2\_$user1";
    }
  }

  addMessage(bool isSendClicked) {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;
      var lastMsgTimeStamp = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "messageText": message,
        "sender": myUsername,
        "timestamp": lastMsgTimeStamp,
        "imgUrl": myProfilePic,
      };

      // messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessagetoDB(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendBy": myUsername,
          "lastMessageTs": lastMsgTimeStamp,
        };

        DatabaseMethods().updateLastMessaage(chatRoomId, lastMessageInfoMap);

        if (isSendClicked) {
          //removing the text from inputfield
          messageTextEditingController.text = "";

          // making the messageId to blank so that we can regenerate it for the next message
          messageId = "";
        }
      });
    }
  }

  getPreviousMessaages() async {}

  onlaunch() async {
    await getMyInfoFromSharedPref();
    await getPreviousMessaages();
  }

  @override
  void initState() {
    onlaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Color(0xff1db954),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatWithUserDisplayName),
            Text(widget.chatWithUserName),
          ],
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
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          addMessage(false);
                        },
                        controller: messageTextEditingController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 36.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
