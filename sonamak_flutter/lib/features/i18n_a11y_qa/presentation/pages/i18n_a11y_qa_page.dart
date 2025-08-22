import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/locale_manager.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/a11y/announce.dart';
import 'package:sonamak_flutter/core/a11y/focus_trap.dart';
import 'package:sonamak_flutter/core/keyboard/shortcuts_registry.dart';

class I18nA11yQaPage extends StatefulWidget {
  const I18nA11yQaPage({super.key});
  @override
  State<I18nA11yQaPage> createState() => _I18nA11yQaPageState();
}

class _I18nA11yQaPageState extends State<I18nA11yQaPage> {
  String _last = '';

  void _setLang(String code) {
    LocaleManager.set(Locale(code));
    setState(() {});
    announce(context, 'Language switched to $code');
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('i18n & A11y QA')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FocusTrap(
            child: GlobalShortcuts(
              onSave: () => setState(() => _last = 'Save (Ctrl/Cmd+S)'),
              onSearch: () => setState(() => _last = 'Search (Ctrl/Cmd+F)'),
              onPrint: () => setState(() => _last = 'Print (Ctrl/Cmd+P)'),
              onNew: () => setState(() => _last = 'New (Ctrl/Cmd+N)'),
              child: ListView(children: [
                const Text('Localization strings', style: TextStyle(fontWeight: FontWeight.w700)),
                Text('Locale: \${Localizations.localeOf(context).toLanguageTag()}'),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  ElevatedButton(onPressed: () => _setLang('en'), child: const Text('EN')),
                  ElevatedButton(onPressed: () => _setLang('ar'), child: const Text('AR')),
                ]),
                const Divider(height: 24),
                const Text('Keyboard shortcuts', style: TextStyle(fontWeight: FontWeight.w700)),
                const Text('Try: Ctrl/Cmd + S, F, P, N'),
                const SizedBox(height: 8),
                if (_last.isNotEmpty) Text('Last: $_last'),
                const Divider(height: 24),
                const Text('Focus trap', style: TextStyle(fontWeight: FontWeight.w700)),
                const Text('Tab/Shift+Tab cycles within this page only.'),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: [
                  OutlinedButton(onPressed: () {}, child: const Text('Dummy 1')),
                  OutlinedButton(onPressed: () {}, child: const Text('Dummy 2')),
                  OutlinedButton(onPressed: () {}, child: const Text('Dummy 3')),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
