import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/user_profile/pages/user_profile_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserFollowingCardWidget extends StatelessWidget {
  const UserFollowingCardWidget({
    Key? key,
    required this.follower,
  }) : super(key: key);

  final FollowerModel follower;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => UserProfilePage(
          userId: follower.userId,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Card(
          color: CommonFunctions.isLightMode(context)
              ? Colors.white
              : AppColors.darkThemeBottomNavBarColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.primaryColor
                  : Colors.white,
              width: .01,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  follower.userName,
                  style: TextStyle(
                    color: (CommonFunctions.isLightMode(context))
                        ? Colors.black87
                        : Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                (follower.userPersonalImage != null)
                    ? CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            follower.userPersonalImage!),
                        radius: 25,
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage('assets/img/user.png'),
                        radius: 25,
                        backgroundColor: AppColors.primaryColor,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
