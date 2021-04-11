import 'package:visionchat/services/database.dart';
import 'package:visionchat/services/sharedprefhelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    String message = messageTextEditingController.text;
    var lastMsgTimeStamp = DateTime.now();

    if (isSendClicked) {
      //removing the text from inputfield
      messageTextEditingController.text = "";
    }

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
    });
    if (isSendClicked) {
      // making the messageId to blank so that we can regenerate it for the next message
      messageId = "";
    }
  }

  getPreviousMessaages() async {
    allMessageStream = await DatabaseMethods().fetchingAllMessages(chatRoomId);
    setState(() {});
  }

  Widget messageDisplayTile(String messagetext, bool isSendByMe) {
    messagetext = messagetext.trim();
    return (messagetext != "")
        ? Row(
            mainAxisAlignment:
                isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                      bottomLeft: isSendByMe
                          ? Radius.circular(15.0)
                          : Radius.circular(0),
                      bottomRight: isSendByMe
                          ? Radius.circular(0)
                          : Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    messagetext,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget displayAllMessages() {
    return StreamBuilder(
      stream: allMessageStream,
      builder: (context, snapshot) {
        return (snapshot.hasData)
            ? ListView.builder(
                padding: EdgeInsets.only(top: 20.0, bottom: 80.0),
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return messageDisplayTile(
                      ds["messageText"], ds["sender"] == myUsername);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

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
        toolbarHeight: 70.0,
        backgroundColor: Color(0xff1db954),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                widget.chatWithUserprofilepic,
                height: 40.0,
                width: 40.0,
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.chatWithUserDisplayName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    widget.chatWithUserName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
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
            displayAllMessages(),
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
                        if (messageTextEditingController.text != "") {
                          addMessage(true);
                        }
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
