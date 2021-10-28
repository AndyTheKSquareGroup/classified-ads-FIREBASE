import 'package:classifiedapp/views/auth/login_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:math';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  // var profileData = {};
  EditProfileScreen({
    Key? key,
    // required this.profileData,
  }) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // FORM'S CONTROLLERS
  TextEditingController _nameUserCrtl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _mobileCtrl = TextEditingController();

  //INIT GET INFORMATION PROFILE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readUserData();
  }

  //GET INFORMATION PROFILE
  readUserData() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((user) {
      print(user.data());
      var userData = user.data()!;
      _nameUserCrtl.text = userData["username"];
      _emailCtrl.text = userData["email"];
      _mobileCtrl.text = userData["phoneNumber"];
    });
  }

  // FUNCTION  UPDATE INFO PROFILE
  changeInfoProfile() {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection("users").doc(uid).update({
      "username": _nameUserCrtl.text,
      "email": _emailCtrl.text,
      "phoneNumber": _mobileCtrl.text
    }).then((value) {
      print("Update");
    });
  }

  // EXIT APP
  logout() {
    FirebaseAuth.instance.signOut().then((value) {
      Get.offAll(LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //BRAND
                Container(
                  padding: EdgeInsets.all(10),
                  height: 120,
                  width: 120,
                  child: GestureDetector(
                    onTap: () {
                      // changePhoto();
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage("images/profile.jfif"),
                    ),
                  ),
                ),

                // FORM
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // USER NAME
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        controller: _nameUserCrtl,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // USER EMAIL
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        controller: _emailCtrl,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // USER NUMBER
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: TextField(
                        controller: _mobileCtrl,
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
                          changeInfoProfile();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            primary: Colors.deepOrange),
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                // CREATE NEW ACCOUNT
                TextButton(
                  onPressed: () {
                    logout();
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
