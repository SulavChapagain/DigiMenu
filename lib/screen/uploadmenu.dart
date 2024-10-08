import 'dart:convert';

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadMenu extends StatefulWidget {
  const UploadMenu({super.key});

  @override
  State<UploadMenu> createState() => _UploadMenuState();
}

class _UploadMenuState extends State<UploadMenu> {
  List menudata = [];
  bool isloading = false;

  Future uploadImage(_image) async {
    if (_image == null) return;

    setState(() {
      isloading = true;
    });

    var userId = await APICacheManager().getCacheData("UserID");
    String uploadUrl =
        'https://digitalmenu.finoedha.com/uploadmenu/uploadmenu.php';
    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    request.fields['userId'] = userId.syncData;

    var response = await request.send();

    if (response.statusCode == 200) {
      viewmenu();
      print('Image uploaded successfully!');
      var responseData = await response.stream.bytesToString();
      var result = json.decode(responseData);
      print(result);

      
    setState(() {
      isloading = false;
    });


    } else {
      print('Failed to upload image');
    }
  }

  void pickImage(bool pickGalleryImage) async {
    XFile? image;
    final picker = ImagePicker();

    if (pickGalleryImage == true) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      final croppedImage = await cropImages(image);

      if (!mounted) return;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: ((context) => CroppedImage(
      //           image: croppedImage,
      //         )),
      //   ),
      // );
      uploadImage(croppedImage);
    }
  }

  Future<CroppedFile> cropImages(XFile image) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: const Color.fromARGB(255, 20, 111, 185),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
        ]),
      ],
    );

    return croppedFile!;
  }

  String userIDData = "";

  Future<void> viewmenu() async {
    var userId = await APICacheManager().getCacheData("UserID");

    setState(() {
      userIDData = userId.syncData;
      isloading = true;
    });

    try {
      String uri =
          "https://digitalmenu.finoedha.com/uploadmenu/viewmenu.php?userid=$userIDData";

      var responce = await http.get(Uri.parse(uri));
      var res = jsonDecode(responce.body);

      setState(() {
        menudata = res;
        isloading = false;
      });
    } catch (e) {
      print(e);
    }
  }

   Future<void> removelogo(imagesn, photoname) async {

    setState(() {
      isloading = true;
    });

    try {
      String uri = "https://digitalmenu.finoedha.com/uploadmenu/deletemenu.php";

      await http.post(Uri.parse(uri), body: {
        "userID": userIDData,
        "sn": imagesn,
        "photoname": photoname,
        "removelogo": "true",
      });

      viewmenu();

    setState(() {
      isloading = false;
    });
      
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    viewmenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          iconTheme: const IconThemeData(color: Colors.white),
          // animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: const Color.fromARGB(255, 20, 111, 185),

          children: [
            SpeedDialChild(
              child: const Icon(Icons.camera_alt_outlined),
              label: "Camera",
              onTap: () {
                pickImage(false);
              },
            ),
            SpeedDialChild(
              child: const Icon(
                CupertinoIcons.photo,
              ),
              label: "Gallery",
              onTap: () {
                pickImage(true);
              },
            ),
          ],

          // child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: const Text(
            "Upload Menu",
          ),
          actions: <Widget>[
          isloading ? const CircularProgressIndicator(strokeWidth: 2) : const Icon(Icons.upload),
          const SizedBox(
            width: 15,
          ),
        ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Choose Menus from gallary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),

                  itemCount: menudata.length, // total number of items
                  itemBuilder: (context, index) {
                    return (Column(
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

                            child: Stack(
                              children: [
                                Image.network(
                                  "https://digitalmenu.finoedha.com/uploadmenu/uploads/$userIDData/${menudata[index]['image']}",
                                  fit: BoxFit.cover,
                                  width: 110,
                                  height: 110,
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: InkWell(
                                    onTap: () {
                                      removelogo(menudata[index]['sn'], menudata[index]['image']);
                                    },
                                    child: const Icon(
                                      CupertinoIcons.multiply_circle,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
