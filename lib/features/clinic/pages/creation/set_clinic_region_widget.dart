import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/global/constants/regions.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetClinicRegionWidget extends StatelessWidget {
  const SetClinicRegionWidget({
    Key? key,
    required this.index,
    required this.mode,
  }) : super(key: key);

  final int index;
  final ClinicPageMode mode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyAlertDialog.getInfoAlertDialog(
              context,
              'المنطقة الجغرافية',
              AppConstants.regionInfo,
              {
                'أعي ذلك': () => Navigator.of(context).pop(),
              },
            ),
            Text(
              'المنطقة',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 5,
              ),
              decoration: BoxDecoration(
                color: (CommonFunctions.isLightMode(context))
                    ? Colors.white
                    : AppColors.darkThemeBottomNavBarColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0.2,
                    blurRadius: 0.7,
                    offset: Offset(0, 0.2),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: (mode == ClinicPageMode.signupMode)
                    ? GetBuilder<SignupController>(
                        tag: DoctorSignUpParent.route,
                        builder: (controller) {
                          return AppDropdownButton(
                            items: Regions
                                .governoratesAndRegions[
                                    (controller as DoctorSignupController)
                                        .doctorModel
                                        .clinics[index]
                                        .governorate]!
                                .keys
                                .toList(),
                            onChanged: (item) =>
                                controller.updateClinicRegion(item!, index),
                            value: controller.doctorModel.clinics[index].region,
                          );
                        },
                      )
                    : GetBuilder<SingleClinicController>(
                        builder: (controller) {
                          return AppDropdownButton(
                            items: Regions
                                .governoratesAndRegions[
                                    controller.tempClinic.governorate]!
                                .keys
                                .toList(),
                            onChanged: (item) =>
                                controller.updateClinicRegion(item!, index),
                            value: controller.tempClinic.region,
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
