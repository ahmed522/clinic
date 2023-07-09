import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class ReactIcon extends StatelessWidget {
  const ReactIcon({
    Key? key,
    required this.reacted,
  }) : super(key: key);

  final bool reacted;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.favorite_rounded,
      color: reacted
          ? Colors.red
          : (CommonFunctions.isLightMode(context))
              ? Colors.black87
              : Colors.white70,
    );
  }
}
