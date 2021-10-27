import 'package:flutter/material.dart';
import 'package:classifiedapp/views/admin/edit_ads_view.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ModelForAdsScreen extends StatelessWidget {
  var adInfo = {};
  ModelForAdsScreen({
    Key? key,
    required this.adInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(EditAdsScreen(adInfo: adInfo));
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
                adInfo["images"][0],
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
                    adInfo["title"],
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
                    adInfo["price"].toString(),
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
  }
}
