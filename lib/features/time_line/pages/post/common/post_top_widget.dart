import 'package:clinic/features/time_line/pages/post/common/post_side_info.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostTopWidget extends StatelessWidget {
  const PostTopWidget({
    Key? key,
    required this.userName,
    required this.personalImageURL,
    required this.setSideInfo,
    this.postSideInfoText,
    this.postSideInfoTextColor,
    this.postSideInfoImageAsset,
    required this.timestamp,
  }) : super(key: key);
  final bool setSideInfo;
  final String userName;
  final String personalImageURL;
  final String? postSideInfoText;
  final Color? postSideInfoTextColor;
  final String? postSideInfoImageAsset;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        setSideInfo
            ? PostSideInfo(
                text: postSideInfoText!,
                textColor: postSideInfoTextColor!,
                imageAsset: postSideInfoImageAsset!,
              )
            : const SizedBox(),
        UserNameAndPicWidget(
          userName: userName,
          userPic: personalImageURL,
          timestamp: timestamp,
        ),
      ],
    );
  }
}
