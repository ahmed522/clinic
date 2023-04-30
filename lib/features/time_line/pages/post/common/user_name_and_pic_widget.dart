import 'package:flutter/material.dart';

class UserNameAndPicWidget extends StatelessWidget {
  final String userName;
  final String userPic;
  const UserNameAndPicWidget(
      {super.key, required this.userName, required this.userPic});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          userName,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(width: 15),
        CircleAvatar(
          backgroundImage: AssetImage(userPic),
          radius: 26,
        ),
      ],
    );
  }
}
