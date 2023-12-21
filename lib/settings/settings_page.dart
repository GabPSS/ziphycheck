import 'package:checkup_app/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsButtonLabel),
      ),
      body: Consumer<Settings>(
        builder: (context, settings, child) => ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(
                  AppLocalizations.of(context)!.reportLanguageSettingLabel),
              subtitle: Text(settings.reportOutputLanguage != null
                  ? Settings.availableLocales.entries
                      .singleWhere((element) =>
                          element.value == settings.reportOutputLanguage)
                      .key
                  : AppLocalizations.of(context)!.systemDefaultLanguage),
              onTap: () async {
                var locale = await showDialog<String?>(
                    context: context,
                    builder: (context) => SimpleDialog(
                          title: Text(AppLocalizations.of(context)!
                              .selectLanguageDialogTitle),
                          children: <String, String?>{
                            AppLocalizations.of(context)!.systemDefaultLanguage:
                                null
                          }
                              .entries
                              .followedBy(Settings.availableLocales.entries)
                              .map((e) => ListTile(
                                    title: Text(e.key),
                                    onTap: () {
                                      Navigator.pop(context, e.value);
                                    },
                                  ))
                              .toList(),
                        ));
                settings.setReportOutputLocale(locale);
              },
            )
          ],
        ),
      ),
    );
  }
}
