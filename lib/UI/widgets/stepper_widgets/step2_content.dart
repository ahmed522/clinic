import 'package:clinic/UI/widgets/clinic.dart';
import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../global/constants/app_constants.dart';
import '../../../global/theme/fonts/app_fonst.dart';
import '../../../global/widgets/alert_dialog.dart';

// ignore: must_be_immutable
class Step2Content extends StatefulWidget {
  bool idImageIsSet = false;
  List<Clinic> clinics = [];
  Step2Content({super.key});

  @override
  State<Step2Content> createState() => _Step2ContentState();
}

class _Step2ContentState extends State<Step2Content> {
  late GlobalKey<FormState> formKey;
  String? _selectedDegree = 'طبيب امتياز';
  String? _selectedSpecialization = 'طبيب عام ';
  String? _selectedRegion = 'حلوان';

  ImagePicker imagePicker = ImagePicker();
  XFile? _idImage;

  @override
  Widget build(BuildContext context) {
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
                    _selectedDegree = item;
                  });
                },
                value: _selectedDegree,
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
                    _selectedSpecialization = item;
                  });
                },
                value: _selectedSpecialization,
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
                  if (_idImage != null) {
                    setState(() {
                      widget.idImageIsSet = true;
                    });
                  }
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
                  if (_idImage != null) {
                    setState(() {
                      widget.idImageIsSet = true;
                    });
                  }
                },
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 10),
              widget.idImageIsSet
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyAlertDialog.getInfoAlertDialog(
                context,
                'أين باقي المناطق؟',
                AppConstants.whereIsRestRegions,
                {
                  'أعي ذلك': () => Navigator.of(context).pop(),
                },
              ),
              const Text(
                'المنطقة',
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: LightThemeColors.primaryColor,
                ),
              ),
            ],
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
                items: AppConstants.regions
                    .map(
                      (region) => DropdownMenuItem(
                        value: region,
                        child: Text(
                          region,
                          style: const TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (item) {
                  setState(() {
                    _selectedRegion = item;
                  });
                },
                value: _selectedRegion,
              ),
            ),
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
            children: widget.clinics,
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
                  Clinic clinic = Clinic(
                    index: widget.clinics.length + 1,
                  );
                  setState(() {
                    widget.clinics.add(clinic);
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
              (widget.clinics.isNotEmpty)
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
                                  widget.clinics.removeLast();
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
