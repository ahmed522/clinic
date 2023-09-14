import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 50,
              shadows: [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 0.5,
                  blurRadius: 1,
                  offset: Offset(0, 0.5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                'حدثت مشكلة، يرجى إعادة المحاولة',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontSize: 15,
                  shadows: [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 0.2,
                      blurRadius: 1,
                      offset: Offset(0, 0.2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
