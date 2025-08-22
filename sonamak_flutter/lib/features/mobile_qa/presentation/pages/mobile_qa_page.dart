import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sonamak_flutter/app/localization/locale_manager.dart';
import 'package:sonamak_flutter/core/mobile/responsive_scaffold.dart';
import 'package:sonamak_flutter/core/mobile/hide_show.dart';
import 'package:sonamak_flutter/core/mobile/widgets/sticky_action_bar.dart';
import 'package:sonamak_flutter/core/mobile/widgets/adaptive_padding.dart';
import 'package:sonamak_flutter/core/mobile/input/arabic_digit_formatter.dart';
import 'package:sonamak_flutter/core/mobile/input/phone_with_country_formatter.dart';

class MobileQaPage extends StatefulWidget {
  const MobileQaPage({super.key});
  @override
  State<MobileQaPage> createState() => _MobileQaPageState();
}

class _MobileQaPageState extends State<MobileQaPage> {
  final _phone = TextEditingController(text: '+20 10');
  final _amount = TextEditingController(text: '12345.67');
  bool _useArabicDigits = false;

  void _switchTo(String code) {
    LocaleManager.set(Locale(code));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final formatters = _useArabicDigits ? [ArabicIndicDigitInputFormatter()] : <TextInputFormatter>[];
    return ResponsiveScaffold(
      title: 'Mobile QA — Layout & Input',
      actions: [
        TextButton(onPressed: () => _switchTo('en'), child: const Text('EN')),
        TextButton(onPressed: () => _switchTo('ar'), child: const Text('AR')),
      ],
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const Text('Adaptive layout demo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const AdaptivePadding(child: Text('Padding adjusts by width. Resize device/emulator to observe.')),
                const SizedBox(height: 16),
                const Text('Phone input with country code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [PhoneWithCountryFormatter(defaultCountryCode: '+20')],
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '+20 100 000 0000'),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Amount (ASCII digits)', style: TextStyle(fontWeight: FontWeight.w600)),
                    TextField(controller: _amount, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '12345.67')),
                  ])),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Text('Arabic-Indic digits'), Switch(value: _useArabicDigits, onChanged: (v) => setState(() => _useArabicDigits = v)),
                    ]),
                    TextField(controller: _amount, inputFormatters: formatters, keyboardType: TextInputType.text, decoration: const InputDecoration(border: OutlineInputBorder())),
                    const SizedBox(height: 6),
                    const Text('Toggle to see live conversion on input (for demo). For display-only, render numbers via localization.'),
                  ])),
                ]),
                const SizedBox(height: 16),
                const Text('Hide/Show helpers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const ShowOnSmall(child: Text('Visible on SMALL screens')),
                const HideOnSmall(child: Text('Hidden on SMALL screens (visible on tablet/desktop)')),
                const SizedBox(height: 60),
              ],
            ),
          ),
          const StickyActionBar(children: [
            OutlinedButton(onPressed: null, child: Text('Cancel')),
            ElevatedButton(onPressed: null, child: Text('Save')),
          ]),
        ],
      ),
    );
  }
}
