import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_location_and_region_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/data/services/location_services.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicLocationWidget extends StatelessWidget {
  const ClinicLocationWidget({
    Key? key,
    this.clinicIndex,
    this.isDoctorPost = false,
    this.clinicModel,
  }) : super(key: key);

  final int? clinicIndex;
  final bool isDoctorPost;
  final ClinicModel? clinicModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final ClinicModel clinic;
    if (isDoctorPost) {
      clinic = clinicModel!;
    } else {
      final controller = DoctorClinicsController.find;
      clinic = controller.clinics[clinicIndex!];
    }
    return Column(
      children: [
        isDoctorPost || size.width < 330
            ? Column(
                children: [
                  ClinicLocationAndRegionWidget(
                    governorate: clinic.governorate,
                    region: clinic.region,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )
            : const SizedBox(),
        Row(
          mainAxisSize: isDoctorPost || size.width < 330
              ? MainAxisSize.min
              : MainAxisSize.max,
          mainAxisAlignment: isDoctorPost
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () {
                MyAlertDialog.showAlertDialog(
                  context,
                  'موقع العيادة',
                  clinic.location,
                  MyAlertDialog.getAlertDialogActions(
                    _getActions(
                      context,
                      clinic.locationLatitude,
                      clinic.locationLongitude,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: (CommonFunctions.isLightMode(context))
                        ? AppColors.darkThemeBackgroundColor
                        : Colors.white,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'تفاصيل الموقع',
                    style: TextStyle(
                      color: (CommonFunctions.isLightMode(context))
                          ? AppColors.darkThemeBackgroundColor
                          : Colors.white,
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            isDoctorPost || size.width < 330
                ? const SizedBox()
                : ClinicLocationAndRegionWidget(
                    governorate: clinic.governorate,
                    region: clinic.region,
                  ),
          ],
        ),
      ],
    );
  }

  Map<String, void Function()?> _getActions(BuildContext context,
      double? locationLatitude, double? locationLongitude) {
    Map<String, void Function()?> actions = {
      'العودة': () => Get.back(),
    };
    actions.addIf(
        locationLatitude != null,
        'الإتجاهات',
        () async => await LocationServices.openMapsSheet(
            context, locationLatitude!, locationLongitude!));
    return actions;
  }
}
