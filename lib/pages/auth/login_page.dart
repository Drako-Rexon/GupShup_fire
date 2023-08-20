import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gupshup_firebase/helper/helper_function.dart';
import 'package:gupshup_firebase/pages/homepage.dart';
import 'package:gupshup_firebase/service/auth_service.dart';
import 'package:gupshup_firebase/service/database_service.dart';
import 'package:gupshup_firebase/shared/constants.dart';
import 'package:gupshup_firebase/widgets/widgets.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();

  bool isEnable() {
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_mailController.text) &&
        _pswdController.text.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom == 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Visibility(
          visible: !_isLoading,
          replacement: Center(
            child: CircularProgressIndicator(color: Constants().darkGrey),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Gupshup",
                      style: TextStyle(
                        fontSize: 40,
                        color: Constants().darkGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Login now to see what they are talking!",
                      style: TextStyle(
                        fontSize: 15,
                        color: Constants().darkGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    isKeyboard
                        ? Image.asset('assets/images/login.png')
                        : const SizedBox(height: 50),
                    TextFormField(
                      cursorColor: Constants().darkGrey,
                      style: TextStyle(color: Constants().darkGrey),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      controller: _mailController,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Email',
                        hintStyle: TextStyle(color: Constants().secondaryColor),
                        labelStyle:
                            TextStyle(color: Constants().secondaryColor),
                        prefixIcon:
                            Icon(Icons.mail, color: Constants().secondaryColor),
                      ),
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "Please enter a valid email";
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Constants().darkGrey),
                      cursorColor: Constants().primaryColor,
                      controller: _pswdController,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: Constants().secondaryColor),
                        labelText: "Password",
                        labelStyle:
                            TextStyle(color: Constants().secondaryColor),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Constants().secondaryColor,
                        ),
                      ),
                      validator: (value) {
                        if (value!.length < 6) {
                          return "Password must be at least 6 charcter";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: isEnable()
                                ? MaterialStateProperty.all(
                                    Constants().primaryBlue)
                                : MaterialStateProperty.all(
                                    Constants().secondaryColor)),
                        onPressed: () {
                          isEnable() ? login() : () {};
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Constants().darkGrey,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Register now",
                              style: TextStyle(
                                color: Constants().darkGrey,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextPageReplace(
                                      context, const RegisterPage());
                                }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService
          .loginWithUserNameAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uId: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          // * saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserFullNameSF(
              snapshot.docs[0]['fullName']);

          nextPageReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

class GoogleFonts {}
