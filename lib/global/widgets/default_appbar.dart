import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.centerTitle = false,
    this.height = 55.0,
  }) : super(key: key);

  final String title;
  final Widget? leading;
  final bool centerTitle;
  final double height;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      actions: [
        Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_forward),
              )
            : const SizedBox(),
      ],
      title: Align(
        alignment: centerTitle ? Alignment.center : Alignment.centerRight,
        child: Text(
          title,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
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
  Size get preferredSize => Size.fromHeight(height);
}
