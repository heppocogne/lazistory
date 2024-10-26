import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:lazistory/ui/main_view.dart';

class LazistoryApp extends StatelessWidget {
  const LazistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lazistory',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      //locale: Locale('en'),
      home: MainView(),
    );
  }
}
