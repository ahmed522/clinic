import 'package:clinic/features/searching/model/search_option.dart';
import 'package:flutter/material.dart';

class SearchOptionItem extends StatelessWidget {
  const SearchOptionItem({
    Key? key,
    required this.option,
    this.textStyle,
  }) : super(key: key);
  final SearchOption option;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          _getSearchOptionImage,
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 5),
        Text(
          _getSearchOptionTitle,
          style: textStyle,
        )
      ],
    );
  }

  String get _getSearchOptionTitle {
    switch (option) {
      case SearchOption.doctors:
        return 'أطباء';
      case SearchOption.users:
        return 'مستخدمين';
      case SearchOption.clinics:
        return 'عيادات';
      case SearchOption.posts:
        return 'منشورات';
    }
  }

  String get _getSearchOptionImage {
    switch (option) {
      case SearchOption.doctors:
        return 'assets/img/following-doctors.png';
      case SearchOption.users:
        return 'assets/img/users.png';
      case SearchOption.clinics:
        return 'assets/img/clinic.png';
      case SearchOption.posts:
        return 'assets/img/posts.png';
    }
  }
}
