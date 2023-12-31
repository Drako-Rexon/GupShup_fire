import 'package:flutter/material.dart';
import 'package:gupshup_firebase/pages/homepage.dart';
import 'package:gupshup_firebase/service/auth_service.dart';
import 'package:gupshup_firebase/shared/constants.dart';
import 'package:gupshup_firebase/widgets/widgets.dart';

import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userName, required this.email});
  final String userName;
  final String email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().darkGrey,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Constants().primaryColor,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 170,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Constants().darkGrey,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Full Name",
                  style: TextStyle(
                    fontSize: 18,
                    color: Constants().darkGrey,
                  ),
                ),
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Constants().darkGrey,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 18,
                    color: Constants().darkGrey,
                  ),
                ),
                Text(
                  widget.email,
                  style: TextStyle(
                    fontSize: 18,
                    color: Constants().darkGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Divider(height: 2),
            ListTile(
              onTap: () {
                nextPageReplace(context, const HomePage());
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {},
              selected: true,
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
    );
  }
}
