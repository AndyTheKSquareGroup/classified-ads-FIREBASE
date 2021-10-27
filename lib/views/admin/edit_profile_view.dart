import 'package:classifiedapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../services/auth.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  var profileData = {};
  EditProfileScreen({
    Key? key,
    required this.profileData,
  }) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // FORM'S CONTROLLERS
  TextEditingController _nameUserCrtl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _mobileCtrl = TextEditingController();

  // FUNCTION CHANGE PROFILE'S PHOTO
  changePhoto() async {
    try {
      var photo = await ImagePicker().pickImage(source: ImageSource.gallery);
      var request = http.MultipartRequest(
          "POST", Uri.parse("https://adlisting.herokuapp.com/upload/profile"));
      request.files.add(
        await http.MultipartFile.fromPath(
          "avatar",
          photo!.path,
        ),
      );
      var response = await http.Response.fromStream(await request.send());
      var data = json.decode(response.body);
      var imgURL = data["data"]["path"];
      setState(() {
        widget.profileData["imgURL"] = imgURL;
      });
    } catch (e) {}
  }

  // FUNCTION  UPDATE INFO PROFILE
  Auth _auth = Get.put(Auth());
  changeInfoProfile() async {
    var body = json.encode({
      "name": _nameUserCrtl.text,
      "email": _emailCtrl.text,
      "mobile": _mobileCtrl.text,
      "imgURL": widget.profileData["imgURL"],
    });
    try {
      var token = _auth.token.value;
      await http
          .patch(
        Uri.parse("https://adlisting.herokuapp.com/user/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      )
          .then((res) {
        var data = json.decode(res.body);
        print("succes");
      }).catchError((e) {});
    } catch (e) {}
  }

  // INIT
  @override
  void initState() {
    setState(() {
      _nameUserCrtl.text = widget.profileData["name"];
      _emailCtrl.text = widget.profileData["email"];
      _mobileCtrl.text = widget.profileData["mobile"];
    });
    super.initState();
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
                      changePhoto();
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.profileData["imgURL"],
                      ),
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
                  onPressed: () {},
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
