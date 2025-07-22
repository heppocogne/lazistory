import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazistory/l10n/app_localizations.dart';

import 'package:lazistory/model/app_config.dart';
import 'package:lazistory/ui/settings_view.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: Text(
          AppLocalizations.of(context)!.configurations,
          style: const TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () async {
            await ref.read(lazistoryAppConfigProvider).saveConfig();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SettingsView(),
    );
  }
}
