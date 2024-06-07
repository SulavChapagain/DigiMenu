import 'dart:convert';

import 'package:digimenu/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class VerifyCode extends StatefulWidget {
  final String email;
  const VerifyCode({super.key, required this.email});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool load = false;

  String pin1 = "";
  String pin2 = "";
  String pin3 = "";
  String pin4 = "";

  Future<void> createAccount() async {
    setState(() {
      load = true;
    });
    String uri = "https://digitalmenu.finoedha.com/sigin.php";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        "email": widget.email,
        "otpcodedata": pin1 + pin2 + pin3 + pin4,
        "submitotpdata": "true",
      });

      var res = jsonDecode(response.body);
      if (res["success"] == "true") {
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
                            "Id succesfully created",
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
      } else {
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
      }
    } catch (e) {
      setState(() {
        load = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verification code",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            const Text("We have verification code to"),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.email,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const Text("It might take some minutes"),
            const SizedBox(
              height: 25,
            ),
            Form(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 64,
                  height: 68,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        setState(() {
                          pin1 = value.toString();
                        });
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 64,
                  height: 68,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        setState(() {
                          pin2 = value.toString();
                        });
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 64,
                  height: 68,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        setState(() {
                          pin3 = value.toString();
                        });
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 64,
                  height: 68,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        setState(() {
                          pin4 = value.toString();
                          createAccount();
                        });
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                createAccount();
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
                          "Confirm",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
