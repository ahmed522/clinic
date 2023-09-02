import 'package:clinic/global/widgets/appbar_clipper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: size.height / 7,
      actions: [
        Navigator.canPop(context)
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 35,
                    shadows: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
      title: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: (size.width > 330) ? 30 : 20,
          shadows: const [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
      ),
      shape: const AppbarClipper(),
    );
  }
}
