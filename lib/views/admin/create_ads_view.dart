import 'package:classifiedapp/views/admin/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:math';

class CreateAdScreen extends StatefulWidget {
  CreateAdScreen({Key? key}) : super(key: key);
  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  //FORM'S CONTROLLERS
  TextEditingController _titleAdsCtrl = TextEditingController();
  TextEditingController _priceAdsCtrl = TextEditingController();
  TextEditingController _mobileContactAdsCtrl = TextEditingController();
  TextEditingController _decriptionAdsCtrl = TextEditingController();

  //TOKEN TO CREATE ADS LOGIN
  createMyAds() {
    FirebaseFirestore.instance.collection("ads").add({
      "title": _titleAdsCtrl.text,
      "description": _decriptionAdsCtrl.text,
      "price": _priceAdsCtrl.text,
      "phoneNumber": _mobileContactAdsCtrl.text,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "imageURL": imagesAds,
    }).then((value) {
      print("Added");
    }).catchError((e) {
      print(e);
    });
  }

  // CAPTURE IMAGE
  var imagesAds = [];

  captureImages() async {
    var picker = ImagePicker();
    var pickedFiles = await picker.pickMultiImage();
    if (pickedFiles!.isNotEmpty) {
      imagesAds.clear();
      for (var image in pickedFiles) {
        File img = File(image.path);
        var rng = Random();
        FirebaseStorage.instance
            .ref()
            .child("images")
            .child(rng.nextInt(10000).toString())
            .putFile(img)
            .then((res) {
          res.ref.getDownloadURL().then((url) {
            setState(() {
              imagesAds.add(url);
            });
          });
        }).catchError((e) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Ad"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                buildPhotoIcon(),
                imagesAds.isNotEmpty
                    ? buildPhotosPreview()
                    : SizedBox(
                        height: 40,
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //ADS' TITLE
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        controller: _titleAdsCtrl,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Title",
                        ),
                      ),
                    ),
                    //ADS' PRICE
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        controller: _priceAdsCtrl,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Price",
                        ),
                      ),
                    ),
                    //ADS' MOBILE
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        controller: _mobileContactAdsCtrl,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Contact Number",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        minLines: 3,
                        maxLines: 5,
                        controller: _decriptionAdsCtrl,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Description",
                        ),
                      ),
                    ),
                    // BUTTON ENTER TO APP
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          createMyAds();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            primary: Colors.deepOrange),
                        child: const Text(
                          "Submit Ad",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //CALLING FUNCTION UPLOAD IMAGES
  GestureDetector buildPhotoIcon() {
    return GestureDetector(
      onTap: () {
        captureImages();
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 7,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          shape: BoxShape.rectangle,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(7),
        width: 120,
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: 50,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              child: Text(
                "Tap to upload",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //SHOW SAVED IMAGES
  Container buildPhotosPreview() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      height: 130,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: imagesAds.length,
        itemBuilder: (bc, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 120,
              height: 120,
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                width: 110,
                height: 110,
                padding: EdgeInsets.all(
                  10,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      imagesAds[index],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
