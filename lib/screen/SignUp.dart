import 'package:digimenu/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool OTPSend = false;
  Color colorname = Colors.grey;
  final email = TextEditingController();
  final password = TextEditingController();
  final otpcode = TextEditingController();

  var click = 0;

  bool HidePassword = true;

  final int _start = 60;

  bool validation = false;

  void startTimer() {
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
                        "FinoMenu",
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
                        "Digitized your business",
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
                            startTimer();
                          } else {
                            Null;
                          }
                        },
                        child: Text(
                          OTPSend ? "$_start" : "Get OTP",
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
                  label: "Password",
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
                    onTap: () async {
                      if (email.text.isNotEmpty ||
                          password.text.isNotEmpty ||
                          otpcode.text.isNotEmpty) {
                        null;
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: const Center(
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const LoginPage()));
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
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
