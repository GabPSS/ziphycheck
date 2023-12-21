import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/settings/settings.dart';
import 'package:checkup_app/ui/home_page.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DataMaster dm = DataMaster();
  await dm.init();

  Settings settings = Settings();
  await settings.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DataMaster>(create: (context) => dm),
        ChangeNotifierProvider<Settings>(create: (context) => settings)
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => Consumer<Settings>(
        builder: (context, settings, child) {
          if (lightDynamic == darkDynamic || !settings.useDynamicColor) {
            lightDynamic = const ColorScheme.light(primary: Colors.orange);
            darkDynamic = const ColorScheme.dark(primary: Colors.orange);
          }

          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('pt', 'BR'),
            ],
            theme: ThemeData(
                colorScheme: settings.darkTheme != null
                    ? settings.darkTheme!
                        ? darkDynamic
                        : lightDynamic
                    : lightDynamic,
                useMaterial3: true),
            darkTheme: ThemeData(
                colorScheme: settings.darkTheme != null
                    ? settings.darkTheme!
                        ? darkDynamic
                        : lightDynamic
                    : darkDynamic,
                useMaterial3: true),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
