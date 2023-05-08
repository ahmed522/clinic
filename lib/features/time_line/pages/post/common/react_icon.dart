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
          : (Theme.of(context).brightness == Brightness.light)
              ? Colors.black87
              : Colors.white70,
    );
  }
}
