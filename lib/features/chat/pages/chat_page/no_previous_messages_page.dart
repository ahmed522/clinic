import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoPreviousMessagesPage extends StatelessWidget {
  const NoPreviousMessagesPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/img/no-previous-chat.svg',
              width: size.width - 50,
              height: size.width - 50,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Text(
                'لا توجد رسائل مسبقة، أرسل رسالة',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
