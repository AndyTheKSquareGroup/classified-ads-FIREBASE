import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_ads_view.dart';

// ignore: must_be_immutable
class myAdsScreen extends StatefulWidget {
  myAdsScreen({
    Key? key,
  }) : super(key: key);
  @override
  _myAdsScreenState createState() => _myAdsScreenState();
}

class _myAdsScreenState extends State<myAdsScreen> {
  // FUNCTION FOR GETTING MY ADS LIST
  var _myAds = [];

  getAds() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("ads")
        .where("uid", isEqualTo: uid)
        .get()
        .then((res) {
      var allAds = [];
      res.docs.forEach((ad) {
        allAds.add({
          "title": ad.data()["title"],
          "description": ad.data()["description"],
          "price": ad.data()["price"],
          "phoneNumber": ad.data()["phoneNumber"],
          "imageURL": ad.data()["imageURL"]
        });
        print(allAds);
      });
      setState(() {
        _myAds = allAds;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    getAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ads"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _myAds.length,
        itemBuilder: (bc, index) {
          return GestureDetector(
            onTap: () {
              Get.to(
                EditAdsScreen(
                  image: _myAds[index]['imageURL'],
                  title: _myAds[index]['title'],
                  description: _myAds[index]['description'],
                  price: _myAds[index]['price'],
                  phone: _myAds[index]['phoneNumber'].toString(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                shape: BoxShape.rectangle,
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 100,
                    width: 60,
                    child: Image.network(
                      "${_myAds[index]['imageURL'][0]}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_myAds[index]['title']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 15,
                                color: Colors.grey,
                              ),
                              Text(
                                "18 days ago",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${_myAds[index]['price']}",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
