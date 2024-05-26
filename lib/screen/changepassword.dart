import 'dart:async';
import 'dart:convert';

import 'package:digimenu/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  bool OTPSend = false;
  Color colorname = Colors.grey;
  final email = TextEditingController();
  final password = TextEditingController();
  final otpcode = TextEditingController();

  var click = 0;

  bool HidePassword = true;
  bool load = false;

  Timer? _timer;

  int _remainingSeconds = 60;
  bool validation = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_remainingSeconds == 0) {
          setState(() {
            timer.cancel();
            OTPSend = false;
            click = 0;
            _remainingSeconds = 90;
          });
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  Future<void> sendOTP() async {
    if (email.text.isNotEmpty) {
      String uri = "https://digitalmenu.finoedha.com/updateprofile.php";
      try {
        var response = await http.post(Uri.parse(uri), body: {
          "getOTP": "true",
          "email": email.text,
        });

        var res = jsonDecode(response.body);
        if (res["sucess"] == "userfound") {
          setState(() {
            _remainingSeconds = 0;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    padding: EdgeInsets.all(16),
                    height: 90,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 16, 134, 36),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.exclamationmark,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "User not found",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                "This email is not used",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                behavior: SnackBarBehavior.floating,
              ),
            );
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> createAccount() async {
    setState(() {
      load = true;
    });
    String uri = "https://digitalmenu.finoedha.com/updateprofile.php";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        "email": email.text,
        "submitdata": "true",
        "otpcodedata": otpcode.text,
        "password": password.text,
      });

      var res = jsonDecode(response.body);
      if (res["success"] == "false") {
        setState(() {
          load = false;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                  padding: EdgeInsets.all(16),
                  height: 90,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 134, 16, 16),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.bubble_right_fill,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Try again",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              "Something went wrong!",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
                padding: EdgeInsets.all(16),
                height: 90,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 16, 134, 36),
                    borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.check_mark_circled,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Successful",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            "Password changed succesfully",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          load = false;
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const LoginPage()));
        });
      }
    } catch (e) {
      setState(() {
        email.text = "error";
        load = false;
      });
      print(e);
    }
  }

  void getOTP() {
    if (email.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
                padding: EdgeInsets.all(16),
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.mail,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email address",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            "You have to put your email",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            behavior: SnackBarBehavior.floating,
          ),
        );
        click = 0;
      });
    } else {
      sendOTP();
      startTimer();
      setState(() {
        OTPSend = true;
        colorname = Colors.grey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "DigiMenu",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Change your password",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                inputbox(
                  controller: email,
                  hintText: "example@xyz.com",
                  label: "Email Address",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                inputbox(
                  controller: otpcode,
                  hintText: "1234",
                  label: "OTP",
                  obscureText: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          click++;

                          if (click == 1) {
                            getOTP();
                          } else {
                            Null;
                          }
                        },
                        child: Text(
                          OTPSend ? "$_remainingSeconds" : "Get OTP",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: OTPSend ? colorname : Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                inputbox(
                  hintText: "Create Password",
                  label: "New Password",
                  obscureText: HidePassword,
                  controller: password,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (HidePassword == true) {
                              HidePassword = false;
                            } else {
                              HidePassword = true;
                            }
                          });
                        },
                        child: Text(
                          HidePassword ? "Show" : "Hide",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: InkWell(
                    onTap: () {
                      if (email.text.isNotEmpty ||
                          password.text.isNotEmpty ||
                          otpcode.text.isNotEmpty) {
                        createAccount();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: Center(
                        child: load
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Change",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class inputbox extends StatelessWidget {
  final hintText;
  final label;
  final obscureText;
  final controller;

  const inputbox({
    super.key,
    required this.hintText,
    required this.label,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          cursorColor: Color.fromARGB(255, 164, 165, 165),
          decoration: InputDecoration(
              label: Text(label),
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ))),
    );
  }
}
