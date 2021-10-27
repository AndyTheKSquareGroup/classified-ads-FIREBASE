import 'package:classifiedapp/views/admin/info_ads_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/auth.dart';
import 'package:classifiedapp/views/admin/create_ads_view.dart';
import 'package:classifiedapp/views/admin/settings_view.dart';

class HomeAdsScreen extends StatefulWidget {
  HomeAdsScreen({Key? key}) : super(key: key);

  _HomeAdsScreenState createState() => _HomeAdsScreenState();
}

class _HomeAdsScreenState extends State<HomeAdsScreen> {
  // SAVE USER´S TOKEN
  Auth _auth = Get.put(Auth());

//  FUNCTION GET ADS' LISTING
  List _ads = [];
  getAllAds() async {
    try {
      var token = _auth.token.value;
      print(token);

      http.get(Uri.parse("https://adlisting.herokuapp.com/ads"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }).then((res) {
        print(res.body);
        var resp = json.decode(res.body);
        setState(() {
          _ads = resp["data"];
          getProfileData();
        });
        print(resp);
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  //INFO PROFILE
  var _profileUser = {};
  getProfileData() {
    try {
      var token = _auth.token.value;
      http.post(
        Uri.parse("https://adlisting.herokuapp.com/user/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).then((res) {
        var data = json.decode(res.body);
        setState(() {
          var data = json.decode(res.body);
          _profileUser = data["data"];
        });
      }).catchError((e) {});
    } catch (e) {}
  }

  //INIT ADS
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
                SettingsScreen(
                  userLoginData: _profileUser,
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(_profileUser["imgURL"]),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: GridView.builder(
        itemCount: _ads.length,
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
                  imgURL: _ads[index]["images"][0],
                  title: _ads[index]['title'],
                  description: _ads[index]['description'],
                  price: _ads[index]['price'].toString(),
                  authorName: _ads[index]['authorName'],
                  numberPhone: _ads[index]["mobile"],
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
                      _ads[index]['images'][0],
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
                                    _ads[index]['title'],
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
                                    _ads[index]['price'].toString(),
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
