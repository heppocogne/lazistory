import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:lazistory/model/app_config.dart';
import 'package:lazistory/model/clipboard_history.dart';
import 'package:lazistory/ui/settings.dart';
import 'package:lazistory/ui/list_element.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.clipboardHistory,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          /*
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.pause),
          ),
          */
          IconButton(
            onPressed: () {
              ref.read(clipboardHistoryStateNotifierProvider.notifier).clear();
              if (ref.watch(lazistoryAppConfigProvider).restorePreviousState) {
                ref.watch(clipboardHistoryStateNotifierProvider).saveHistory();
              }
              final snackBar = SnackBar(
                content: Text(AppLocalizations.of(context)!.historyCleared),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ),
      body: const LazistoryHome(),
    );
  }
}

class LazistoryHome extends ConsumerStatefulWidget {
  const LazistoryHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LazistoryHomeState();
  }
}

class _LazistoryHomeState extends ConsumerState<LazistoryHome> with ClipboardListener {
  @override
  void initState() {
    super.initState();
    Clipboard.getData('text/plain').then((data) {
      ignore = data?.text;
      debugPrint('ignore: $ignore');

      clipboardWatcher.addListener(this);
      clipboardWatcher.start();
    });
  }

  late String? ignore;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // AnimatedListが良いか?
        child: Column(
          children: ref.watch(clipboardHistoryStateNotifierProvider).history.map((str) {
            return ListElement(str);
          }).toList(),
        ),
      ),
    );
  }

  @override
  void onClipboardChanged() async {
    ClipboardData? newClipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? text = newClipboardData?.text;
    if (text == null) {
      return;
    } else if (text == ignore) {
      // NOTE: 起動前のクリップボードの状態を取得しないようにするため
      ignore = null;
      return;
    }

    if (text != '') {
      ref.read(clipboardHistoryStateNotifierProvider.notifier).pushFront(
            text,
            ref.watch(lazistoryAppConfigProvider).keepHistoryUnique,
            ref.watch(lazistoryAppConfigProvider).maxHistoryLength,
          );
      if (ref.watch(lazistoryAppConfigProvider).restorePreviousState) {
        ref.watch(clipboardHistoryStateNotifierProvider).saveHistory();
      }
    }
  }
}
