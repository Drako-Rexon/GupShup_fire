import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gupshup_firebase/pages/group_info.dart';
import 'package:gupshup_firebase/pages/homepage.dart';
import 'package:gupshup_firebase/service/database_service.dart';
import 'package:gupshup_firebase/service/gemini_service.dart';
import 'package:gupshup_firebase/shared/constants.dart';
import 'package:gupshup_firebase/widgets/message_tile.dart';
import 'package:gupshup_firebase/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  List<String> items = ["Leave Group"];

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Constants().darkGrey,
        centerTitle: true,
        elevation: 0,
        title: InkWell(
            onTap: () {
              nextPage(
                context,
                GroupInfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.groupName,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController geminiController =
                          TextEditingController();
                      bool isLoadingResponse = false;
                      return AlertDialog(
                        title: const Text('Gemini Pro+'),
                        content: TextField(
                          controller: geminiController,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                String text = await GeminiService.getResponse(
                                    geminiController.text);
                                setState(() {
                                  messageController.clear();
                                  messageController.text = text;
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('OK'))
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.text_increase,
                color: Colors.white,
              )),
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: InkWell(
                  onTap: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Exit"),
                          content:
                              const Text("Are you sure you exit the group? "),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                DatabaseService(
                                        uId: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .toggleGroup(widget.groupId, getName(admin),
                                        widget.groupName)
                                    .whenComplete(() {
                                  nextPageReplace(context, const HomePage());
                                });
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.more_vert),
                      Text("Leave Group"),
                    ],
                  ),
                ),
              )
            ];
          }),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding:
                  const EdgeInsets.only(left: 20, top: 4, bottom: 4, right: 10),
              width: MediaQuery.of(context).size.width,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(
                            color: Constants().darkGrey, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: SizedBox(
                      height: 25,
                      child: Center(
                        child: Image.asset(Constants.sendIcon),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
