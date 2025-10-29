import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  final bool showAsDialog;

  const LanguageSwitcher({
    super.key,
    this.showAsDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    if (showAsDialog) {
      return IconButton(
        icon: const Icon(Icons.language),
        onPressed: () => _showLanguageDialog(context, localeProvider, l10n),
      );
    }

    return _buildLanguageSelector(context, localeProvider, l10n);
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    LocaleProvider localeProvider,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            RadioListTile<Locale>(
              title: Row(
                children: [
                  const Text('🇰🇿', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(l10n.kazakh),
                ],
              ),
              value: const Locale('kk'),
              groupValue: localeProvider.locale,
              onChanged: (Locale? value) {
                if (value != null) {
                  localeProvider.setLocale(value);
                }
              },
            ),
            RadioListTile<Locale>(
              title: Row(
                children: [
                  const Text('🇷🇺', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(l10n.russian),
                ],
              ),
              value: const Locale('ru'),
              groupValue: localeProvider.locale,
              onChanged: (Locale? value) {
                if (value != null) {
                  localeProvider.setLocale(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LocaleProvider localeProvider,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇰🇿', style: TextStyle(fontSize: 32)),
              title: Text(l10n.kazakh),
              onTap: () {
                localeProvider.setLocale(const Locale('kk'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇷🇺', style: TextStyle(fontSize: 32)),
              title: Text(l10n.russian),
              onTap: () {
                localeProvider.setLocale(const Locale('ru'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
