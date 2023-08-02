import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/firebase_options.dart';
import 'package:clinic/global/routes/routes.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'global/theme/app_theme.dart';
import 'package:flutter/services.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationController()));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MainWidget());
  });
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      routes: routes,
      home: const Center(
        child: AppCircularProgressIndicator(width: 100, height: 100),
      ),
    );
  }
}
