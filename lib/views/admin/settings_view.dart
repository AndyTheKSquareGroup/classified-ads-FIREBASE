import 'package:classifiedapp/views/admin/my_ads_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:classifiedapp/views/admin/edit_profile_view.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  var userLoginData = {};
  SettingsScreen({
    Key? key,
    required this.userLoginData,
  }) : super(key: key);

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
              backgroundImage: NetworkImage(userLoginData["imgURL"]),
            ),
            title: Text(
              userLoginData["name"],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userLoginData["mobile"],
            ),
            trailing: Text(
              "Edit",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            onTap: () {
              Get.to(EditProfileScreen(
                profileData: userLoginData,
              ));
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
