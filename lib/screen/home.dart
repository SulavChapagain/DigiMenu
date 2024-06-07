// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';

import 'package:digimenu/screen/items.dart';
import 'package:digimenu/screen/userdata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String smallSentence(String bigSentence) {
  if (bigSentence.length > 15) {
    return '${bigSentence.substring(0, 15)}...';
  } else {
    return bigSentence;
  }
}

class _HomePageState extends State<HomePage> {
  List foodHeading = [];
  List searchResults = [];

  String userName = "";

  bool isLoad = false;
  bool isEmpty = false;

  TextEditingController headingName = TextEditingController();

  void casheData() async {
    var username = await APICacheManager().getCacheData("UserName");
    var myCurrency = await APICacheManager().getCacheData("myCurrency");
    if (username.syncData.isEmpty || myCurrency.syncData.isEmpty) {
      var refresh = await Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: const userData()));

      if (refresh == "refresh") {
        casheData();
      }
    }

    setState(() {
      userName = username.syncData;
    });
  }

  Future<void> checkUpdate() async {
    String uri = "https://digitalmenu.finoedha.com/appversion.php";
    try {
      var response = await http.get(Uri.parse(uri));

      var res = jsonDecode(response.body);

      var APPVersion = "2";

      if (res[0]['appversion'] != APPVersion) {
        UpdateMyApp();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> viewMenudata() async {
    var userID = await APICacheManager().getCacheData("UserID");

    String uri =
        "https://digitalmenu.finoedha.com/ViewProductHeading.php?id=${userID.syncData}";
    try {
      var response = await http.get(Uri.parse(uri));

      setState(() {
        foodHeading = jsonDecode(response.body);
        searchResults = foodHeading;

        if (foodHeading.isEmpty) {
          isEmpty = true;
        } else {
          isEmpty = false;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void onQueryChanged(String query) {
    setState(() {
      searchResults = foodHeading
          .where((item) =>
              item["heading"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> addItem() async {
    var userID = await APICacheManager().getCacheData("UserID");

    try {
      String uri = "https://digitalmenu.finoedha.com/createmenuheading.php";

      var res = await http.post(Uri.parse(uri), body: {
        "heading": headingName.text,
        "userid": userID.syncData,
      });

      var response = jsonDecode(res.body);
      if (response['success'] == 'true') {
        viewMenudata();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          headingName.text = "";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteItem(tableId) async {
    try {
      String uri = "https://digitalmenu.finoedha.com/delete.php";

      var res = await http.post(Uri.parse(uri), body: {
        "headingID": tableId,
      });

      var response = jsonDecode(res.body);
      if (response['sucess'] == 'true') {
        viewMenudata();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          headingName.text = "";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateItem(tableId) async {
    try {
      String uri = "https://digitalmenu.finoedha.com/update.php";

      var res = await http.post(Uri.parse(uri), body: {
        "HeadheadingID": tableId,
        "productName": headingName.text,
      });

      var response = jsonDecode(res.body);
      if (response['sucess'] == 'true') {
        viewMenudata();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          headingName.text = "";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    viewMenudata();
    casheData();
    checkUpdate();
    super.initState();
  }

  void _purchase() async {
    String url =
        'https://play.google.com/store/apps/details?id=com.digimenu.finoedha'; // Specify the URL you want to redirect to

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> UpdateMyApp() => showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Update"),
            content: const Text("Update your DigiMenu App"),
            actions: [
              TextButton(
                  onPressed: () {
                    _purchase();
                  },
                  child: const Text("Update"))
            ],
          )));

  Future longpressBTN(tableId) => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Items"),
            content: TextField(
              controller: headingName,
              decoration: const InputDecoration(hintText: "PIZZA"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteItem(tableId);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    if (headingName.text.isNotEmpty) {
                      updateItem(tableId);
                    }
                  },
                  child: const Text("Update"))
            ],
          )));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 20, 111, 185),
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) => AlertDialog(
                    title: const Text("Items"),
                    content: TextField(
                      controller: headingName,
                      decoration: const InputDecoration(hintText: "PIZZA"),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            if (headingName.text.isNotEmpty) {
                              addItem();
                            }
                          },
                          child: const Text("Add"))
                    ],
                  )));
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text(
          "DigiMenu",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        actions: <Widget>[
          Text(
            smallSentence(userName),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          viewMenudata();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                onChanged: onQueryChanged,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search Items",
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: isLoad
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : isEmpty
                        ? Image.asset(
                            "assets/pictures/upLoad.png",
                            width: 250,
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(searchResults[index]["heading"]
                                    .toUpperCase()),
                                trailing:
                                    const Icon(Icons.arrow_right_outlined),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: ItemPage(
                                            productName: searchResults[index]
                                                    ["heading"]
                                                .toUpperCase(),
                                            productTableTD: searchResults[index]
                                                ["headingid"],
                                          )));
                                },
                                onLongPress: () {
                                  setState(() {
                                    headingName.text =
                                        searchResults[index]["heading"];
                                  });
                                  longpressBTN(
                                      searchResults[index]["headingid"]);
                                },
                              );
                            })),
          ],
        ),
      ),
    ));
  }
}
