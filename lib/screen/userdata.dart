import 'dart:async';
import 'dart:convert';
import 'package:csc_picker/csc_picker.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:currency_picker/currency_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class userData extends StatefulWidget {
  const userData({super.key});

  @override
  State<userData> createState() => _userDataState();
}

class _userDataState extends State<userData> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  String myCountry = "";
  String myCurrency = "";
  String myCurrencysymbole = "";
  String isLogoSelected = "";
  bool userpurchase = true;

  bool isload = false;

  Future<void> userdataid() async {
    setState(() {
      isload = true;
    });
    var userID = await APICacheManager().getCacheData("UserID");

    try {
      String uri = "https://digitalmenu.finoedha.com/userprofile.php";

      var res = await http.post(Uri.parse(uri), body: {
        "businessName": name.text,
        "number": number.text,
        "userId": userID.syncData,
        "country": myCountry,
        "currency": myCurrencysymbole,
      });

      var response = jsonDecode(res.body);
      if (response['success'] == 'true') {
        await APICacheManager().addCacheData(
            APICacheDBModel(key: "UserName", syncData: name.text));
        await APICacheManager().addCacheData(
            APICacheDBModel(key: "UserNumber", syncData: number.text));
        await APICacheManager().addCacheData(
            APICacheDBModel(key: "UserCountry", syncData: myCountry));
        await APICacheManager().addCacheData(
            APICacheDBModel(key: "myCurrency", syncData: myCurrency));
        await APICacheManager().addCacheData(APICacheDBModel(
            key: "myCurrencysymbole", syncData: myCurrencysymbole));

            

        setState(() {
          isload = false;
        });
        Navigator.of(context).pop("refresh");
      }
    } catch (e) {
      setState(() {
        isload = false;
      });
    }
  }

  Future<void> localdata() async {
    var username = await APICacheManager().getCacheData("UserName");
    var userNumber = await APICacheManager().getCacheData("UserNumber");
    var userCountry = await APICacheManager().getCacheData("UserCountry");
    var userCurrency = await APICacheManager().getCacheData("myCurrency");
    var userlogo = await APICacheManager().getCacheData("UserLogo");
    var userCurrencysymbole =
        await APICacheManager().getCacheData("myCurrencysymbole");
    if (username.syncData.isNotEmpty) {
      setState(() {
        name.text = username.syncData;
        number.text = userNumber.syncData;
        myCountry = userCountry.syncData;
        myCurrency = userCurrency.syncData;
        myCurrencysymbole = userCurrencysymbole.syncData;
        isLogoSelected = userlogo.syncData;
      });
    }
  }

  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        isLogoSelected = "true";
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    var userId = await APICacheManager().getCacheData("UserID");

    if (_image == null) return;

    final uri = Uri.parse("https://digitalmenu.finoedha.com/logoupload.php");
    var request = http.MultipartRequest('POST', uri);
    var pic = await http.MultipartFile.fromPath("image", _image!.path);

    // Adding a new field to send the new image name
    String newImageName = "logo.png"; // Change this as needed
    request.files.add(pic);
    request.fields['new_image_name'] = newImageName;
    request.fields['userId'] = userId.syncData;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      await APICacheManager()
          .addCacheData(APICacheDBModel(key: "UserLogo", syncData: "true"));
    } else {
      print('Image upload failed');
    }
  }

  Future<void> removelogo() async {
    var userID = await APICacheManager().getCacheData("UserID");

    try {
      String uri = "https://digitalmenu.finoedha.com/logoupload.php";

      await http.post(Uri.parse(uri), body: {
        "userId": userID.syncData,
        "removelogo": "true",
      });
      await APICacheManager()
          .addCacheData(APICacheDBModel(key: "UserLogo", syncData: ""));
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

  @override
  void initState() {
    // purchasestatus();
    localdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Textfieldbox(
              controller: name,
              title: const Text("Business Name"),
              keyboardType: TextInputType.name,
            ),
            Textfieldbox(
              controller: number,
              title: const Text("Number"),
              keyboardType: TextInputType.phone,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: myCountry.isEmpty
                  ? CSCPicker(
                      showCities: false,
                      showStates: false,
                      onCountryChanged: (value) {
                        setState(() {
                          myCountry = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          // stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          // cityValue = value;
                        });
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(myCountry),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                myCountry = "";
                              });
                            },
                            child: Text("Change"))
                      ],
                    ),
            ),
            TextButton(
              onPressed: () {
                showCurrencyPicker(
                  context: context,
                  showFlag: true,
                  showCurrencyName: true,
                  showCurrencyCode: true,
                  theme: CurrencyPickerThemeData(
                    flagSize: 25,
                    titleTextStyle: TextStyle(fontSize: 17),
                    subtitleTextStyle: TextStyle(
                        fontSize: 15, color: Theme.of(context).hintColor),
                    bottomSheetHeight: MediaQuery.of(context).size.height / 2,
                    //Optional. Styles the search field.
                    inputDecoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Start typing to search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  onSelect: (Currency currency) {
                    setState(() {
                      myCurrency = currency.name;
                      myCurrencysymbole = currency.symbol;
                    });
                  },
                );
              },
              child: myCurrencysymbole.isEmpty
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Choose your currency',
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$myCurrency $myCurrencysymbole",
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                myCurrencysymbole = "";
                              });
                            },
                            child: const Text("Change"))
                      ],
                    ),
            ),
            TextButton(
              onPressed: () {
                if (userpurchase) {
                  getImage();
                }
              },
              child: isLogoSelected.isEmpty || isLogoSelected == "null"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Upload Logo',
                        ),
                        userpurchase
                            ? const Text(
                                '',
                              )
                            : Icon(Icons.lock),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Logo is Selected",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                            onPressed: () {
                              removelogo();
                              setState(() {
                                isLogoSelected = "";
                              });
                            },
                            child: const Text("Remove"))
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  uploadImage();
                  userdataid();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue),
                  child: Center(
                      child: isload
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Done",
                              style: TextStyle(color: Colors.white),
                            )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Textfieldbox extends StatelessWidget {
  final Text title;
  final TextInputType keyboardType;
  final TextEditingController controller;
  const Textfieldbox({
    super.key,
    required this.title,
    required this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          label: title,
        ),
      ),
    );
  }
}
