import 'dart:async';

import 'package:client/core/di.dart';
import 'package:client/core/routes.dart';
import 'package:client/core/theme.dart';
import 'package:client/core/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await runZonedGuarded(() async {
    await EasyLocalization.ensureInitialized();
    await dotenv.load(fileName: '.env');
  }, (Object object, StackTrace stackTrace) {
    logger
      ..e(object)
      ..e(stackTrace);
  });

  await DI.init();

  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: const [
      Locale('vi'),
      Locale('en'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('vi'),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.mainTheme,
      routes: routes,
      initialRoute: Routes.login,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
