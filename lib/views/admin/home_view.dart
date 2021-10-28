import 'package:classifiedapp/views/admin/info_ads_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:classifiedapp/views/admin/create_ads_view.dart';
import 'package:classifiedapp/views/admin/settings_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeAdsScreen extends StatefulWidget {
  HomeAdsScreen({Key? key}) : super(key: key);

  _HomeAdsScreenState createState() => _HomeAdsScreenState();
}

class _HomeAdsScreenState extends State<HomeAdsScreen> {
//  FUNCTION GET ADS' LISTING
  var _allAds = [];
  getAllAds() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("ads").get().then((res) {
      var allAds = [];
      res.docs.forEach((ad) {
        allAds.add({
          "title": ad.data()["title"],
          "description": ad.data()["description"],
          "price": ad.data()["price"],
          "imageURL": ad.data()["imageURL"]
        });
      });
      setState(() {
        _allAds = allAds;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    getAllAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("Ads Listing"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            //ACCESS TO SETTINGS
            onPressed: () {
              Get.to(
                SettingsScreen(),
              );
            },
            child: CircleAvatar(
              backgroundImage: AssetImage("images/profile.jfif"),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: GridView.builder(
        itemCount: _allAds.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(
                InfoAdsScreen(
                  imgURL: _allAds[index]["imageURL"][0],
                  title: _allAds[index]['title'],
                  description: _allAds[index]['description'],
                  price: _allAds[index]['price'].toString(),
                  authorName: _allAds[index]['authorName'],
                  numberPhone: _allAds[index]["phoneNumber"],
                ),
              );
            },
            child: Stack(
              children: [
                Align(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.network(
                      _allAds[index]['imageURL'][0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    _allAds[index]['title'],
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: Container(
                                  margin: EdgeInsets.only(top: 2, left: 5),
                                  child: Text(
                                    _allAds[index]['price'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add_a_photo_outlined),
        onPressed: () {
          Get.to(
            CreateAdScreen(),
          );
        },
      ),
    );
  }
}
