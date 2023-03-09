import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/presentation/Providers/inherited_widgets/parent_user_provider.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:clinic/global/theme/fonts/app_fonst.dart';
import 'package:clinic/global/widgets/circular_icon_button.dart';

// ignore: must_be_immutable
class GenderSelectorWidget extends StatefulWidget {
  const GenderSelectorWidget({
    super.key,
  });

  @override
  State<GenderSelectorWidget> createState() => _GenderSelectorWidgetState();
}

class _GenderSelectorWidgetState extends State<GenderSelectorWidget> {
  bool _maleselected = true;
  bool _femaleselected = false;
  @override
  Widget build(BuildContext context) {
    var provider = ParentUserProvider.of(context);

    return Column(
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'النوع',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: LightThemeColors.primaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularIconButton(
                onPressed: () => onButtonPressed(Gender.male, provider),
                selected: _maleselected,
                child: const Icon(
                  Icons.man,
                ),
              ),
              CircularIconButton(
                onPressed: () => onButtonPressed(Gender.female, provider),
                selected: _femaleselected,
                child: const Icon(
                  Icons.woman,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void onButtonPressed(Gender gender, ParentUserProvider? provider) {
    setState(() {
      switch (gender) {
        case Gender.male:
          _maleselected = true;
          _femaleselected = false;
          break;
        case Gender.female:
          _femaleselected = true;
          _maleselected = false;
          break;
      }
      if (provider!.userType == UserType.doctor) {
        provider.doctorModel!.gender = gender;
      } else {
        provider.userModel!.gender = gender;
      }
    });
  }
}
