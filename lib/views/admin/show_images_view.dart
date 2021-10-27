import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowOnlyImagesScreen extends StatelessWidget {
  String img;
  ShowOnlyImagesScreen({
    Key? key,
    required this.img,
  }) : super(
          key: key,
        );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(img),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
