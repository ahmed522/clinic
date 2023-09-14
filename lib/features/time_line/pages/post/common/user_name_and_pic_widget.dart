import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserNameAndPicWidget extends StatelessWidget {
  final Timestamp? timestamp;
  final String userName;
  final String? userPic;
  const UserNameAndPicWidget({
    super.key,
    required this.userName,
    required this.userPic,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              userName,
              style: TextStyle(
                  color: (CommonFunctions.isLightMode(context))
                      ? Colors.black87
                      : Colors.white,
                  fontSize: 14),
            ),
            const SizedBox(height: 5),
            (timestamp != null)
                ? Text(
                    '${CommonFunctions.getTime(timestamp!)}   ${CommonFunctions.getDate(timestamp!)}',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: (CommonFunctions.isLightMode(context))
                          ? Colors.black87
                          : Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                    ),
                  )
                : const SizedBox()
          ],
        ),
        const SizedBox(width: 15),
        (userPic != null)
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(userPic!),
                radius: 25,
              )
            : const CircleAvatar(
                backgroundImage: AssetImage('assets/img/user.png'),
                radius: 25,
                backgroundColor: AppColors.primaryColor,
              ),
      ],
    );
  }
}
