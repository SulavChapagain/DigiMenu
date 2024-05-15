// ignore_for_file: deprecated_member_use

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:digimenu/elements/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

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

  GlobalKey globalKey = GlobalKey();
  final _screenshotController = ScreenshotController();
  Future<Image>? image;

  void casheData() async {
    var username = await APICacheManager().getCacheData("UserName");
    var userID = await APICacheManager().getCacheData("UserID");

    setState(() {
      userName = username.syncData;
      userid = userID.syncData;
    });
  }

  Future<String> get imagePath async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    return '$directory/qr.png';
  }

  Future<Image> _loadImage() async {
    return await imagePath.then((imagePath) => Image.asset(imagePath));
  }

  Future<void> _captureAndSaveQRCode() async {
    final imageDirectory = await imagePath;

    _screenshotController.captureAndSave(imageDirectory);
    setState(() {
      image = _loadImage();
    });
  }

  Future displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: ((context) => SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(children: [
                // const SizedBox(
                //   height: 20,
                // ),
                // RepaintBoundary(
                //   key: globalKey,
                // child: QrImageView(
                //   data: 'https://digitalmenu.finoedha.com/?id=$userid',
                //   version: QrVersions.auto,
                //   size: 200.0,
                // ),
                // ),
                // const Text("View Menu"),
                // const SizedBox(
                //   height: 30,
                // ),
                // TextButton(
                //     onPressed: () async {
                //       await _captureAndSaveQRCode();
                //     },
                //     child: const Text("Download"))

                TextButton(
                    onPressed: () async {
                      await _captureAndSaveQRCode();
                    },
                    child: const Text("capture qr code")),
                if (image != null)
                  Center(
                      child: Screenshot(
                    controller: _screenshotController,
                    child: QrImageView(
                      data: 'https://digitalmenu.finoedha.com/?id=$userid',
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  )),
              ]),
            ))));
  }

  @override
  void initState() {
    casheData();
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
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  smallSentence(userName),
                  style: TextStyle(fontSize: 25),
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
          const Text("Status: Free"),
          const Text("Time Left: 5m"),
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
          ListTile(
            title: const Text("Analytics"),
            trailing: const Icon(Icons.lock),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Purchase"),
            onTap: () {},
          ),
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
