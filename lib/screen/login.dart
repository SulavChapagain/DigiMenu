import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:digimenu/screen/SignUp.dart';
import 'package:digimenu/screen/changepassword.dart';
import 'package:digimenu/screen/nabpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  bool loadData = false;

  Future<void> logindata() async {
    try {
      setState(() {
        loadData = true;
      });
      String uri = "https://digitalmenu.finoedha.com/login.php";
      var res = await http.post(Uri.parse(uri), body: {
        "email": userEmail.text,
        "password": userPassword.text,
      });
      var response = jsonDecode(res.body);
      if (response['success'] == "true") {
        await APICacheManager().addCacheData(APICacheDBModel(
            key: "UserName", syncData: "${response['userName']}"));
        await APICacheManager().addCacheData(APICacheDBModel(
            key: "UserNumber", syncData: "${response['userNumber']}"));
        await APICacheManager().addCacheData(
            APICacheDBModel(key: "UserID", syncData: "${response['userID']}"));
        await APICacheManager().addCacheData(APICacheDBModel(
            key: "UserPurchase", syncData: "${response['userPurchase']}"));
        await APICacheManager().addCacheData(APICacheDBModel(
            key: "UserCountry", syncData: "${response['usercountry']}"));
        await APICacheManager().addCacheData(APICacheDBModel(
            key: "UserLogo", syncData: "${response['userLogo']}"));
        await APICacheManager().addCacheData(APICacheDBModel(
            key: "myCurrencysymbole", syncData: "${response['userCurrency']}"));

        if (APICacheManager().isAPICacheKeyExist("myCurrencysymbole") ==
            false) {
          await APICacheManager()
              .addCacheData(APICacheDBModel(key: "myCurrency", syncData: ""));
        }
        setState(() {
          userEmail.text = "";
          userPassword.text = "";
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const HomeNabvar()));

          loadData = false;
        });
      } else {
        setState(() {
          loadData = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                  padding: const EdgeInsets.all(16),
                  height: 90,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 28, 28),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.chevron_left_slash_chevron_right,
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
                              "Incorrect email or password",
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
      if (response['success'] == "NotVerify") {
        setState(() {
          loadData = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                  padding: const EdgeInsets.all(16),
                  height: 90,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 28, 28),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.chevron_left_slash_chevron_right,
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
                              "Non Verified",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              "Your email is not verified",
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
        loadData = false;
      });
      print(e);
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
                        "Welcome to DigiMenu",
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
                        "Create your own digital menus",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                inputbox(
                  controller: userEmail,
                  hintText: "example@xyz.com",
                  label: "Email Address",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                inputbox(
                  controller: userPassword,
                  hintText: "Password",
                  label: "Password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const Changepassword()));
                        },
                        child: const Text(
                          "Rest Password",
                          style: TextStyle(
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
                      if (userEmail.text.isNotEmpty ||
                          userPassword.text.isNotEmpty) {
                        logindata();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: Center(
                        child: loadData
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Join DigiMenu? ",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const SignUpPage()));
                      },
                      child: const Text(
                        "Sign Up",
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
