import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';

class Bootstrap {
  Bootstrap._();

  static Future<void> initCore() async {
    await dotenv.load(fileName: '.env');

    // await Future.wait([
    //   _safeInit('ads', _initializeMobileAds()),
    //   _safeInit('db', AppDatabase.init()),
    // ]);
  }

  // static Future<void> _safeInit(String name, Future<void> task) async {
  //   try {
  //     await task.timeout(const Duration(seconds: 5));
  //     logger.d('[초기화]:: $name 성공');
  //   } catch (e) {
  //     logger.e('[초기화]:: $name 실패 :: $e');
  //   }
  // }

  /// 시스템 UI 초기화
  static Future<void> initSystem() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.transparent,
      ),
    );

    if (kDebugMode) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
}
