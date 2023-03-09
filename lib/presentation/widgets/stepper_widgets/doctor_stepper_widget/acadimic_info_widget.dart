import 'dart:io';

import 'package:clinic/data/models/clinic_model.dart';
import 'package:clinic/presentation/Providers/inherited_widgets/parent_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/theme/fonts/app_fonst.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/presentation/widgets/clinic_page.dart';
import 'package:clinic/global/theme/colors/light_theme_colors.dart';

class AcadimicInfoWidget extends StatefulWidget {
  const AcadimicInfoWidget({
    super.key,
  });

  @override
  State<AcadimicInfoWidget> createState() => _AcadimicInfoWidgetState();
}

class _AcadimicInfoWidgetState extends State<AcadimicInfoWidget> {
  late GlobalKey<FormState> formKey;
  ImagePicker imagePicker = ImagePicker();
  XFile? _idImage;
  final List<ClinicPage> _clinics = [];
  @override
  Widget build(BuildContext context) {
    var doctorProvider = ParentUserProvider.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/img/academic_data.png',
              width: 90,
            ),
          ),
          const SizedBox(height: 50),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              ' الدرجة العلمية',
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: LightThemeColors.primaryColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: LightThemeColors.primaryColor,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                items: AppConstants.doctorDegrees
                    .map(
                      (degree) => DropdownMenuItem(
                        value: degree,
                        child: Text(
                          degree,
                          style: const TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (item) {
                  setState(() {
                    doctorProvider.doctorModel!.degree = item!;
                  });
                },
                value: doctorProvider!.doctorModel!.degree,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'التخصص',
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: LightThemeColors.primaryColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: LightThemeColors.primaryColor,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                items: AppConstants.doctorSpecializations
                    .map(
                      (specialization) => DropdownMenuItem(
                        value: specialization,
                        child: Text(
                          specialization,
                          style: const TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (item) {
                  setState(() {
                    doctorProvider.doctorModel!.specialization = item!;
                  });
                },
                value: doctorProvider.doctorModel!.specialization,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyAlertDialog.getInfoAlertDialog(
                context,
                'لماذا صورة بطاقة نقابة الأطباء؟',
                AppConstants.whyMedicalId,
                {
                  'أعي ذلك': () => Navigator.of(context).pop(),
                },
              ),
              const Text(
                'بطاقة نقابة الأطباء',
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: LightThemeColors.primaryColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: LightThemeColors.primaryColor,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: LightThemeColors.primaryColor,
                ),
                onPressed: () async {
                  _idImage = await imagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);

                  setState(() {
                    doctorProvider.doctorModel!.medicalIdImage =
                        File(_idImage!.path);
                  });
                },
                child: Icon(
                  Icons.photo,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: LightThemeColors.primaryColor,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: LightThemeColors.primaryColor,
                ),
                onPressed: () async {
                  _idImage = await imagePicker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                      preferredCameraDevice: CameraDevice.rear);

                  setState(() {
                    doctorProvider.doctorModel!.medicalIdImage =
                        File(_idImage!.path);
                  });
                },
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 10),
              (doctorProvider.doctorModel!.medicalIdImage != null)
                  ? const Icon(
                      Icons.done_rounded,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                    )
            ],
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'العيادات',
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: LightThemeColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: _clinics,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: LightThemeColors.primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  doctorProvider.doctorModel!.clinics.add(ClinicModel());
                  int index = _clinics.length;
                  setState(() {
                    _clinics.add(ClinicPage(
                      index: index,
                    ));
                  });
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'إضافة عيادة',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
              (_clinics.isNotEmpty)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: LightThemeColors.primaryColor)),
                        backgroundColor: Colors.white,
                        foregroundColor: LightThemeColors.primaryColor,
                      ),
                      onPressed: () {
                        MyAlertDialog.showAlertDialog(
                            context,
                            'هل أنت متأكد من إزالة العيادة ؟',
                            null,
                            MyAlertDialog.getAlertDialogActions({
                              'متأكد': () {
                                setState(() {
                                  doctorProvider.doctorModel!.clinics
                                      .removeLast();
                                  _clinics.removeLast();
                                });
                                Navigator.of(context).pop();
                              },
                              'إلغاء': () => Navigator.of(context).pop(),
                            }));
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.remove,
                            color: LightThemeColors.primaryColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'إزالة عيادة',
                            style: TextStyle(
                                color: LightThemeColors.primaryColor,
                                fontFamily: AppFonts.mainArabicFontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
