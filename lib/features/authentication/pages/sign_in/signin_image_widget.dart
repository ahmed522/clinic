import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninImageWidget extends StatelessWidget {
  const SigninImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double loadingIndicatorSize =
        (size.width > AppConstants.phoneWidth) ? 100 : 80;
    return Stack(
      children: [
        GetBuilder<SigninController>(
          init: SigninController(),
          builder: (controller) {
            return controller.loading
                ? AppCircularProgressIndicator(
                    width: loadingIndicatorSize,
                    height: loadingIndicatorSize,
                  )
                : const SizedBox();
          },
        ),
        Image.asset(
          'assets/img/signin.png',
          width: (size.width < AppConstants.phoneWidth) ? 80 : 100,
        ),
      ],
    );
  }
}
