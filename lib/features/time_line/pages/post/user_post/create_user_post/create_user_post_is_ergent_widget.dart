import 'package:clinic/features/time_line/controller/create_user_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPostIsErgentWidget extends StatelessWidget {
  const CreateUserPostIsErgentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'هل الحالة طارئة؟',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        GetBuilder<CreateUserPostController>(builder: (controller) {
          return Switch(
            activeColor: Colors.red,
            value: controller.postModel.isErgent,
            onChanged: (value) => controller.updateErgentCase(value),
          );
        }),
      ],
    );
  }
}
