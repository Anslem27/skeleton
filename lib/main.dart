import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeleton/app/helpers/constants.dart';
import 'package:skeleton/app/theme/theme.dart';

import 'app/helpers/core/http_helper.dart';
import 'app/helpers/core/shared_prefs.dart';
import 'app/helpers/logger.dart';
import 'app/helpers/managers/theme_manager.dart';
import 'app/screens/navigation_wrapper.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

import 'hive/hive_adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    /* ios and android */
    final appDocumentDirectory = await path_provider
        .getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDirectory.path)
      ..registerAdapter(LogEntryAdapter());
  }

  await Prefs.prefs.getPrefs();
  await LogService.initialize();
  LogService.setupLogger();

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((value) => runApp(MyApp()));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeManager themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<Prefs>(create: (_) => Prefs.prefs)],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<HttpHelper>(
            create: (_) => HttpHelper.httpHelper,
          ),
        ],
        child: Consumer<Prefs>(
          builder: (context, prefs, child) {
            return MaterialApp(
              navigatorKey: MyApp.navigatorKey,
              title: '${Constants.appName} Skeleton',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: prefs.themeMode,
              home: NavigationWrapper(),
            );
          },
        ),
      ),
    );
  }
}
