import 'package:clinic/global/routes/routes.dart';
import 'package:clinic/UI/pages/start_page.dart';
import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'global/theme/theme_data/theme_data_light.dart';

main() => runApp(const MainWidget());

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getThemeDataLight(),
      initialRoute: StartPage.route,
      routes: routes,
    );
  }
}
