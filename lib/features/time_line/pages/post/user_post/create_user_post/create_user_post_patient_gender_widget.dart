import 'package:clinic/features/time_line/controller/create_user_post_controller.dart';
import 'package:clinic/global/widgets/circular_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPostPatientGenderWidget extends StatelessWidget {
  const CreateUserPostPatientGenderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'نوع الحالة',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
          child: GetBuilder<CreateUserPostController>(
            builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularIconButton(
                    onPressed: () => controller.onMalePressed(),
                    selected: controller.maleSelected,
                    child: const Icon(
                      Icons.man,
                    ),
                  ),
                  CircularIconButton(
                    onPressed: () => controller.onBabyPressed(),
                    selected: controller.babySelected,
                    child: const Icon(
                      Icons.child_care_rounded,
                      size: 35,
                    ),
                  ),
                  CircularIconButton(
                    onPressed: () => controller.onFemalePressed(),
                    selected: controller.femaleSelected,
                    child: const Icon(
                      Icons.woman,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
