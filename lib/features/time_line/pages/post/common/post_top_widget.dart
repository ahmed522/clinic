import 'package:clinic/features/doctor_profile/pages/doctor_profile_page.dart';
import 'package:clinic/features/time_line/pages/post/common/post_side_info.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:clinic/features/user_profile/pages/user_profile_page.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    required this.paddingValue,
    required this.onSettingsButtonPressed,
    required this.isCurrentUserPost,
    required this.isProfilePage,
    required this.userId,
    required this.userType,
  }) : super(key: key);
  final bool setSideInfo;
  final String userId;
  final UserType userType;
  final String userName;
  final String? personalImageURL;
  final String? postSideInfoText;
  final Color? postSideInfoTextColor;
  final String? postSideInfoImageAsset;
  final Timestamp timestamp;
  final double paddingValue;
  final bool isCurrentUserPost;
  final bool isProfilePage;
  final void Function() onSettingsButtonPressed;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: isProfilePage
          ? null
          : () {
              if (userType == UserType.user) {
                Get.to(
                  () => UserProfilePage(
                    userId: userId,
                  ),
                );
              } else {
                Get.to(
                  () => DoctorProfilePage(
                    isCurrentUser: isCurrentUserPost,
                    doctorId: userId,
                  ),
                );
              }
            },
      child: SizedBox(
        width: size.width - paddingValue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isCurrentUserPost
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: IconButton(
                          onPressed: () => onSettingsButtonPressed(),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.more_vert_rounded,
                          ),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  width: isCurrentUserPost ? 3 : 0,
                ),
                setSideInfo
                    ? PostSideInfo(
                        text: postSideInfoText!,
                        textColor: postSideInfoTextColor!,
                        imageAsset: postSideInfoImageAsset!,
                      )
                    : const SizedBox(),
              ],
            ),
            UserNameAndPicWidget(
              userName: userName,
              userPic: personalImageURL,
              timestamp: timestamp,
            ),
          ],
        ),
      ),
    );
  }
}
