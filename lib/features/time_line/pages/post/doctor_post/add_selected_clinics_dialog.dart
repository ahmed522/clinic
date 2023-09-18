import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/time_line/controller/create_doctor_post_controller.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/single_clinic_preview_dialog.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSelectedClinicDialog extends StatelessWidget {
  const AddSelectedClinicDialog({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = CreateDoctorPostController.find;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      scrollable: true,
      title: Text(
        'إضافة عيادة',
        textAlign: TextAlign.end,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.darkThemeBackgroundColor
              : Colors.white,
        ),
      ),
      content: (controller.selectedClinics!.isEmpty)
          ? Center(
              child: Text(
                'لا توجد عيادات',
                style: TextStyle(
                  color: CommonFunctions.isLightMode(context)
                      ? Colors.black
                      : Colors.white,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontSize: 20,
                ),
              ),
            )
          : Column(
              children: [
                Text(
                  'العيادات',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: List<Widget>.generate(
                      controller.selectedClinics!.length,
                      (index) {
                        String clinicId =
                            controller.selectedClinics!.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    _previewClinic(context, clinicId, index),
                                style:
                                    Theme.of(context).elevatedButtonTheme.style,
                                child: (size.width < 330)
                                    ? const Icon(Icons.preview_rounded)
                                    : Text(
                                        'معاينة',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'عيادة رقم ${index + 1}',
                                    style: TextStyle(
                                      fontFamily: AppFonts.mainArabicFontFamily,
                                      fontSize: (size.width < 330) ? 12 : 15,
                                    ),
                                  ),
                                  GetBuilder<CreateDoctorPostController>(
                                      builder: (controller) {
                                    return Checkbox(
                                      value:
                                          controller.selectedClinics![clinicId],
                                      onChanged: (value) =>
                                          controller.updateCheckedClinic(
                                              value!, clinicId),
                                      activeColor: AppColors.primaryColor,
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      actions: MyAlertDialog.getAlertDialogActions(_getActions(context)),
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
    );
  }

  Map<String, void Function()?> _getActions(BuildContext context) {
    final controller = CreateDoctorPostController.find;

    Map<String, void Function()?> actions = {
      'العودة': () {
        Get.back();
        controller.initializeSelectedClinics();
      },
    };
    actions.addIf((controller.selectedClinics!.isNotEmpty), 'تأكيد',
        () => controller.confirmSelectedClinics());
    return actions;
  }

  _previewClinic(BuildContext context, String clinicId, int index) async {
    final controller = CreateDoctorPostController.find;
    ClinicModel? clinic =
        await UserDataController.find.getDoctorSingleClinicById(clinicId);
    if (clinic != null) {
      showDialog(
        context: context,
        builder: (context) => SingleClinicPreviewDialog(
          clinic: clinic,
          index: index,
          doctorId: controller.currentDoctorId,
        ),
      );
    }
  }
}
