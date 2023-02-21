import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/colors/light_theme_colors.dart';
import '../theme/fonts/app_fonst.dart';

// ignore: must_be_immutable
class ImageSourcePage extends StatelessWidget {
  ImageSourcePage({super.key});
  XFile? userImage;
  final ImagePicker _imagePicker = ImagePicker();
  void Function(XFile? image)? onPressed;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        bottom: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(
                Icons.camera_alt_rounded,
                size: 50,
                color: LightThemeColors.primaryColor,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  userImage = await _imagePicker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                      preferredCameraDevice: CameraDevice.rear);
                  onPressed!(userImage);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: LightThemeColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: LightThemeColors.primaryColor,
                    ),
                  ),
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'كاميرا',
                  style: TextStyle(
                    color: LightThemeColors.primaryColor,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: (size.width < 370) ? 15 : 20,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.image,
                size: 50,
                color: LightThemeColors.primaryColor,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  userImage = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                      preferredCameraDevice: CameraDevice.rear);
                  onPressed!(userImage);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: LightThemeColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                          color: LightThemeColors.primaryColor)),
                ),
                child: Text(
                  'المعرض',
                  style: TextStyle(
                    color: LightThemeColors.primaryColor,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: (size.width < 370) ? 15 : 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
