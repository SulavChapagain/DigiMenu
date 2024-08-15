import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  List tempData = [];
  bool loadData = false;
  String defaultTheme = "";
  String userID = "";
  bool userpurchase = true;

  Future<void> viewTemp() async {
    var usertheme = await APICacheManager().getCacheData("defaultTheme");
    var UserID = await APICacheManager().getCacheData("UserID");

    setState(() {
      defaultTheme = usertheme.syncData;
      userID = UserID.syncData;
    });

    String uri = "https://digitalmenu.finoedha.com/template.php";
    try {
      var response = await http.get(Uri.parse(uri));

      setState(() {
        tempData = jsonDecode(response.body);
        loadData = false;
      });
    } catch (e) {
      print(e);
    }
  }

  // Future<void> purchasestatus() async {
  //   var UserID = await APICacheManager().getCacheData("UserID");

  //   String uri =
  //       "https://digitalmenu.finoedha.com/MenuAnalytics.php?id=${UserID.syncData}";
  //   try {
  //     var response = await http.get(Uri.parse(uri));

  //     var userPurchaseData = jsonDecode(response.body);

  //     if (userPurchaseData['purchaseData'] != "Free") {
  //       setState(() {
  //         userpurchase = true;
  //       });
  //     } else {
  //       setState(() {
  //         userpurchase = false;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> userthemedata(themeid) async {
    setState(() {
      loadData = true;
    });

    try {
      String uri = "https://digitalmenu.finoedha.com/updateTemp.php";

      var res = await http.post(Uri.parse(uri), body: {
        "userID": userID,
        "userTheme": themeid,
      });

      var response = jsonDecode(res.body);
      if (response["sucess"] == "true") {
        await APICacheManager().addCacheData(
            APICacheDBModel(key: "defaultTheme", syncData: "$themeid"));
        setState(() {
          loadData = false;
          viewTemp();
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loadData = false;
      });
    }
  }

  Future displayBottomSheet(BuildContext context, background, title, themeid) {
    return showModalBottomSheet(
        context: context,
        builder: ((context) => SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                image: DecorationImage(
                  image: NetworkImage(background),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: InkWell(
                      onTap: () {
                        if (userpurchase) {
                          userthemedata(themeid);
                          viewTemp();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 1000,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                        child: Center(
                            child: loadData
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : defaultTheme == themeid
                                    ? const Text(
                                        "Selected",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : userpurchase
                                        ? const Text(
                                            "Select",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : const Text(
                                            "Pro",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )),
                      ),
                    ),
                  ),
                ],
              ),
            ))));
  }

  @override
  void initState() {
    viewTemp();
    // purchasestatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Template"),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("Background"),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),

                itemCount: tempData.length, // total number of items
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      displayBottomSheet(context, tempData[index]['image'],
                          tempData[index]['Name'], tempData[index]['tem_id']);
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20), // Image border
                            child: Image.network(
                              tempData[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
