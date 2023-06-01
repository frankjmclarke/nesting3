import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_starter/controllers/controllers.dart';
import 'package:flutter_starter/constants/constants.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/storage_controller.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put<AuthController>(AuthController());//registers an instance of the AuthController class as a dependency, making it available for other parts of the application to use.
  Get.put<ThemeController>(ThemeController());
  Get.put<LanguageController>(LanguageController());
  Get.put<StorageController>(StorageController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromStore();
    return GetBuilder<LanguageController>(
      builder: (languageController) => Loading(
        child: Sizer(
          builder: (context, orientation, deviceType) => GetMaterialApp(
            translations: Localization(),
            locale: languageController.getLocale,
            navigatorObservers: [
              // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
            ],
            debugShowCheckedModeBanner: false,
            //defaultTransition: Transition.fade,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: "/",
            getPages: AppRoutes.routes,
          ),
        ),
      ),
    );
  }
}
