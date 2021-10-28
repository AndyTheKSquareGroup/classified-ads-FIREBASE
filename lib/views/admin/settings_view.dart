import 'package:classifiedapp/views/admin/my_ads_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:classifiedapp/views/admin/edit_profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  // var userLoginData = {};
  SettingsScreen({
    Key? key,
    // required this.userLoginData,
  }) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    readAdsData();
    readUserData();
  }

  List _adsData = [];
  String name = "";
  String mobile = "";
  String image = "";

  readAdsData() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("ads")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        // adDataList.add(doc.data());
        _adsData.add({"adID": doc.id, "adData": doc.data()});
      });
      setState(() {});
    });
  }

  readUserData() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((resp) {
      name = resp["username"];
      mobile = resp["phoneNumber"];
      image = resp["imageURL"];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Settings",
        ),
      ),
      body: ListView(
        children: [
          //ACCES EDIT PROFILE SCREEN
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(image),
            ),
            title: Text(
              name,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              mobile,
            ),
            trailing: Text(
              "Edit",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            onTap: () {
              Get.to(EditProfileScreen());
            },
          ),
          //ACCES MY ADS SCREEN
          ListTile(
            leading: Icon(Icons.post_add_outlined),
            title: Text(
              "My Ads",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Get.to(
                myAdsScreen(),
              );
            },
          ),
          // DISABLED ABOUT US
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text(
              "About Us",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
          // DISABLED CONTACT US
          ListTile(
            leading: Icon(Icons.contacts_rounded),
            title: Text(
              "Contact Us",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
