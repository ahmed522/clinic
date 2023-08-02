import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/single_clinic_preview_dialog.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class PresentSelectedClinicsWidget extends StatelessWidget {
  const PresentSelectedClinicsWidget({
    Key? key,
    required this.post,
    this.isNewClinicPost = false,
  }) : super(key: key);

  final DoctorPostModel post;
  final bool isNewClinicPost;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              isNewClinicPost ? 'العيادات الجديدة' : 'العيادات المخفضة',
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: (CommonFunctions.isLightMode(context))
                    ? isNewClinicPost
                        ? Colors.blueAccent
                        : AppColors.discountColor
                    : Colors.white,
              ),
            ),
          ),
        ),
        Column(
          children: List<Widget>.generate(
            post.selectedClinics!.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _previewClinic(context, post.doctorId!,
                          post.selectedClinics![index], index),
                      style: Theme.of(context).elevatedButtonTheme.style,
                      child: (size.width < 330)
                          ? const Icon(Icons.preview_rounded)
                          : Text(
                              'معاينة',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                    ),
                    Text(
                      'عيادة رقم ${index + 1}',
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontSize: (size.width < 330) ? 12 : 15,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _previewClinic(
      BuildContext context, String doctorId, String clinicId, int index) async {
    ClinicModel? clinic = await UserDataController.find
        .getDoctorSingleClinicById(doctorId, clinicId);

    if (clinic != null) {
      showDialog(
        context: context,
        builder: (context) => SingleClinicPreviewDialog(
          clinic: clinic,
          index: index,
          doctorId: post.doctorId!,
        ),
      );
    }
  }
}
