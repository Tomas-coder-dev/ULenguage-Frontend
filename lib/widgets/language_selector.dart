import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Corrige la import para tu estructura de localización:
import '../../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle:
          Text(_getLanguageName(localeProvider.locale.languageCode, l10n)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showLanguageDialog(context, localeProvider, l10n);
      },
    );
  }

  String _getLanguageName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'es':
        return l10n.spanish;
      case 'en':
        return l10n.english;
      case 'qu':
        return l10n.quechua;
      default:
        return l10n.spanish;
    }
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
            _buildLanguageOption(
              context,
              localeProvider,
              const Locale('es'),
              l10n.spanish,
              '🇪🇸',
            ),
            _buildLanguageOption(
              context,
              localeProvider,
              const Locale('en'),
              l10n.english,
              '🇺🇸',
            ),
            _buildLanguageOption(
              context,
              localeProvider,
              const Locale('qu'),
              l10n.quechua,
              '🏔️',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LocaleProvider localeProvider,
    Locale locale,
    String name,
    String flag,
  ) {
    final isSelected =
        localeProvider.locale.languageCode == locale.languageCode;

    return RadioListTile<Locale>(
      value: locale,
      groupValue: localeProvider.locale,
      title: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Text(name),
        ],
      ),
      selected: isSelected,
      onChanged: (Locale? value) {
        if (value != null) {
          localeProvider.setLocale(value);
          Navigator.pop(context);
        }
      },
    );
  }
}
