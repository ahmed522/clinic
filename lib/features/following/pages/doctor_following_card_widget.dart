import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_profile_page.dart';
import 'package:clinic/global/widgets/doctor_specialization_info_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:clinic/global/widgets/cropped_card_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorFollowingCardWidget extends StatelessWidget {
  const DoctorFollowingCardWidget({
    Key? key,
    required this.follower,
    required this.onUnfollowButtonPressed,
    this.isEditable = false,
  }) : super(key: key);

  final FollowerModel follower;
  final void Function() onUnfollowButtonPressed;
  final bool isEditable;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Get.to(
            () => DoctorProfilePage(
              isCurrentUser: follower.userId ==
                  AuthenticationController.find.currentUserId,
              doctorId: follower.userId,
            ),
            transition: Transition.rightToLeftWithFade,
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 5.0, right: 10.0, left: 10.0),
            color: CommonFunctions.isLightMode(context)
                ? Colors.white
                : AppColors.darkThemeBottomNavBarColor,
            elevation: 2.5,
            shape: isEditable
                ? CroppedCardBorder(
                    borderRadius: const Radius.circular(20.0),
                    holeSize: 40.0,
                    offset: const Offset(20, -20),
                    side: BorderSide(
                      color: (CommonFunctions.isLightMode(context))
                          ? AppColors.primaryColor
                          : Colors.white,
                      width: .0001,
                    ),
                  )
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: (CommonFunctions.isLightMode(context))
                          ? AppColors.primaryColor
                          : Colors.white,
                      width: .0001,
                    ),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        follower.gender == Gender.male
                            ? 'assets/img/male-doctor.png'
                            : 'assets/img/female-doctor.png',
                        width: 30,
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                follower.userPersonalImage!),
                            radius: 25,
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  DoctorSpecializationInfoWidget(
                      specialization: follower.doctorSpecialization!),
                  SizedBox(height: isEditable ? 10 : 3),
                ],
              ),
            ),
          ),
        ),
        isEditable
            ? Positioned(
                bottom: 6,
                left: 3,
                child: CircleButton(
                  backgroundColor: Colors.red,
                  onPressed: () => onUnfollowButtonPressed(),
                  child: const Icon(Icons.remove),
                ))
            : const SizedBox(),
      ],
    );
  }
}
