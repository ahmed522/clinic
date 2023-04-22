import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/features/time_line/pages/post/user_post/post_widget.dart';
import 'package:flutter/material.dart';

class TimeLine extends StatelessWidget {
  TimeLine({super.key});
  final List<Widget> content = [
    const SizedBox(height: 10),
    PostWidget(
      post: UserPostModel()
        ..user.firstName = 'ahmed'
        ..user.lastName = 'abdelaal'
        ..isErgent = true,
    ),
    PostWidget(
        post: UserPostModel()
          ..user.firstName = 'ahmed'
          ..user.lastName = 'abdelaal'),
    PostWidget(
        post: UserPostModel()
          ..user.firstName = 'ahmed'
          ..user.lastName = 'abdelaal'),
    PostWidget(
        post: UserPostModel()
          ..user.firstName = 'إسراء'
          ..user.lastName = 'حسين'
          ..user.gender = Gender.female
          ..isErgent = true
          ..searchingSpecialization = 'طبيب القلب والأوعية الدموية'
          ..patientGender = Gender.female
          ..patientDiseases = ['القولون', 'المرئ', 'السكري', 'الضغط']
          ..patientAge['years'] = 25
          ..patientAge['months'] = 6
          ..patientAge['days'] = 0),
    PostWidget(
      post: UserPostModel()
        ..user.firstName = 'ahmed'
        ..user.lastName = 'abdelaal'
        ..isErgent = true,
    ),
    PostWidget(
      post: UserPostModel()
        ..user.firstName = 'ahmed'
        ..user.lastName = 'abdelaal'
        ..isErgent = true,
    ),
    const SizedBox(height: 100),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: content.length,
        itemBuilder: (context, index) => content[index],
      ),
    );
  }
}
