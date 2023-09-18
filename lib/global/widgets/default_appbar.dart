import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    Key? key,
    required this.title,
    this.leading,
  }) : super(key: key);

  final String title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: (size.width < 330) ? 17 : 20,
          ),
        ),
      ),
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
