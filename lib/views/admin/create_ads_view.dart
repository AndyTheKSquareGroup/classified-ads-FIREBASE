import 'dart:convert';
import 'package:classifiedapp/views/admin/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth.dart';
import 'package:http/http.dart' as http;

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({Key? key}) : super(key: key);
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
  Auth _auth = Get.put(Auth());
  createAds() async {
    var body = json.encode({
      "title": _titleAdsCtrl.text,
      "description": _decriptionAdsCtrl.text,
      "price": _priceAdsCtrl.text,
      "mobile": _mobileContactAdsCtrl.text,
      "images": imagesAds
    });
    try {
      var token = _auth.token.value;
      await http
          .post(
        Uri.parse("https://adlisting.herokuapp.com/ads"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      )
          .then((res) {
        var data = json.decode(res.body);
        print(data);
        Get.offAll(HomeAdsScreen());
      }).catchError((e) {});
    } catch (e) {}
  }

  // CAPTURE IMAGE
  var imagesAds = [];
  captureImages() async {
    try {
      var capturedImages = await ImagePicker().pickMultiImage();
      var redRequest = http.MultipartRequest(
        "POST",
        Uri.parse("https://adlisting.herokuapp.com/upload/photos"),
      );
      capturedImages!.forEach((photo) async {
        redRequest.files.add(
          await http.MultipartFile.fromPath(
            "photos",
            photo.path,
          ),
        );
      });
      var result = await http.Response.fromStream(await redRequest.send());
      var data = json.decode(result.body);

      setState(() {
        imagesAds = data["data"]["path"];
      });
    } catch (e) {}
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
                          createAds();
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
