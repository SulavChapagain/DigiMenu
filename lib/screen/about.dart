// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:digimenu/elements/splashscreen.dart';
import 'package:digimenu/screen/userdata.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

// Function to open email client
void _sendEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'finoedha@gmail.com', // Replace this with your email address
    query: 'subject=DigiMenu Query&body=Hello',
  );

  if (await canLaunch(emailLaunchUri.toString())) {
    await launch(emailLaunchUri.toString());
  } else {
    throw 'Could not launch email';
  }
}

// Function to open Google link
void _openGoogleLink() async {
  var UserID = await APICacheManager().getCacheData("UserID");

  String url =
      'https://digitalmenu.finoedha.com/?id=${UserID.syncData}'; // Specify the URL you want to redirect to
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void _purchase() async {
  var UserID = await APICacheManager().getCacheData("UserID");

  String url =
      'https://digitalmenu.finoedha.com/payment/payment.php?uid=${UserID.syncData}'; // Specify the URL you want to redirect to
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String smallSentence(String bigSentence) {
  if (bigSentence.length > 15) {
    return '${bigSentence.substring(0, 10)}...';
  } else {
    return bigSentence;
  }
}

class _AboutPageState extends State<AboutPage> {
  String userName = "";
  String userid = "";

  String totalDay = "";
  bool userpurchase = false;
  List purchasedata = [];

  GlobalKey globalKey = GlobalKey();

  void casheData() async {
    var username = await APICacheManager().getCacheData("UserName");
    var userID = await APICacheManager().getCacheData("UserID");
    // var purchaseStatus = await APICacheManager().getCacheData("UserPurchase");

    setState(() {
      userName = username.syncData;
      userid = userID.syncData;
      // if (purchaseStatus.syncData != "Free") {
      //   userpurchase = true;
      // } else {
      //   userpurchase = false;
      // }
    });
  }

  Future<void> _saveQRToGallery() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);

      //Drawing White Background because Qr Code is Black
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(pngBytes);
      print(result);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR code saved to gallery!'),
        ),
      );
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save QR code to gallery!'),
        ),
      );
    }
  }

  Future displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: ((context) => SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                RepaintBoundary(
                  key: globalKey,
                  child: Column(
                    children: [
                      QrImageView(
                        data: 'https://digitalmenu.finoedha.com/?id=$userid',
                        version: QrVersions.auto,
                        size: 200.0,
                        embeddedImage:
                            const AssetImage('assets/pictures/Logo.png'),
                        embeddedImageStyle: const QrEmbeddedImageStyle(
                          size: Size(30, 30),
                        ),
                        errorStateBuilder: (ctx, err) {
                          return const Center(
                            child: Text(
                              'Something went wrong!!!',
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      const Text("View Menu"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: () {
                      _saveQRToGallery();
                    },
                    child: const Text("Download"))
              ]),
            ))));
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
  //         totalDay = userPurchaseData['totalDayLeft'].toString();
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
    casheData();
    // purchasestatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text(
          "DigiMenu",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const userData()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  smallSentence(userName),
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  CupertinoIcons.pencil,
                  size: 30,
                )
              ],
            ),
          ),
           const Text("Status: Pro"),
          
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: const Text("View Menu"),
            onTap: () {
              _openGoogleLink();
            },
          ),
          ListTile(
            title: const Text("Your QR code"),
            onTap: () {
              displayBottomSheet(context);
            },
          ),
          // ListTile(
          //   title: const Text("Analytics"),
          //   trailing: const Icon(Icons.lock),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         PageTransition(
          //             type: PageTransitionType.rightToLeft,
          //             child: ));
          //   },
          // ),
          // ListTile(
          //   title: const Text("Purchase"),
          //   onTap: () {
          //     _purchase();
          //   },
          // ),
          ListTile(
            title: const Text("Contact us"),
            onTap: () {
              _sendEmail();
            },
          ),
          ListTile(
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await APICacheManager().deleteCache("UserNumber");
              var UserID = await APICacheManager().deleteCache("UserID");
              if (UserID) {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()));
              }
            },
          ),
        ],
      ),
    ));
  }
}
