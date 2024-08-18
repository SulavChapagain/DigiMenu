import 'dart:convert';

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:digimenu/screen/itemUpdate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class ItemPage extends StatefulWidget {
  final productName;
  final productTableTD;


  const ItemPage(
      {super.key, required this.productName, required this.productTableTD});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

String smallSentence(String bigSentence) {
  if (bigSentence.length > 15) {
    return '${bigSentence.substring(0, 15)}...';
  } else {
    return bigSentence;
  }
}

class _ItemPageState extends State<ItemPage> {
  List foodHeading = [];
  List searchResults = [];

  String usercurrency = "";


  bool isLoad = false;
  bool isEmpty = false;

  TextEditingController itemName = TextEditingController();
  TextEditingController itemPrice = TextEditingController();

  Future<void> viewMenudata() async {
    var userID = await APICacheManager().getCacheData("UserID");
    var userCurrency = await APICacheManager().getCacheData("myCurrencysymbole");

    setState(() {
      isLoad = true;
      usercurrency = userCurrency.syncData;
    });

    String uri =
        "https://digitalmenu.finoedha.com/menuitem.php?userid=${userID.syncData}&tableId=${widget.productTableTD}";
    try {
      var response = await http.get(Uri.parse(uri));

      setState(() {
        foodHeading = jsonDecode(response.body);
        searchResults = foodHeading;
        isLoad = false;
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
              item["title"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    viewMenudata();
    super.initState();
  }

  Future<void> createMenu() async {
    var userID = await APICacheManager().getCacheData("UserID");

    try {
      String uri = "https://digitalmenu.finoedha.com/createmenuheading.php";

      var res = await http.post(Uri.parse(uri), body: {
        "headingname": widget.productTableTD,
        "title": itemName.text,
        "price": itemPrice.text,
        "userId": userID.syncData,
      });
      var responce = jsonDecode(res.body);
      if (responce["success"] == 'true') {
        viewMenudata();

        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          itemName.text = "";
          itemPrice.text = "";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future openForm() => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Sub-Items"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: itemName,
                    decoration: const InputDecoration(hintText: "Veg Pizza"),
                  ),
                  TextField(
                    controller: itemPrice,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Price"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (itemName.text.isNotEmpty || itemPrice.text.isNotEmpty) {
                      createMenu();
                    }
                  },
                  child: const Text("Add"))
            ],
          )));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 20, 111, 185),
        tooltip: 'Increment',
        onPressed: () {
          openForm();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(
          widget.productName,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
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
                            "assets/pictures/noData.png",
                            width: 250,
                          )
                        : ListView.builder(
                            // physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(searchResults[index]["title"]),
                                trailing: Text(
                                    "$usercurrency ${searchResults[index]["price"]}"),
                                subtitle: searchResults[index]["detail"] != ""
                                    ? Text(smallSentence(
                                        searchResults[index]["detail"]))
                                    : null,
                                onTap: () async {
                                  var refresh = await Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: itemUpdate(
                                            itemName: searchResults[index]
                                                ["title"],
                                            itemPrice: searchResults[index]
                                                ["price"],
                                            itemDetail: searchResults[index]
                                                ["detail"],
                                            itemTableId: searchResults[index]
                                                ["id"],
                                          )));

                                  if (refresh == "refresh") {
                                    viewMenudata();
                                  }
                                },
                              );
                            })),
          ],
        ),
      ),
    ));
  }
}
