import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gupshup_firebase/helper/helper_function.dart';
import 'package:gupshup_firebase/pages/auth/login_page.dart';
import 'package:gupshup_firebase/pages/homepage.dart';
import 'package:gupshup_firebase/service/auth_service.dart';
import 'package:gupshup_firebase/shared/constants.dart';
import 'package:gupshup_firebase/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isEnable() {
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_mailController.text) &&
        _pswdController.text.length >= 6 &&
        _nameController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom == 0;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants().primaryColor,
        body: Visibility(
          visible: !_isLoading,
          replacement: Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Gupshup",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create your account now to chat and explore",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    isKeyboard
                        ? Image.asset('assets/images/register.png')
                        : const SizedBox(height: 50),
                    TextFormField(
                      cursorColor: Constants().darkGrey,
                      onChanged: (val) {
                        setState(() {
                          fullName = val;
                        });
                      },
                      style: TextStyle(color: Constants().darkGrey),
                      controller: _nameController,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Full Name",
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Full Name',
                        hintStyle: TextStyle(color: Constants().secondaryColor),
                        labelStyle:
                            TextStyle(color: Constants().secondaryColor),
                        prefixIcon: Icon(Icons.person,
                            color: Constants().secondaryColor),
                      ),
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          return null;
                        } else {
                          return "Name cannot be empty";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: Constants().darkGrey,
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
                      cursorColor: Constants().darkGrey,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      controller: _pswdController,
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Password",
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
                        labelStyle:
                            TextStyle(color: Constants().secondaryColor),
                        prefixIcon:
                            Icon(Icons.lock, color: Constants().secondaryColor),
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
                          backgroundColor: isEnable()
                              ? MaterialStateProperty.all(
                                  Constants().primaryBlue)
                              : MaterialStateProperty.all(
                                  Constants().secondaryColor),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: () {
                          isEnable() ? register() : () {};
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextPageReplace(context, const LoginPage());
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

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // * saving the shared preferences

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserFullNameSF(fullName);
          nextPage(context, const HomePage());
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
