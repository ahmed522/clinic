import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.imageAsset, required this.message});
  final String imageAsset;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imageAsset,
            height: 200,
            width: 200,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
