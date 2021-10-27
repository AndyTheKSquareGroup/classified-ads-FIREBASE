import 'dart:convert';
import 'package:classifiedapp/services/auth.dart';
import 'package:classifiedapp/views/admin/model_my_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/auth.dart';

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
  Auth _auth = Get.put(Auth());

  getAds() async {
    try {
      var token = _auth.token.value;
      await http.post(
        Uri.parse("https://adlisting.herokuapp.com/ads/user"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).then((resp) {
        var data = json.decode(resp.body);
        setState(() {
          var data = json.decode(resp.body);
          _myAds = data["data"];
        });
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
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
      body: Container(
        child: _myAds.isEmpty
            ? Text(
                "Starting...",
              )
            : buildListViewMyAds(),
      ),
    );
  }

  ListView buildListViewMyAds() {
    return ListView.builder(
      itemCount: _myAds.length,
      itemBuilder: (bc, index) {
        return ModelForAdsScreen(
          adInfo: _myAds[index],
        );
      },
    );
  }
}
