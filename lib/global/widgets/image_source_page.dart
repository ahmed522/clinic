import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:clinic/global/colors/app_colors.dart';

// ignore: must_be_immutable
class ImageSourcePage extends StatelessWidget {
  ImageSourcePage({super.key});
  XFile? userImage;
  final ImagePicker _imagePicker = ImagePicker();
  void Function(XFile? image)? onPressed;
  @override
  Widget build(BuildContext context) {
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
              Icon(
                Icons.camera_alt_rounded,
                size: 50,
                color: (Theme.of(context).brightness == Brightness.light)
                    ? AppColors.primaryColor
                    : Colors.white,
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
                style: Theme.of(context).elevatedButtonTheme.style,
                child: Text(
                  'كاميرا',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.image,
                size: 50,
                color: (Theme.of(context).brightness == Brightness.light)
                    ? AppColors.primaryColor
                    : Colors.white,
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
                style: Theme.of(context).elevatedButtonTheme.style,
                child: Text(
                  'المعرض',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
