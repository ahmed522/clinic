import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/time_line/controller/create_user_post_controller.dart';
import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post/create_user_post_is_ergent_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post/create_user_post_patient_age_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post/create_user_post_patient_diseases_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post/create_user_post_patient_gender_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post/create_user_post_question_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post/create_user_post_searching_specialization_widget.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPost extends StatelessWidget {
  const CreateUserPost({super.key});
  static const String route = '/createUserPost';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateUserPostController());

    controller.postModel.user =
        AuthenticationController.find.currentUser as UserModel;

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'إسأل طبيب ',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        leading: TextButton(
          onPressed: () {
            if (controller.tempContent != null &&
                controller.tempContent!.trim() != '') {
              controller.postModel.content = controller.tempContent;
              controller.postModel.timeStamp = Timestamp.now();
              PostController.find.uploadUserPost(controller.postModel);
              Get.back();
              controller.onDelete();
            } else {
              MySnackBar.showSnackBar(context, 'من فضلك أدخل سؤالك');
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'نشر',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
              controller.onDelete();
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              right: 10.0,
              left: 10.0,
              bottom: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserNameAndPicWidget(
                  userName: controller.currentUserName,
                  userPic: controller.currentUserPersonalImage,
                ),
                const SizedBox(height: 30),
                const CreateUserPostSearchingSpecializationWidget(),
                const SizedBox(height: 30),
                const CreateUserPostIsErgentWidget(),
                const SizedBox(height: 30),
                const CreateUserPostPatientAgeWidget(),
                const SizedBox(height: 30),
                const CreateUserPostPatientGenderWidget(),
                const SizedBox(height: 30),
                const CreateUserPostPatientDiseasesWidget(),
                const SizedBox(height: 30),
                const CreateUserPostQuestionWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
