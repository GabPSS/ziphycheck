import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/settings/settings.dart';
import 'package:ziphycheck/ui/home_page.dart';
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
          ColorScheme? light = lightDynamic;
          ColorScheme? dark = darkDynamic;

          if (lightDynamic == darkDynamic || !settings.useDynamicColor) {
            light = const ColorScheme.light(primary: Colors.orange);
            dark = const ColorScheme.dark(primary: Colors.orange);
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
                        ? dark
                        : light
                    : light,
                useMaterial3: true),
            darkTheme: ThemeData(
                colorScheme: settings.darkTheme != null
                    ? settings.darkTheme!
                        ? dark
                        : light
                    : dark,
                useMaterial3: true),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
