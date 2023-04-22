import 'package:flutter/material.dart';

class SignWithGoogle extends StatelessWidget {
  const SignWithGoogle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: Theme.of(context).elevatedButtonTheme.style,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/google.png',
              width: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
