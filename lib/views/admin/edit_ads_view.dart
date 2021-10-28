import 'package:classifiedapp/views/admin/home_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class EditAdsScreen extends StatefulWidget {
  var image = [];
  String title = "";
  String description = "";
  String price = "";
  String phone = "";
  EditAdsScreen(
      {required this.image,
      required this.title,
      required this.description,
      required this.price,
      required this.phone});

  _EditAdsScreenState createState() => _EditAdsScreenState();
}

class _EditAdsScreenState extends State<EditAdsScreen> {
  // FUCNTION FOR GETTING MY ADS
  editMyAds() {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection("ads").doc(uid).update({
      "title": _titleAds.text,
      "price": _priceAds.text,
      "phoneNumber": _mobileContactAds.text,
      "description": _decriptionAds.text,
      "imageURL": updatedImg,
    }).then((value) {
      print("Update Ad");
    });
  }

  //UPLOAD IMAGES
  var updatedImg = [];

  getImages() async {
    var picker = ImagePicker();
    var pickedFiles = await picker.pickMultiImage();
    if (pickedFiles!.isNotEmpty) {
      updatedImg.clear();
      for (var image in pickedFiles) {
        File img = File(image.path);
        var rng = Random();
        FirebaseStorage.instance
            .ref()
            .child("imageURL")
            .child(rng.nextInt(10000).toString())
            .putFile(img)
            .then((res) {
          res.ref.getDownloadURL().then((url) {
            setState(() {
              updatedImg.add(url);
            });
          });
        }).catchError((e) {});
      }
    }
  }

  //RECOVERED DATAS
  @override
  void initState() {
    setState(() {
      _titleAds.text = widget.title;
      _decriptionAds.text = widget.description;
      _priceAds.text = widget.price;
      _mobileContactAds.text = widget.phone;
      // userID = widget.user;
    });
    super.initState();
  }

  // CONTROLLERS FORM
  TextEditingController _titleAds = TextEditingController();
  TextEditingController _priceAds = TextEditingController();
  TextEditingController _mobileContactAds = TextEditingController();
  TextEditingController _decriptionAds = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Ad"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                buildPhotoIcon(),
                updatedImg.isNotEmpty
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
                        controller: _titleAds,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    //ADS' PRICE
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        controller: _priceAds,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    //ADS' MOBILE
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        controller: _mobileContactAds,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    //ADS' DESCRIPTION
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        minLines: 3,
                        maxLines: 5,
                        controller: _decriptionAds,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // BUTTON ENTER TO APP
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          editMyAds();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            primary: Colors.deepOrange),
                        child: Text(
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

  //ICON FOR UPLOADING IMAGEN
  GestureDetector buildPhotoIcon() {
    return GestureDetector(
      onTap: () {
        getImages();
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

  //SHOWING UPLOADED IMAGES
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
        itemCount: updatedImg.length,
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
                      updatedImg[index],
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
