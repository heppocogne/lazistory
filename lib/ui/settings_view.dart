import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:lazistory/l10n/app_localizations.dart';

import 'package:lazistory/model/app_config.dart';
import 'package:lazistory/model/clipboard_history.dart';

class SettingsView extends ConsumerStatefulWidget {
  SettingsView({super.key});
  final maxHistoryLengthController = TextEditingController();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SettingsViewState();
  }
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  void initState() {
    super.initState();
    widget.maxHistoryLengthController.text = LazistoryAppConfig.load().maxHistoryLength.toString();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    widget.maxHistoryLengthController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 360,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.maxHistoryLength),
                    const Spacer(),
                    Flexible(
                      child: TextFormField(
                        controller: widget.maxHistoryLengthController,
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          var intValue = int.parse(value);
                          intValue = max(1, min(intValue, 65536));
                          widget.maxHistoryLengthController.text = intValue.toString();
                          ref
                              .read(lazistoryAppConfigProvider.notifier)
                              .setMaxHistoryLength(intValue);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.keepHistoryUnique),
                    const Spacer(),
                    Switch(
                        value: ref.watch(lazistoryAppConfigProvider).keepHistoryUnique,
                        onChanged: (value) {
                          ref.read(lazistoryAppConfigProvider.notifier).setKeepHistoryUnique(value);
                          setState(() {});
                        }),
                  ],
                ),
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.windowAlwaysOnTop),
                    const Spacer(),
                    Switch(
                      value: ref.watch(lazistoryAppConfigProvider).windowAlwaysOnTop,
                      onChanged: (value) {
                        WindowManager.instance.setAlwaysOnTop(value);
                        ref.read(lazistoryAppConfigProvider.notifier).setWindowAlwaysOnTop(value);
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.restorePreviousState),
                    const Spacer(),
                    Switch(
                      value: ref.watch(lazistoryAppConfigProvider).restorePreviousState,
                      onChanged: (value) {
                        ref
                            .read(lazistoryAppConfigProvider.notifier)
                            .setRestorePreviousState(value);
                        if (value) {
                          ref.watch(clipboardHistoryStateNotifierProvider).saveHistory();
                        }
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                OutlinedButton(
                  onPressed: () {
                    final config = LazistoryAppConfig();
                    ref.read(lazistoryAppConfigProvider.notifier).setConfig(config);
                    widget.maxHistoryLengthController.text = config.maxHistoryLength.toString();
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.red[400],
                    side: BorderSide(
                      color: Colors.red[400]!,
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.restoreDefaultConfigurations),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
