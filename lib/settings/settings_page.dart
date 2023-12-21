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
            SettingsDialogListTile<String?>(
              leading: const Icon(Icons.language),
              title: Text(
                  AppLocalizations.of(context)!.reportLanguageSettingLabel),
              subtitle: Text(settings.reportOutputLanguage != null
                  ? Settings.availableLocales.entries
                      .singleWhere((element) =>
                          element.value == settings.reportOutputLanguage)
                      .key
                  : AppLocalizations.of(context)!.systemDefaultLanguage),
              dialog: SimpleDialog(
                title: Text(
                    AppLocalizations.of(context)!.selectLanguageDialogTitle),
                children: <String, String?>{
                  AppLocalizations.of(context)!.systemDefaultLanguage: null
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
              ),
              onClose: (value) => settings.setReportOutputLocale(value),
            ),
            SettingsDialogListTile<bool?>(
              leading: const Icon(Icons.light_mode),
              title: Text(AppLocalizations.of(context)!.appThemeSettingLabel),
              subtitle: Text(switch (settings.darkTheme) {
                null => AppLocalizations.of(context)!.systemDefaultLanguage,
                false => AppLocalizations.of(context)!.lightThemeSettingLabel,
                true => AppLocalizations.of(context)!.darkThemeSettingLabel,
              }),
              dialog: SimpleDialog(
                title:
                    Text(AppLocalizations.of(context)!.selectThemeDialogTitle),
                children: <String, bool?>{
                  AppLocalizations.of(context)!.systemDefaultLanguage: null,
                  AppLocalizations.of(context)!.lightThemeSettingLabel: false,
                  AppLocalizations.of(context)!.darkThemeSettingLabel: true,
                }
                    .entries
                    .map((e) => ListTile(
                          title: Text(e.key),
                          onTap: () {
                            Navigator.pop(context, e.value);
                          },
                        ))
                    .toList(),
              ),
              onClose: (darkTheme) => settings.darkTheme = darkTheme,
            ),
            SwitchListTile(
              title: Text(
                  AppLocalizations.of(context)!.useDynamicColorSettingLabel),
              value: settings.useDynamicColor,
              onChanged: (value) => settings.useDynamicColor = value,
            )
          ],
        ),
      ),
    );
  }
}

class SettingsDialogListTile<T> extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget dialog;
  final Function(T?) onClose;

  const SettingsDialogListTile(
      {super.key,
      this.leading,
      this.title,
      this.subtitle,
      required this.dialog,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: () async {
        T? output = await showDialog<T>(
          context: context,
          builder: (context) => dialog,
        );
        onClose(output);
      },
    );
  }
}
