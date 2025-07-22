import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazistory/l10n/app_localizations.dart';

import 'package:lazistory/model/app_config.dart';
import 'package:lazistory/model/clipboard_history.dart';
import 'package:lazistory/ui/settings.dart';
import 'package:lazistory/ui/list_element.dart';

final scrollController = ScrollController();
final scrollOffsetStateProvider = StateProvider((ref) => 0.0);

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: 0.0 < ref.watch(scrollOffsetStateProvider)
          ? FloatingActionButton(
              onPressed: () {
                scrollController.animateTo(
                  0.0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: Colors.green[200],
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        centerTitle: true,
        title: TextField(
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchClipboardHistory,
            icon: Icon(Icons.search),
          ),
          onChanged: (value) {
            ref.read(clipboardHistoryStateNotifierProvider.notifier).setFilter(value);
          },
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: Icon(Icons.warning_rounded, color: Colors.yellow[600]),
                      content: Text(AppLocalizations.of(context)!.clearHistoryContent),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.cancelDeletion),
                        ),
                        FilledButton(
                          onPressed: () {
                            ref.read(clipboardHistoryStateNotifierProvider.notifier).clear();
                            if (ref.watch(lazistoryAppConfigProvider).restorePreviousState) {
                              ref.watch(clipboardHistoryStateNotifierProvider).saveHistory();
                            }
                            final snackBar = SnackBar(
                              content: Text(AppLocalizations.of(context)!.historyCleared),
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.red[400],
                          ),
                          child: Text(AppLocalizations.of(context)!.confirmDeletion),
                        ),
                      ],
                    );
                  });
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

    scrollController.addListener(() {
      ref.read(scrollOffsetStateProvider.notifier).state = scrollController.offset;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  late String? ignore;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        controller: scrollController,
        itemCount: ref.watch(clipboardHistoryStateNotifierProvider).filteredLength(),
        itemBuilder: (BuildContext context, int index) {
          return ListElement(ref.watch(clipboardHistoryStateNotifierProvider).filtered[index]);
        },
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
