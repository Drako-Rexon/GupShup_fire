import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gupshup_firebase/helper/helper_function.dart';
import 'package:gupshup_firebase/pages/auth/login_page.dart';
import 'package:gupshup_firebase/pages/search_page.dart';
import 'package:gupshup_firebase/service/auth_service.dart';
import 'package:gupshup_firebase/service/database_service.dart';
import 'package:gupshup_firebase/shared/constants.dart';
import 'package:gupshup_firebase/widgets/group_tile.dart';
import 'package:gupshup_firebase/widgets/widgets.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String _groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });

    // * getting the list of groups
    await DatabaseService(uId: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              nextPage(context, const SearchPage());
            },
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Icon(
                Icons.search,
                color: Constants().darkGrey,
              ),
            ), // Constants().darkGrey),
          ),
        ],
        backgroundColor: Constants().darkGrey,
        elevation: 0,
        title: const Text(
          "Groups",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      backgroundColor: Constants().primaryColor,
      body: groupList(),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Divider(height: 2),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                nextPage(
                  context,
                  ProfilePage(
                    email: email,
                    userName: userName,
                  ),
                );
              },
              selectedTileColor: Constants().primaryColor,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text("Are you sure you want to logout"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              // Navigator.pop(context);
                              await authService.signOut().whenComplete(() {
                                nextPageReplace(context, const LoginPage());
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog();
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
              color: Constants().darkGrey, shape: const OvalBorder()),
          child: Image.asset(
            Constants.msgIcon,
            width: 15,
            height: 15,
          ),
        ),
      ),
    );
  }

  popUpDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Constants().primaryColor,
              title: Text(
                "Create a group",
                textAlign: TextAlign.left,
                style: TextStyle(color: Constants().darkGrey),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: !_isLoading,
                    replacement: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _groupName = val;
                        });
                      },
                      style: TextStyle(color: Constants().darkGrey),
                      cursorColor: Constants().darkGrey,
                      decoration: textInputDecoration.copyWith(
                        hintText: "Enter group name...",
                        hintStyle: TextStyle(color: Constants().darkGrey),
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: Constants().darkGrey),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      await DatabaseService(
                              uId: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                              userName,
                              FirebaseAuth.instance.currentUser!.uid,
                              _groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: Constants().darkGrey),
                  child: const Text("CREATE"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            }
          }
        }
        return noGroupWidget();
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.circle,
              color: Constants().darkGrey,
              size: 75,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "You've joined any groups, tap on the add icon to create a group or also search from top search",
            textAlign: TextAlign.center,
            style: TextStyle(color: Constants().darkGrey),
          ),
        ],
      ),
    );
  }
}
