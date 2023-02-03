import 'package:clinic/pages/start_page.dart';
import 'package:flutter/material.dart';

import 'core/global/theme/theme_data/theme_data_light.dart';

main() => runApp(const MainWidget());

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getThemeDataLight(),
      home: const StartPage(),
    );
  }
}
