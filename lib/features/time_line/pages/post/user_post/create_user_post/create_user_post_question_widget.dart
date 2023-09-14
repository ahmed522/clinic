import 'package:clinic/features/time_line/controller/create_user_post_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class CreateUserPostQuestionWidget extends StatelessWidget {
  const CreateUserPostQuestionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CreateUserPostController.find;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'إطرح سؤالك',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: (CommonFunctions.isLightMode(context))
                    ? AppColors.primaryColor
                    : Colors.white,
              ),
            ),
          ),
          maxLength: 500,
          maxLines: null,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          onChanged: (content) {
            controller.tempContent = content;
          },
        ),
      ],
    );
  }
}
