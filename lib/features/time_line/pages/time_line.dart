import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/features/time_line/pages/post/user_post/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة'),
        centerTitle: true,
      ),
      body: GetX(builder: (context) {
        return ListView(
          children: [
            const SizedBox(height: 10),
            const SizedBox(height: 100),
          ],
        );
      }),
    );
  }
}
