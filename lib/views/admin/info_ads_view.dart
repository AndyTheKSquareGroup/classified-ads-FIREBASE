import 'package:classifiedapp/views/admin/show_images_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class InfoAdsScreen extends StatelessWidget {
  String imgURL = "";
  String title = "";
  String description = "";
  String price = "";
  String authorName = "";
  String numberPhone = "";
  InfoAdsScreen({
    required this.imgURL,
    required this.title,
    required this.description,
    required this.price,
    required this.authorName,
    required this.numberPhone,
  });
  // ACCESS CONTACTS
  var infoAd = {};
  @override
  Widget build(BuildContext context) {
    //
    _launcherURL(_url) async => await canLaunch(_url)
        ? await launch(_url)
        : throw "Couldn't launch $_url";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$title",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  "$price",
                  style: TextStyle(color: Colors.orange, fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(ShowOnlyImagesScreen(img: imgURL));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$imgURL"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.person_outline_outlined),
                            Text("$authorName"),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.watch_later_outlined),
                            Text("18 days ago"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "$description",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                // BUTTON FOR CALLING THE SELLER
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      _launcherURL("tel: " + numberPhone);
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        primary: Colors.deepOrange),
                    child: Text(
                      "Contact Seller",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
