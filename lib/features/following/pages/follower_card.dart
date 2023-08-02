import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/following/pages/doctor_following_card_widget.dart';
import 'package:clinic/features/following/pages/user_following_card_widget.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';

class FollowerCard extends StatelessWidget {
  const FollowerCard({
    super.key,
    required this.follower,
    this.onUnfollowButtonPressed,
  });
  final FollowerModel follower;
  final void Function()? onUnfollowButtonPressed;

  @override
  Widget build(BuildContext context) {
    if (follower.userType == UserType.user) {
      return UserFollowingCardWidget(follower: follower);
    }
    return DoctorFollowingCardWidget(
      follower: follower,
      onUnfollowButtonPressed: () => onUnfollowButtonPressed,
    );
  }
}
