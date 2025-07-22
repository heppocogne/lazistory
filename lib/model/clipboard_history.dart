import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toml/toml.dart';

import 'package:lazistory/model/app_config.dart';
import 'package:lazistory/model/file_location.dart';

class ClipboardHistory {
  static final saveFilePath = '${appDocumentsDirectory.path}/history.toml';

  ClipboardHistory(this.history, this.filter) {
    if (filter == '') {
      filtered = history;
    } else {
      final lowerCaseFilter = filter.toLowerCase();
      filtered = history.where((str) {
        return str.toLowerCase().contains(lowerCaseFilter);
      }).toList();
    }
  }

  final List<String> history;
  late List<String> filtered;
  final String filter;

  static ClipboardHistory restored() {
    final file = File(saveFilePath);
    if (file.existsSync()) {
      final String toml = file.readAsStringSync();
      final doc = TomlDocument.parse(toml);
      final list = doc.toMap()['history'] as List;
      return ClipboardHistory(list.map((elem) => elem.toString()).toList(), '');
    }
    return ClipboardHistory([], '');
  }

  Future<void> saveHistory() async {
    Map<String, List<String>> map = {
      'history': history,
    };
    var doc = TomlDocument.fromMap(map);
    final file = File(saveFilePath);
    await file.writeAsString(doc.toString());
  }

  int filteredLength() {
    return filtered.length;
  }
}

class ClipboardHistoryStateNotifier extends StateNotifier<ClipboardHistory> {
  ClipboardHistoryStateNotifier(super.state);

  void clear() {
    state = ClipboardHistory([], state.filter);
  }

  void pushFront(String str, bool keepUnique, int maxLength) {
    List<String> list;
    if (keepUnique) {
      list = [str, ...(state.history.where((elem) => elem != str))];
    } else {
      list = [str, ...state.history];
    }

    if (list.length < maxLength) {
      state = ClipboardHistory(list, state.filter);
    } else {
      state = ClipboardHistory(list.sublist(0, maxLength), state.filter);
    }
  }

  void setFilter(String filter) {
    state = ClipboardHistory(state.history, filter);
  }

  int length() {
    return state.filteredLength();
  }

  String? get(int index) {
    if (index < 0 || length() <= index) {
      return null;
    } else {
      return state.filtered[index];
    }
  }
}

final clipboardHistoryStateNotifierProvider = StateNotifierProvider<ClipboardHistoryStateNotifier, ClipboardHistory>((ref) {
  if (ref.watch(lazistoryAppConfigProvider).restorePreviousState) {
    return ClipboardHistoryStateNotifier(ClipboardHistory.restored());
  } else {
    return ClipboardHistoryStateNotifier(ClipboardHistory([], ''));
  }
});
